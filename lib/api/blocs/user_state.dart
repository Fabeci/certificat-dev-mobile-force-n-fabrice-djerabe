import 'package:equatable/equatable.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:tasks_manager_forcen/api/models/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoadInProgress extends UserState {}

class UserLoaded extends UserState {
  final Map<String, dynamic> userProfile;

  UserLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class UserLoadSuccess extends UserState {
  final ProfileModel user;

  UserLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdateSuccess extends UserState {
  final String message;

  UserUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserDeleteSuccess extends UserState {
  final String message;

  UserDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserError extends UserState {
  final String error;

  UserError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserLoadFailure extends UserState {
  final String error;

  UserLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
