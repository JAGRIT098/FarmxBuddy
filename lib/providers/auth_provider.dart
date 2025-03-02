import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  bool _isAuthenticated = false;
  String _username = '';

  bool get isAuthenticated => _isAuthenticated;
  String get username => _username;

  final String apiUrl = "http://192.168.29.204:8001"; // Change this to your backend URL

  AuthProvider() {
    checkLoginStatus();
  }

  // Method to check login status on app startup
  Future<void> checkLoginStatus() async {
    try {
      final username = await _storage.read(key: 'current_user');
      if (username != null && username.isNotEmpty) {
        _isAuthenticated = true;
        _username = username;
        notifyListeners();
      }
    } catch (e) {
      print("Error checking login status: $e");
    }
  }

  // Register method
  Future<bool> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/register/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        await _storage.write(key: 'current_user', value: username);
        _isAuthenticated = true;
        _username = username;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  // Login method
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        await _storage.write(key: 'current_user', value: username);
        _isAuthenticated = true;
        _username = username;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'current_user');
      _isAuthenticated = false;
      _username = '';
      notifyListeners();
    } catch (e) {
      print("Logout error: $e");
    }
  }
}