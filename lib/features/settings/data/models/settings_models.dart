import 'package:json_annotation/json_annotation.dart';

part 'settings_models.g.dart';

@JsonSerializable()
class SettingsUpdateProfileSuccess {
  const SettingsUpdateProfileSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final SettingsUpdateProfileData data;

  factory SettingsUpdateProfileSuccess.fromJson(Map<String, dynamic> json) =>
      _$SettingsUpdateProfileSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsUpdateProfileSuccessToJson(this);
}

@JsonSerializable()
class SettingsUpdateProfileData {
  const SettingsUpdateProfileData({
    required this.updated,
    required this.updatedAt,
  });

  final bool updated;
  final DateTime updatedAt;

  factory SettingsUpdateProfileData.fromJson(Map<String, dynamic> json) =>
      _$SettingsUpdateProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsUpdateProfileDataToJson(this);
}
