import 'package:flutter/cupertino.dart';

@immutable
abstract class SignInEvent {}

class SignInSubmitted extends SignInEvent {
  final String username;
  final String password;

  SignInSubmitted({
    required this.username,
    required this.password,
  });
}

class SignOutSubmitted extends SignInEvent {}
