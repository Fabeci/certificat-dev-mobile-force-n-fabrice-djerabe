import 'package:meta/meta.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String token;

  SignInSuccess(this.token);
}

class SignInFailure extends SignInState {
  final String error;

  SignInFailure(this.error);
}
