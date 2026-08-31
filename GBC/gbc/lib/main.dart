import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/bloc/theme_bloc.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc()..add(ThemeStarted()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Vision Store',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const RootScreen(),
          );
        },
      ),
    );
  }
}
