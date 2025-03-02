import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '3f1f92a4e6f72016181439df0069d224'; // Your API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Get weather by city
  static Future<Map<String, dynamic>?> getWeatherByCity(String city) async {
    try {
      final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
      final response = await http.get(url);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data.containsKey('name') && data.containsKey('main') && data['main'] != null && data.containsKey('weather') && data['weather'].isNotEmpty) {
          return {
            'city': data['name'],
            'temperature': data['main']['temp'],
            'description': data['weather'][0]['description'],
            'icon': data['weather'][0]['icon'],
            'humidity': data['main']['humidity'],
            'windSpeed': data['wind']['speed'],
            'feelsLike': data['main']['feels_like'],
            'country': data['sys']['country'],
          };
        } else {
          print('Error: Missing necessary data in the response');
          return {'error': 'Unable to fetch weather data. Missing necessary data.'};
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return {'error': 'Unable to fetch weather data. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'Unable to fetch weather data. Exception: $e'};
    }
  }

  // Get weather by location (latitude and longitude)
  static Future<Map<String, dynamic>?> getWeatherByLocation(double lat, double lon) async {
    try {
      final url = Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
      final response = await http.get(url);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data.containsKey('name') && data.containsKey('main') && data['main'] != null && data.containsKey('weather') && data['weather'].isNotEmpty) {
          return {
            'city': data['name'],
            'temperature': data['main']['temp'],
            'description': data['weather'][0]['description'],
            'icon': data['weather'][0]['icon'],
            'humidity': data['main']['humidity'],
            'windSpeed': data['wind']['speed'],
            'feelsLike': data['main']['feels_like'],
            'country': data['sys']['country'],
          };
        } else {
          print('Error: Missing necessary data in the response');
          return {'error': 'Unable to fetch weather data. Missing necessary data.'};
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return {'error': 'Unable to fetch weather data. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'Unable to fetch weather data. Exception: $e'};
    }
  }
}