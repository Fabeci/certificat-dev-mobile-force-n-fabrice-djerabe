import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String token;

  LoadUser(this.token);

  @override
  List<Object?> get props => [token];
}

class UpdateUserProfile extends UserEvent {
  final String token;
  final Map<String, dynamic> updates;

  UpdateUserProfile(this.token, this.updates);

  @override
  List<Object?> get props => [token, updates];
}

class DeleteUserAccount extends UserEvent {
  final String token;

  DeleteUserAccount(this.token);

  @override
  List<Object?> get props => [token];
}
