import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/l10n/app_localizations.dart';
import 'package:gbc/ui/settings/bloc/locale_bloc.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;

    return Scaffold(
      appBar: AppBar(title: Text(t('language'))),
      body: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return SafeArea(
            child: CupertinoListSection.insetGrouped(
              children: [
                _LanguageOptionTile(
                  label: 'English',
                  code: 'en',
                  currentCode: state.locale.languageCode,
                ),
                _LanguageOptionTile(
                  label: 'فارسی',
                  code: 'fa',
                  currentCode: state.locale.languageCode,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String label;
  final String code;
  final String currentCode;

  const _LanguageOptionTile({
    required this.label,
    required this.code,
    required this.currentCode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = code == currentCode;

    return CupertinoListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(CupertinoIcons.checkmark_alt, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        context.read<LocaleBloc>().add(LocaleChanged(Locale(code)));
      },
    );
  }
}
