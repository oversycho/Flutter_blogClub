import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/data/repo/profile_repository.dart';
import 'package:gbc/l10n/app_localizations.dart';
import 'package:gbc/ui/auth/auth.dart';
import 'package:gbc/ui/profile/appearance_settings.dart';
import 'package:gbc/ui/profile/bloc/profile_bloc.dart';
import 'package:gbc/ui/profile/language_settings.dart';
import 'package:gbc/ui/settings/bloc/locale_bloc.dart';
import 'package:gbc/ui/settings/bloc/theme_bloc.dart';
import 'package:gbc/ui/widgets/image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthInfo?>(
      valueListenable: AuthRepository.authChangeNotifier,
      builder: (context, authState, child) {
        final bool isAuthenticated =
            authState != null && authState.accessToken.isNotEmpty;

        if (!isAuthenticated) {
          return const _AuthenticationRequiredScreen();
        }

        return const _ProfileContent();
      },
    );
  }
}

class _AuthenticationRequiredScreen extends StatelessWidget {
  const _AuthenticationRequiredScreen();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('profile'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.person_crop_circle, size: 56),
              const SizedBox(height: 16),
              Text(
                'Authentication required',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Log in to view your profile and settings.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                child: Text(t('log_in')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(profileRepository: profileRepository)
        ..add(ProfileStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).t('profile'))),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileBloc>().add(
                        ProfileStarted(),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final profile = (state as ProfileSuccess).profile;

            return ListView(
              children: [
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: profile.avatarUrl != null
                        ? ImageLoadingService(
                            imageUrl: profile.avatarUrl!,
                            borderRadius: BorderRadius.circular(44),
                          )
                        : const CircleAvatar(
                            radius: 44,
                            child: Icon(CupertinoIcons.person, size: 40),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    profile.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        profile.bio!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                const _SettingsSection(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton(
                    onPressed: () => authRepository.signOut(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(AppLocalizations.of(context).t('log_out')),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            t('settings').toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoListSection.insetGrouped(
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                final currentLabel = switch (themeState.themeMode) {
                  ThemeMode.light => t('theme_light'),
                  ThemeMode.dark => t('theme_dark'),
                  ThemeMode.system => t('theme_system'),
                };
                return CupertinoListTile(
                  title: Text(t('appearance')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentLabel,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const AppearanceSettingsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
            BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, localeState) {
                final currentLabel = localeState.locale.languageCode == 'fa'
                    ? 'فارسی'
                    : 'English';
                return CupertinoListTile(
                  title: Text(t('language')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentLabel,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const LanguageSettingsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
