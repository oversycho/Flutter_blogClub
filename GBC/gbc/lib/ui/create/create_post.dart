import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/ui/auth/auth.dart';

class createPostScreen extends StatelessWidget {
  const createPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Create')),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (context, authState, child) {
          bool isAuthenticated =
              authState != null && authState!.accessToken.isNotEmpty;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isAuthenticated ? 'Welcome' : 'please Enter your Account'),
                isAuthenticated
                    ? ElevatedButton(
                        onPressed: () {
                          authRepository.signOut();
                        },
                        child: const Text('Log Out'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => AuthScreen(),
                            ),
                          );
                        },
                        child: const Text('Enter'),
                      ),
                ElevatedButton(
                  onPressed: () async {
                    await authRepository.refreshToken();
                  },
                  child: const Text('refresh Token'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
