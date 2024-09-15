// profile_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_event.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_state.dart';
import 'package:tasks_manager_forcen/api/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.fetchProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await profileRepository.updateProfile(event.profile);
      final updatedProfile = await profileRepository.fetchProfile();
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
