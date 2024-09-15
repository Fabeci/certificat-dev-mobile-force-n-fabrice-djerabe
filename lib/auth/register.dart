import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/sign_up_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/sign_up_event.dart';
import 'package:tasks_manager_forcen/api/blocs/sign_up_state.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';
import 'package:tasks_manager_forcen/auth/login.dart';
import 'package:tasks_manager_forcen/pages/main_page.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _imageFile; // Store selected image file

  final ImagePicker _picker = ImagePicker();

  // Méthode pour sélectionner une image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => SignUpBloc(authRepository: AuthRepository()),
              child: BlocListener<SignUpBloc, SignUpState>(
                listener: (context, state) {
                  if (state is SignUpSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  } else if (state is SignUpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/auth.png",
                      width: 150,
                    ),
                    const Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff112255),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      hintText: "First name",
                      controller: _nomController,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Last name",
                      controller: _prenomController,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Username",
                      controller: _usernameController,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Adresse email",
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Mot de passe",
                      controller: _passwordController,
                      obscureText: true,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    // Bouton pour choisir une image
                    _imageFile == null
                        ? const Text("Aucune image sélectionnée")
                        : Image.file(_imageFile!, height: 150),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Sélectionner une image '),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        return CustomButton(
                          btnContent: 'Sign up',
                          onTap: () {
                            if (_imageFile != null) {
                              context.read<SignUpBloc>().add(
                                    SignUpRequested(
                                        nom: _nomController.text,
                                        prenom: _prenomController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        email: _emailController.text,
                                        photo: _imageFile!,
                                        context: context // Pass the image file
                                        ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Veuillez sélectionner une image'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Vous avez déjà un compte?',
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Color(0xff7492B7),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
