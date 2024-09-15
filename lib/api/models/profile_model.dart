class ProfileModel {
  final String nom;
  final String prenom;
  final String email;
  final String? username;
  final String password;
  final String? photo;

  ProfileModel({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    this.username,
    this.photo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'username': username,
      'photo': photo,
    };
  }
}
