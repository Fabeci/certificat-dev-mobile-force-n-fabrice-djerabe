import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_bloc.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_event.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_state.dart';
import 'package:tasks_manager_forcen/constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Charger les données du profil utilisateur à l'initialisation de la page
    BlocProvider.of<ProfileBloc>(context).add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    void _showDeleteConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Logique de suppression du compte
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                  // Redirection ou autre action après suppression
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      // backgroundColor: AppColors.kPrimaryColor,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return const Center(child: Text('Error loading profile'));
          } else if (state is ProfileLoaded) {
            final user = state.profile;
            return Container(
              decoration: BoxDecoration(color: AppColors.kPrimaryColor),
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              user.photo != null && user.photo!.isNotEmpty
                                  ? AssetImage(user.photo!)
                                  : const AssetImage(
                                      "assets/images/user_avatar.png"),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.nom,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  user.prenom,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.email,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          buildListTile(
                            Icons.person,
                            'Edit profile',
                            AppColors.kPrimaryColor,
                            () {
                              Navigator.of(context).pushNamed(
                                '/profile-edit',
                                arguments: user,
                              );
                            },
                          ),
                          buildListTile(
                            Icons.edit,
                            'Change password',
                            AppColors.kPrimaryColor,
                            () {
                              Navigator.of(context)
                                  .pushNamed('/change-password');
                            },
                          ),
                          buildListTile(
                            Icons.notifications,
                            'Notifications',
                            AppColors.kPrimaryColor,
                            () {
                              Navigator.pushNamed(context, '/notification');
                            },
                          ),
                          buildListTile(
                            Icons.dashboard,
                            'Statistiques',
                            AppColors.kPrimaryColor,
                            () {
                              Navigator.pushNamed(context, '/main');
                            },
                          ),
                          buildListTile(
                            Icons.delete,
                            'Delete your account',
                            Colors.red,
                            () {
                              _showDeleteConfirmationDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No profile data available'));
          }
        },
      ),
    );
  }

  ListTile buildListTile(
      IconData icon, String title, Color textColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: Icon(Icons.chevron_right, color: textColor),
      onTap: onTap,
    );
  }
}
