// profile_event.dart

import 'package:equatable/equatable.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final ProfileModel profile;

  UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}
