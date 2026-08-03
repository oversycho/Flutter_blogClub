import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/auth/bloc/auth_bloc.dart';
import 'package:simple_icons/simple_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  /*   final TextEditingController usernameController = TextEditingController(
    text: "Player1",
  );
  final TextEditingController emailController = TextEditingController(
    text: "oversycho41@gmail.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "SuperSecret123!",
  );  */
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: DarkThemeColors.primaryTextColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 40, 40, 41),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: DarkThemeColors.primaryTextColor,
          contentTextStyle: themeData.textTheme.labelMedium!.apply(
            fontSizeDelta: 1.5,
          ),
          backgroundColor: const Color.fromARGB(255, 6, 25, 66),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            backgroundColor: WidgetStatePropertyAll(
              DarkThemeColors.primaryTextColor,
            ),
            foregroundColor: WidgetStatePropertyAll(
              DarkThemeColors.surfaceColor,
            ),
          ),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        color: isLogin
            ? DarkThemeColors.backgroundColor
            : const Color(0xff1A1A1D),
        child: Stack(
          children: [
            // Background blob 1
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              top: isLogin ? -60 : -100,
              left: isLogin ? -80 : 40,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (isLogin
                              ? DarkThemeColors.primaryColor
                              : const Color(0xff5865F2))
                          .withOpacity(0.18),
                ),
              ),
            ),
            // Background blob 2
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              bottom: isLogin ? -90 : -50,
              right: isLogin ? -60 : -100,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (isLogin
                              ? const Color.fromARGB(255, 10, 93, 218)
                              : DarkThemeColors.primaryColor)
                          .withOpacity(0.15),
                ),
              ),
            ),

            // Actual content
            Scaffold(
              backgroundColor: Colors.transparent,
              body: BlocProvider<AuthBloc>(
                create: (context) {
                  final bloc = AuthBloc(authRepository);
                  bloc.stream.forEach((State) {
                    if (State is AuthSuccess) {
                      Navigator.of(context).pop();
                    } else if (State is AuthErorr) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(State.exception.message)),
                      );
                    }
                  });
                  bloc.add(AuthStarted());
                  return bloc;
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 48, right: 48),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) {
                      return current is AuthLoading ||
                          current is AuthErorr ||
                          current is AuthInitial;
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/GBC_logo.png', width: 130),
                          const SizedBox(height: 12),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              isLogin ? 'Welcome' : 'Register',
                              style: themeData.textTheme.headlineMedium,
                              key: ValueKey(isLogin),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.isLoginMode
                                ? 'Please Log in To Your Account'
                                : 'create your account',
                            style: themeData.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: state.isLoginMode
                                ? _LoginFields(
                                    key: const ValueKey('login'),
                                    emailController: emailController,
                                    passwordController: passwordController,
                                  )
                                : _SignUpFields(
                                    key: const ValueKey('signup'),
                                    usernameController: usernameController,
                                    emailController: emailController,
                                    passwordController: passwordController,
                                  ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthButtonIsCliked(
                                  emailController.text,
                                  passwordController.text,
                                  usernameController.text,
                                ),
                              );
                            },
                            child: state is AuthLoading
                                ? CupertinoActivityIndicator(
                                    color: const Color.fromARGB(
                                      255,
                                      13,
                                      43,
                                      141,
                                    ),
                                  )
                                : Text(
                                    state.isLoginMode ? 'Login' : 'Register',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(
                                context,
                              ).add(AuthModeChageISClicked());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.isLoginMode
                                      ? 'if you Dont Have An Account?'
                                      : 'You Already have Account ',
                                ),
                                SizedBox(width: 8),
                                Text(
                                  state.isLoginMode ? 'Register' : 'Login',
                                  style: TextStyle(
                                    color: DarkThemeColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: isLogin
                                ? Column(
                                    key: const ValueKey('social-login'),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Divider(height: 1),
                                      SizedBox(height: 10),
                                      const Text('Also You Can Login with'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              SimpleIcons.google,
                                              size: 32,
                                              color: const Color.fromARGB(
                                                255,
                                                192,
                                                14,
                                                14,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              SimpleIcons.discord,
                                              size: 32,
                                              color: const Color(0xff5865F2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey('social-empty'),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const _SignUpFields({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.person),
            label: Text('UserName'),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.at),
            label: Text('Email'),
          ),
        ),
        SizedBox(height: 12),
        _PasswordTextField(passwordController: passwordController),
      ],
    );
  }
}

class _LoginFields extends StatelessWidget {
  const _LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.at),
            label: Text('Email'),
          ),
        ),
        SizedBox(height: 12),
        _PasswordTextField(passwordController: passwordController),
      ],
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({required this.passwordController});
  final TextEditingController passwordController;
  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: obscureText
              ? Icon(CupertinoIcons.eye_slash)
              : Icon(CupertinoIcons.eye),
        ),
        prefixIcon: Icon(CupertinoIcons.lock),
        label: Text('password'),
      ),
    );
  }
}
