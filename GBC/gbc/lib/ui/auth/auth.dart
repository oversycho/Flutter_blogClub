import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/theme.dart';
import 'package:simple_icons/simple_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
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
              body: Padding(
                padding: const EdgeInsets.only(left: 48, right: 48),
                child: Column(
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
                      isLogin
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
                      child: isLogin
                          ? const _LoginFields(key: ValueKey('login'))
                          : const _SignUpFields(key: ValueKey('signup')),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        /*      await authRepository.login(
                          "oversycho41@gmail.com",

                          "SuperSecret123!",
                        ); */
                        authRepository.refreshToken();
                      },
                      child: Text(
                        isLogin ? 'Login' : 'Register',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin
                                ? 'if you Dont Have An Account?'
                                : 'You Already have Account ',
                          ),
                          SizedBox(width: 8),
                          Text(
                            isLogin ? 'Register' : 'Login',
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Divider(height: 1),
                                SizedBox(height: 10),
                                const Text('Also You Can Login with'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
  const _SignUpFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.person),
            label: Text('UserName'),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.at),
            label: Text('Email'),
          ),
        ),
        SizedBox(height: 12),
        _PasswordTextField(),
      ],
    );
  }
}

class _LoginFields extends StatelessWidget {
  const _LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.at),
            label: Text('Email'),
          ),
        ),
        SizedBox(height: 12),
        _PasswordTextField(),
      ],
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({super.key});

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
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
