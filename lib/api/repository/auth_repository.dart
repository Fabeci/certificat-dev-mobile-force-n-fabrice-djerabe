import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:tasks_manager_forcen/utils/session_manager.dart';
import '../../constants/utils.dart';

class AuthRepository {
  final String baseUrl;

  AuthRepository({this.baseUrl = kBaseUrlApi});

  Future<String> signIn(String username, String password) async {
    print(
        'Tentative de connexion avec username: $username et password: $password');

    final response = await http.post(
      Uri.parse('$baseUrl/auths/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Connexion réussie, token reçu: ${data['access_token']}');
      return data['access_token'];
    } else if (response.statusCode == 400) {
      throw Exception('Veuillez vérifier vos informations.');
    } else if (response.statusCode == 401) {
      throw Exception('Identifiant ou mot de passe incorrect.');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Le serveur ne repond pas. Veuillez réessayer plus tard.');
    } else {
      print(
          'Erreur inattendue, statut: ${response.statusCode}, message: ${response.body}');
      throw Exception('Erreur inattendue : ${response.body}');
    }
  }

  Future<void> signOut(String token) async {
    print('Tentative de déconnexion');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auths/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Déconnexion réussie');

        // Nettoyer les préférences utilisateur après une déconnexion réussie
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      } else {
        print(
            'Échec de la déconnexion, statut: ${response.statusCode}, message: ${response.body}');
        throw Exception('Échec de la déconnexion: ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  // Future<File> resizeImage(File imageFile) async {
  //   final image = img.decodeImage(imageFile.readAsBytesSync())!;
  //   // Redimensionner l'image (par exemple, à 300x300)
  //   final resizedImage = img.copyResize(image, width: 300, height: 300);

  //   // Enregistrer l'image redimensionnée
  //   final resizedFile = File(imageFile.path)
  //     ..writeAsBytesSync(img.encodeJpg(resizedImage));

  //   return resizedFile;
  // }

  void _showTopSnackBar(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 70.0,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<ProfileModel> signUp(
    String nom,
    String prenom,
    String username,
    String password,
    String email,
    File photo, // Accept file instead of string
    BuildContext context,
  ) async {
    print(
        'Tentative d\'inscription avec nom:$nom, prenom: $prenom, username: $username, email: $email, password: $password, photo: $photo');

    // Convertir le fichier photo en base64 pour l'inclure dans le JSON
    String photoBase64 = photo.path;

    // Créer le body JSON avec les données
    final body = jsonEncode({
      'nom': nom,
      'prenom': prenom,
      'username': username,
      'password': password,
      'email': email,
      'photo': photoBase64, // Encode image in base64
    });

    // Envoyer la requête POST avec le body JSON
    final response = await http.post(
      Uri.parse('$baseUrl/auths/register'),
      body: body,
      headers: {'Content-Type': 'application/json'}, // Optionnel
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Gérer la réponse
    if (response.statusCode == 201) {
      print('Inscription réussie');
      _showTopSnackBar(
        context,
        "Inscription réussie",
        Colors.green,
      );

      return ProfileModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Redirection vers la page de login
      throw Exception('Non autorisé: ${response.body}');
    } else {
      print(
          'Échec de l\'inscription, statut: ${response.statusCode}, message: ${response.body}');
      throw Exception('Échec de l\'inscription: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    print('Récupération du profil utilisateur');

    final response = await http.get(
      Uri.parse('$baseUrl/auths/profils'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Profil utilisateur récupéré avec succès');
      // final SessionManager _sessionManager = SessionManager();
      //         _sessionManager.saveUserSession(
      //             token: data.,
      //             email: email,
      //             firstname: firstname,
      //             lastname: lastname,
      //             username: username);
      return data;
    } else {
      print(
          'Échec de la récupération du profil utilisateur, statut: ${response.statusCode}, message: ${response.body}');
      throw Exception(
          'Échec de la récupération du profil utilisateur: ${response.body}');
    }
  }
}
