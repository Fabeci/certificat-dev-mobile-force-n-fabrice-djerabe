// profile_repository.dart

import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tasks_manager_forcen/constants/utils.dart';

class ProfileRepository {
  final String accessToken;
  final String url = kBaseUrlApi;

  ProfileRepository({required this.accessToken});

  Future<ProfileModel> fetchProfile() async {
    final response = await http.get(
      Uri.parse('$url/auths/profils/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final response = await http.put(
      Uri.parse('$url/auths/profils'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
