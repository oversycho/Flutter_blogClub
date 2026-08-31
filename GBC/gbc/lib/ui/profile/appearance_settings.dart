import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/l10n/app_localizations.dart';
import 'package:gbc/ui/settings/bloc/theme_bloc.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;

    return Scaffold(
      appBar: AppBar(title: Text(t('appearance'))),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return SafeArea(
            child: CupertinoListSection.insetGrouped(
              children: [
                _ThemeOptionTile(
                  label: t('theme_light'),
                  mode: ThemeMode.light,
                  currentMode: state.themeMode,
                ),
                _ThemeOptionTile(
                  label: t('theme_dark'),
                  mode: ThemeMode.dark,
                  currentMode: state.themeMode,
                ),
                _ThemeOptionTile(
                  label: t('theme_system'),
                  mode: ThemeMode.system,
                  currentMode: state.themeMode,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String label;
  final ThemeMode mode;
  final ThemeMode currentMode;

  const _ThemeOptionTile({
    required this.label,
    required this.mode,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = mode == currentMode;

    return CupertinoListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(CupertinoIcons.checkmark_alt, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        context.read<ThemeBloc>().add(ThemeModeChanged(mode));
      },
    );
  }
}
