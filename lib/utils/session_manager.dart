import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = "accessToken";
  static const String _firstnameKey = "firstname";
  static const String _lastnameKey = "lastname";
  static const String _usernameKey = "username";
  static const String _emailKey = "email";

  // Sauvegarde des informations de session
  Future<void> saveUserSession({
    required String token,
    required String nom,
    required String prenom,
    required String email,
    required String username,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_firstnameKey, nom);
    await prefs.setString(_lastnameKey, prenom);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_usernameKey, username);
  }

  // Sauvegarde uniquement du token d'accès
  Future<void> saveAccessToken({required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Vérifie si l'utilisateur est connecté
  Future<bool> isUserLoggedIn() async {
    final token = await getAccessToken();
    return token != null; // Retourne vrai si le token est présent, sinon faux
  }

  // Récupération du token d'accès
  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Récupération du prénom
  Future<String?> getUserFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstnameKey);
  }

  // Récupération du nom
  Future<String?> getUserLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastnameKey);
  }

  // Récupération du nom d'utilisateur
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Récupération de l'email
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Suppression de la session utilisateur
  Future<void> clearUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_firstnameKey);
    await prefs.remove(_lastnameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_usernameKey);
  }
}
