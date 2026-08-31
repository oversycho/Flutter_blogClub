import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/l10n/app_localizations.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/root.dart';
import 'package:gbc/ui/settings/bloc/locale_bloc.dart';
import 'package:gbc/ui/settings/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:gbc/data/repo/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(ThemeStarted())),
        BlocProvider(create: (context) => LocaleBloc()..add(LocaleStarted())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Vision Store',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const RootScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
