// Events
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String nom;
  final String prenom;
  final String username;
  final String password;
  final String email;
  final File photo;
  final BuildContext context; // Ajout du contexte

  const SignUpRequested({
    required this.nom,
    required this.prenom,
    required this.username,
    required this.password,
    required this.email,
    required this.photo,
    required this.context, // Contexte ajouté ici
  });

  @override
  List<Object> get props =>
      [nom, prenom, username, password, email, photo, context];
}
