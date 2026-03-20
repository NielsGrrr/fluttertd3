import 'dart:convert';
import 'dart:io';
import 'package:event_poll/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/user.dart';
import '/configs.dart';

class AuthState extends ChangeNotifier {
  
  var error = "";
  User? _currentUser;
  String? _token;

  User? get currentUser => _currentUser;
  String? get token => _token;

  bool get isLoggedIn => currentUser != null && _token != null;

  Future<Result<User, String>> login(String username, String password) async {
    final loginResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/login'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (loginResponse.statusCode == HttpStatus.ok) {
      _token = json.decode(loginResponse.body)['token'];

      final userResponse = await http.get(
        Uri.parse('${Configs.baseUrl}/users/me'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (userResponse.statusCode == HttpStatus.ok) {
        _currentUser = User.fromJson(json.decode(userResponse.body));
        notifyListeners();
        return Result.success(_currentUser!);
      }

        error = 'Une erreur est survenue';
      } else {
        error = loginResponse.statusCode == HttpStatus.badRequest ||
                 loginResponse.statusCode == HttpStatus.unauthorized
            ? 'Identifiant ou mot de passe incorrect'
            : 'Une erreur est survenue';
      }

        logout();
        return Result.failure(error);
  }

  void logout() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  Future<Result<Unit, String>> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/signup'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == HttpStatus.created) {
      return Result.success(unit);
    } else {
      error = response.statusCode == HttpStatus.badRequest
          ? 'Identifiant déjà utilisé'
          : 'Une erreur est survenue';
      return Result.failure(error);
    }
  }
}