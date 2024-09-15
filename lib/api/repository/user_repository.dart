import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:tasks_manager_forcen/utils/session_manager.dart';

import '../../constants/utils.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({this.baseUrl = kBaseUrlApi});

  Future<ProfileModel> fetchUserProfile(String token) async {
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
      return ProfileModel.fromJson(data);
    } else {
      print(
          'Échec de la récupération du profil utilisateur, statut: ${response.statusCode}, message: ${response.body}');
      throw Exception(
          'Échec de la récupération du profil utilisateur: ${response.body}');
    }
  }

  Future<ProfileModel> updateUserProfile(
      String token, ProfileModel updates) async {
    print('Mise à jour du profil utilisateur');

    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updates),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      print(
          'Échec de la mise à jour du profil utilisateur, statut: ${response.statusCode}, message: ${response.body}');
      throw Exception(
          'Échec de la mise à jour du profil utilisateur: ${response.body}');
    }
  }

  Future<void> deleteUserAccount(String token) async {
    print('Suppression du compte utilisateur');

    final response = await http.delete(
      Uri.parse('$baseUrl/users/account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Compte utilisateur supprimé avec succès');

      // Nettoyer les préférences utilisateur après la suppression du compte
      final SessionManager sessionManager = SessionManager();
      await sessionManager.clearUserSession();
    } else {
      print(
          'Échec de la suppression du compte utilisateur, statut: ${response.statusCode}, message: ${response.body}');
      throw Exception(
          'Échec de la suppression du compte utilisateur: ${response.body}');
    }
  }
}
