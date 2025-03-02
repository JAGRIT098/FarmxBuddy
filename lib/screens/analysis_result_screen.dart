import 'dart:io';
import 'package:flutter/material.dart';

class AnalysisResultScreen extends StatelessWidget {
  final String soilType;
  final List<String> suitableCrops;
  final File imageFile;

  const AnalysisResultScreen({
    super.key,
    required this.soilType,
    required this.suitableCrops,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  imageFile,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
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
                        'Soil Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        soilType,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 5),
                      _getSoilDescription(soilType),
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
                        'Suitable Crops',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: suitableCrops.map((crop) {
                          return Chip(
                            label: Text(crop),
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          );
                        }).toList(),
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
                        'Recommendations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _getSoilRecommendations(soilType),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('ANALYZE ANOTHER SAMPLE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSoilDescription(String soilType) {
    String description;
    
    // Updated to match the API's soil types
    switch (soilType.toLowerCase()) {
      case 'alluvial soil':
        description = 'Alluvial soil is fertile soil deposited by flowing water. It is excellent for agriculture due to its high nutrient content and good water retention.';
        break;
      case 'black soil':
        description = 'Black soil (also known as Regur soil) is rich in clay and organic matter. It has excellent water retention capacity and is ideal for cotton cultivation.';
        break;
      case 'clay soil':
        description = 'Clay soil has a higher percentage of clay particles, making it sticky when wet but hard when dry. It retains water and nutrients well but can have drainage issues.';
        break;
      case 'red soil':
        description = 'Red soil gets its color from iron oxide. It is generally less fertile than other soil types but can be productive with proper management and fertilization.';
        break;
      default:
        description = 'This soil type has unique properties that affect water retention, nutrient availability, and root growth.';
    }
    
    return Text(description);
  }

  Widget _getSoilRecommendations(String soilType) {
    String recommendations;
    
    // Updated to match the API's soil types
    switch (soilType.toLowerCase()) {
      case 'alluvial soil':
        recommendations = '• Ideal for most crops due to high fertility\n• Maintain organic matter with crop rotation\n• Monitor drainage in low-lying areas\n• Balanced fertilization recommended';
        break;
      case 'black soil':
        recommendations = '• Excellent for cotton and oilseeds\n• Avoid overwatering as it can become waterlogged\n• Deep plowing recommended\n• Add organic matter to improve structure';
        break;
      case 'clay soil':
        recommendations = '• Add organic matter to improve drainage\n• Avoid overwatering\n• Consider raised beds for better drainage\n• Use mulch to prevent soil compaction';
        break;
      case 'red soil':
        recommendations = '• Add organic matter to improve fertility\n• Use appropriate fertilizers to supplement nutrients\n• Implement soil conservation practices\n• Consider drought-resistant crops';
        break;
      default:
        recommendations = '• Add organic matter to improve soil structure\n• Test soil pH and adjust if necessary\n• Consider crop rotation to maintain soil health\n• Use appropriate irrigation based on soil type';
    }
    
    return Text(recommendations);
  }
}

