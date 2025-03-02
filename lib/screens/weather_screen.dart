import 'package:flutter/material.dart';
import 'package:farmxbuddy/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }

      final position = await Geolocator.getCurrentPosition();
      final weatherData = await WeatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      if (weatherData != null && weatherData.containsKey('error')) {
        throw Exception(weatherData['error']);
      }

      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getWeatherByCity() async {
    if (_cityController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weatherData = await WeatherService.getWeatherByCity(_cityController.text);

      if (weatherData != null && weatherData.containsKey('error')) {
        throw Exception(weatherData['error']);
      }

      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City Name',
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getWeatherByCity,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (_) => _getWeatherByCity(),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getCurrentLocationWeather,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Use Current Location'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              )
            else if (_weatherData != null)
                Expanded(
                  child: _buildWeatherInfo(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    final weather = _weatherData!;
    final temp = weather['temperature'];
    final feelsLike = weather['feelsLike'];
    final description = weather['description'];
    final icon = weather['icon'];
    final humidity = weather['humidity'];
    final windSpeed = weather['windSpeed'];
    final cityName = weather['city'];
    final country = weather['country'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$cityName, $country',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Image.network(
            'https://openweathermap.org/img/wn/$icon@2x.png',
            width: 100,
            height: 100,
          ),
          Text(
            '${temp.toStringAsFixed(1)}°C',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Feels like: ${feelsLike.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherDetail(
                        Icons.water_drop,
                        'Humidity',
                        '$humidity%',
                      ),
                      _buildWeatherDetail(
                        Icons.air,
                        'Wind',
                        '${windSpeed.toStringAsFixed(1)} m/s',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Farming Tips Based on Weather',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _getWeatherTips(description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _getWeatherTips(String weatherDescription) {
    String tips;

    if (weatherDescription.contains('rain') || weatherDescription.contains('drizzle') || weatherDescription.contains('shower')) {
      tips = '• Avoid spraying pesticides or fertilizers\n• Check drainage systems\n• Delay harvesting if possible\n• Protect seedlings from heavy rain';
    } else if (weatherDescription.contains('cloud')) {
      tips = '• Good conditions for transplanting\n• Moderate watering recommended\n• Good time for light field work\n• Consider foliar feeding';
    } else if (weatherDescription.contains('clear') || weatherDescription.contains('sun')) {
      tips = '• Water plants early morning or evening\n• Use mulch to retain moisture\n• Provide shade for sensitive crops\n• Good time for harvesting';
    } else if (weatherDescription.contains('snow') || weatherDescription.contains('ice') || weatherDescription.contains('freez')) {
      tips = '• Protect plants from frost damage\n• Avoid disturbing frozen soil\n• Check greenhouse heating\n• Delay planting until conditions improve';
    } else if (weatherDescription.contains('fog') || weatherDescription.contains('mist')) {
      tips = '• Watch for fungal diseases\n• Delay spraying operations\n• Good conditions for grafting\n• Reduce irrigation';
    } else if (weatherDescription.contains('wind') || weatherDescription.contains('storm')) {
      tips = '• Secure young plants and trees\n• Delay spraying operations\n• Provide windbreaks if possible\n• Check for damage after strong winds';
    } else {
      tips = '• Monitor soil moisture levels\n• Adjust irrigation based on conditions\n• Check weather forecast for planning\n• Observe plants for stress signs';
    }

    return Text(tips);
  }
}