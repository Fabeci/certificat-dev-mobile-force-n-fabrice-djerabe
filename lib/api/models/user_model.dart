class UserModel {
  final String firstName;
  final String lastName;
  final String email;

  UserModel(
      {required this.firstName, required this.lastName, required this.email});

  // Méthode pour créer un UserModel à partir d'un Map JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      email: json['email'] as String,
    );
  }

  // Méthode pour convertir un UserModel en Map JSON (si besoin)
  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
    };
  }
}
