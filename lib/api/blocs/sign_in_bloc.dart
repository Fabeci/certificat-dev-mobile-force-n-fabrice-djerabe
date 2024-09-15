import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;

  SignInBloc({required this.authRepository}) : super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignOutSubmitted>(_onSignOutSubmitted);
  }

  void _onSignInSubmitted(
      SignInSubmitted event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      // Utilisation de AuthRepository pour gérer l'authentification
      final token = await authRepository.signIn(event.username, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token);
      emit(SignInSuccess(token));
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }

  void _onSignOutSubmitted(
      SignOutSubmitted event, Emitter<SignInState> emit) async {
    try {
      // Récupérer le token depuis SharedPreferences ou toute autre source de stockage
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token != null) {
        // Appelle la méthode de déconnexion dans le repository avec le token
        await authRepository.signOut(token);
        emit(SignInInitial()); // Réinitialisation de l'état après déconnexion
      } else {
        throw Exception("Token not found");
      }
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }
}
