import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmxbuddy/providers/auth_provider.dart';
import 'package:farmxbuddy/providers/theme_provider.dart';
import 'package:farmxbuddy/screens/profile_screen.dart';
import 'package:farmxbuddy/screens/soil_analysis_screen.dart';
import 'package:farmxbuddy/screens/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmXBuddy'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${authProvider.username}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const Text(
              'What would you like to do today?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'Soil Analysis',
                    Icons.landscape,
                    Colors.green,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SoilAnalysisScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    'Crop Recommendations',
                    Icons.eco,
                    Colors.teal,
                    () {
                      // This would be linked to the soil analysis results
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please analyze soil first'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    'Weather',
                    Icons.cloud,
                    Colors.blue,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WeatherScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    'My Profile',
                    Icons.person,
                    Colors.orange,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: color,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
