import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_event.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_state.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:tasks_manager_forcen/constants/app_colors.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);
  static const String routeName = '/profile-edit';

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  final ImagePicker _picker = ImagePicker();
  late final String _password;
  late final String _username;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = ModalRoute.of(context)?.settings.arguments as ProfileModel;

    // Initialise les champs de texte avec les données utilisateur
    _firstNameController.text = user.nom;
    _lastNameController.text = user.prenom;
    _emailController.text = user.email;
    _password = user.password.toString();
    _username = user.username.toString();

    // Récupère l'utilisateur depuis le bloc
    BlocProvider.of<ProfileBloc>(context).add(LoadProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = pickedImage;
        });
      }
    } else {
      // Gérer le cas où la permission est refusée
    }
  }

  void _saveProfile() {
    print("PASSSSSSSSSSSSSSSSSSS ${_password}");
    final updatedProfile = ProfileModel(
      nom: _firstNameController.text,
      prenom: _lastNameController.text,
      email: _emailController.text,
      password: _password,
      username: _username,
      photo: _pickedImage?.path,
    );

    BlocProvider.of<ProfileBloc>(context).add(UpdateProfile(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
                title: const Text('Edit Profile'),
              ),
              body: const Center(child: CircularProgressIndicator()));
        } else if (state is ProfileLoaded) {
          final user = state.profile;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.kPrimaryColor,
              foregroundColor: Colors.white,
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
                            : user.photo != null && user.photo!.isNotEmpty
                                ? NetworkImage(user.photo!)
                                : AssetImage('assets/images/user_avatar.png')
                                    as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Prenom'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit),
                        SizedBox(width: 10),
                        Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
