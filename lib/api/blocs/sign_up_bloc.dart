import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:tasks_manager_forcen/api/blocs/sign_up_event.dart';
import 'package:tasks_manager_forcen/api/blocs/sign_up_state.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    // Gestionnaire pour l'événement SignUpRequested
    on<SignUpRequested>((event, emit) async {
      try {
        emit(SignUpLoading());

        // Appel au dépôt pour effectuer l'inscription
        final ProfileModel profile = await authRepository.signUp(
            event.nom,
            event.prenom,
            event.username,
            event.password,
            event.email,
            event.photo,
            event.context);

        emit(SignUpSuccess(profile));
      } catch (error) {
        emit(SignUpFailure(error.toString()));
      }
    });
  }
}
