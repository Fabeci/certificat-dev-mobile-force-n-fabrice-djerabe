import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks_manager_forcen/api/repository/user_repository.dart';
import 'package:tasks_manager_forcen/auth/register.dart';
import 'package:tasks_manager_forcen/pages/main_page.dart';
import 'package:tasks_manager_forcen/widgets/custom_text_field.dart';
import '../api/blocs/sign_in_bloc.dart';
import '../api/blocs/sign_in_event.dart';
import '../api/blocs/sign_in_state.dart';
import '../widgets/custom_button.dart';
import '../utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSelected = false;
  final SessionManager _sessionManager = SessionManager();

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textFieldAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _checkSession();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _textFieldAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  Future<void> _checkSession() async {
    final token = await _sessionManager.getAccessToken();
    if (token != null) {
      Navigator.of(context).pushReplacement(
        _createFadePageRoute(const MainPage()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) async {
            if (state is SignInSuccess) {
              final UserRepository userRepository = UserRepository();
              final userProfile =
                  await userRepository.fetchUserProfile(state.token);
              print('User Profile: $userProfile');

              await _sessionManager.saveUserSession(
                token: state.token,
                nom: userProfile.nom,
                prenom: userProfile.prenom,
                email: userProfile.email,
                username: userProfile.username!,
              );

              _showTopSnackBar(context, 'Connexion réussie', Colors.green);

              Navigator.of(context).pushReplacementNamed("/main");
            } else if (state is SignInFailure) {
              _showTopSnackBar(context, state.error, Colors.redAccent);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Image.asset(
                      "assets/images/auth.png",
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _textFieldAnimation,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _textFieldAnimation,
                    child: CustomTextField(
                      hintText: "Nom d'utilisateur",
                      controller: _usernameController,
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _textFieldAnimation,
                    child: CustomTextField(
                      hintText: "Mot de passe",
                      controller: _passwordController,
                      obscureText: true,
                      textInputType: TextInputType.text,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                isSelected = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            'Se souvenir de moi',
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Mot de passe oublié?',
                          style: TextStyle(
                            color: Color(0xff7492B7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FadeTransition(
                    opacity: _buttonAnimation,
                    child: CustomButton(
                      btnContent: 'Se connecter',
                      onTap: () {
                        BlocProvider.of<SignInBloc>(context).add(
                          SignInSubmitted(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Vous n\'avez pas de compte?'),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text(
                          'S\'inscrire',
                          style: TextStyle(
                            color: Color(0xff7492B7),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageRouteBuilder _createFadePageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation =
            animation.drive(tween.chain(CurveTween(curve: curve)));
        return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child));
      },
    );
  }

  void _showTopSnackBar(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 70.0,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }
}
