import 'dart:convert';
import 'dart:io';

import 'package:event_poll/configs.dart';
import 'package:event_poll/models/poll.dart';
import 'package:event_poll/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PollsState extends ChangeNotifier {
  String? _token;
  
  // La liste de tous les sondages
  List<Poll> _polls = [];
  List<Poll> get polls => _polls;

  // Le fameux sondage en cours de lecture/édition !
  Poll? _currentPoll;
  Poll? get currentPoll => _currentPoll;

  PollsState({String? token}) : _token = token;

  void setAuthToken(String? token) {
    if (_token != token) {
      _token = token;
      // Si on se déconnecte, on vide les données de sécurité
      if (token == null) {
        _polls = [];
        _currentPoll = null;
      }
      notifyListeners();
    }
  }

  // Méthode pour définir le sondage actif quand on clique dessus
  void setCurrentPoll(Poll? poll) {
    _currentPoll = poll;
    notifyListeners();
  }

  Future<Result<String, String>> updatePollImage(int id, File imageFile) async {
    final fileContent = await imageFile.readAsBytes();

    final request = http.MultipartRequest('POST', Uri.parse('${Configs.baseUrl}/polls/$id/image'))
      ..headers.addAll({
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token'
      })
      ..files.add(http.MultipartFile.fromBytes(
        '',
        fileContent,
        filename: imageFile.path.split('/').last,
      ));
  
    final response = await http.Response.fromStream(await request.send());
  
    if (response.statusCode == HttpStatus.ok) {
      final imageName = Poll.fromJson(json.decode(response.body)).imageName!;
  
      notifyListeners();
      return Result.success(imageName);
    } else {
      return Result.failure('Une erreur est survenue');
    }
  }

  Future<void> fetchPolls() async {
    try {
      final response = await http.get(
        Uri.parse('${Configs.baseUrl}/polls'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          // On envoie le token s'il est disponible
          if (_token != null) HttpHeaders.authorizationHeader: 'Bearer $_token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        // 1. On décode la réponse en liste de dictionnaires
        final List<dynamic> jsonList = json.decode(response.body);
        
        // 2. On transforme chaque dictionnaire en objet Poll
        _polls = jsonList.map((json) => Poll.fromJson(json)).toList();
        
        // 3. On prévient l'interface que la liste est prête !
        notifyListeners();
      } else {
        print('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }
  
}