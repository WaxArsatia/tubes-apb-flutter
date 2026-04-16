import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/features/settings/presentation/screens/settings_preferences_controller.dart';
import 'package:tubes_apb_flutter/features/settings/presentation/widgets/setting_tile.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_avatar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _currencies = <String>['IDR (Rp.)', 'USD (\$)', 'EUR (€)'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionControllerProvider);
    final preferencesAsync = ref.watch(settingsPreferencesProvider);

    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              'Manage your account',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  AppAvatar(imageUrl: user?.profilePicture),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Unknown User',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          user?.email ?? '-',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Account', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  SettingTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    subtitle: 'Username, Email',
                    onTap: () => context.push(RoutePaths.personalInfo),
                  ),
                  const Divider(height: 0),
                  SettingTile(
                    icon: Icons.shield_outlined,
                    title: 'Security',
                    subtitle: 'Password',
                    onTap: () => context.push(RoutePaths.security),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Preference', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: preferencesAsync.when(
                data: (preferences) => Column(
                  children: [
                    SettingTile(
                      icon: Icons.currency_exchange_rounded,
                      title: 'Currency',
                      subtitle: preferences.currency,
                      onTap: () async {
                        final selected = await showModalBottomSheet<String>(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  for (final currency in _currencies)
                                    ListTile(
                                      title: Text(currency),
                                      onTap: () =>
                                          Navigator.of(context).pop(currency),
                                    ),
                                ],
                              ),
                            );
                          },
                        );

                        if (selected == null) {
                          return;
                        }

                        await ref
                            .read(settingsPreferencesProvider.notifier)
                            .updateCurrency(selected);
                      },
                    ),
                    const Divider(height: 0),
                    SettingTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notification',
                      subtitle: 'Receive reminder and updates',
                      trailing: Switch(
                        value: preferences.notificationsEnabled,
                        onChanged: (enabled) {
                          ref
                              .read(settingsPreferencesProvider.notifier)
                              .updateNotification(enabled);
                        },
                      ),
                    ),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'Failed to load preferences: $error',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                await ref.read(authSessionControllerProvider.notifier).logout();

                if (context.mounted) {
                  context.go(RoutePaths.landing);
                }
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
