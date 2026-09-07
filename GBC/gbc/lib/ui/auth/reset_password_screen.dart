import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/ui/auth/bloc/reset_password_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String accessToken;
  final String refreshToken;

  const ResetPasswordScreen({
    super.key,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(
        authRepository: authRepository,
        accessToken: widget.accessToken,
        refreshToken: widget.refreshToken,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Set a new password')),
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.exception.message),
                ),
              );
            } else if (state is ResetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Password updated — you are now logged in.'),
                ),
              );
              // completePasswordReset already logged the user in via
              // authChangeNotifier, so just leave this screen — whatever
              // is listening to that notifier (RootScreen/auth gates)
              // will react on its own.
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          builder: (context, state) {
            final bool isLoading = state is ResetPasswordLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        label: const Text('New password'),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmController,
                      obscureText: _obscure,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.lock),
                        label: Text('Confirm new password'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_passwordController.text !=
                                  _confirmController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('Passwords do not match.'),
                                  ),
                                );
                                return;
                              }
                              context.read<ResetPasswordBloc>().add(
                                ResetPasswordSubmitted(
                                  _passwordController.text,
                                ),
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Update password'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
