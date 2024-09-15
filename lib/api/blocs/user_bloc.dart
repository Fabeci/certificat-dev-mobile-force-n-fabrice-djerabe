// user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/user_event.dart';
import 'package:tasks_manager_forcen/api/blocs/user_state.dart';
import 'package:tasks_manager_forcen/api/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>(
        _onLoadUser); // Ajoutez cette ligne pour enregistrer le gestionnaire d'événements
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoadInProgress());
    try {
      final userProfile = await userRepository.fetchUserProfile(event.token);
      emit(UserLoadSuccess(userProfile));
    } catch (e) {
      emit(UserLoadFailure(e.toString()));
    }
  }
}
