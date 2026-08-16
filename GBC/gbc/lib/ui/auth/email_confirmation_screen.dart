import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/theme.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;
  const EmailConfirmationScreen({super.key, required this.email});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  bool isResending = false;
  bool justResent = false;

  Future<void> _resend() async {
    setState(() => isResending = true);
    try {
      await authRepository.resendConfirmationEmail(widget.email);
      if (!mounted) return;
      setState(() {
        justResent = true;
        isResending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isResending = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not resend: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm your email')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.mail_solid,
              size: 72,
              color: DarkThemeColors.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Check your inbox',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              "We've sent a confirmation link to ${widget.email}. "
              "Tap it to activate your account, then come back and log in.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            if (justResent)
              const Text('Confirmation email resent ✅')
            else
              OutlinedButton(
                onPressed: isResending ? null : _resend,
                child: isResending
                    ? const CupertinoActivityIndicator()
                    : const Text('Resend email'),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }
}
