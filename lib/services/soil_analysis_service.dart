import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SoilAnalysisService {
  // Update this URL with your actual API endpoint
  static const String apiUrl = 'http://192.168.29.204:8000/predict';

  static Future<Map<String, dynamic>> analyzeSoil(File imageFile) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Get file extension
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      String mimeType;

      // Determine mime type based on extension
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        default:
          mimeType = 'image/jpeg'; // Default to jpeg
      }

      // Add file to request
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check if request was successful
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to analyze soil: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing soil: $e');
    }
  }
}
