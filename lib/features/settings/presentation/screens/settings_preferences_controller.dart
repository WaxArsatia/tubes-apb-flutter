import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferencesState {
  const SettingsPreferencesState({
    required this.currency,
    required this.notificationsEnabled,
  });

  final String currency;
  final bool notificationsEnabled;

  SettingsPreferencesState copyWith({
    String? currency,
    bool? notificationsEnabled,
  }) {
    return SettingsPreferencesState(
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

final settingsPreferencesProvider =
    AsyncNotifierProvider<
      SettingsPreferencesController,
      SettingsPreferencesState
    >(SettingsPreferencesController.new);

class SettingsPreferencesController
    extends AsyncNotifier<SettingsPreferencesState> {
  static const _currencyKey = 'settings.currency';
  static const _notificationKey = 'settings.notifications.enabled';

  @override
  Future<SettingsPreferencesState> build() async {
    final prefs = await SharedPreferences.getInstance();

    return SettingsPreferencesState(
      currency: prefs.getString(_currencyKey) ?? 'IDR (Rp.)',
      notificationsEnabled: prefs.getBool(_notificationKey) ?? true,
    );
  }

  Future<void> updateCurrency(String currency) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);

    state = AsyncData(current.copyWith(currency: currency));
  }

  Future<void> updateNotification(bool enabled) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, enabled);

    state = AsyncData(current.copyWith(notificationsEnabled: enabled));
  }
}
