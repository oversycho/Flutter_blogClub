import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/l10n/app_localizations.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/auth/reset_password_screen.dart';
import 'package:gbc/ui/root.dart';
import 'package:gbc/ui/settings/bloc/locale_bloc.dart';
import 'package:gbc/ui/settings/bloc/theme_bloc.dart';

/// Global navigator key so the deep-link listener below (which lives
/// outside the normal widget tree, in initState) can push a screen
/// without needing a BuildContext of its own.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  Future<void> _handleIncomingLinks() async {
    // App was fully closed, opened directly via the email link.
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleUri(initialUri);
    } catch (_) {
      // No initial link — completely normal, just a regular app launch.
    }

    // App was already running (foreground or background).
    _appLinks.uriLinkStream.listen(_handleUri);
  }

  void _handleUri(Uri uri) {
    // Deliberately checking scheme only — gbcreset:// is used for nothing
    // else in this app, so no need to also check host/path.
    if (uri.scheme != 'gbcreset') return;

    // Supabase puts the recovery tokens in the fragment, same as OAuth:
    // gbcreset://reset-password#access_token=...&refresh_token=...&type=recovery
    final Map<String, String> fragmentParams = Uri.splitQueryString(
      uri.fragment,
    );
    final String? accessToken = fragmentParams['access_token'];
    final String? refreshToken = fragmentParams['refresh_token'];

    if (accessToken == null || refreshToken == null) return;

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      ),
    );
  }

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
                navigatorKey: navigatorKey,
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
