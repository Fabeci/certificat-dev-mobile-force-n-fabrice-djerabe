// States
import 'package:equatable/equatable.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final ProfileModel profile;

  const SignUpSuccess(this.profile);

  @override
  List<Object> get props => [profile];
}

class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure(this.error);

  @override
  List<Object> get props => [error];
}
