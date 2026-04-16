// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsUpdateProfileSuccess _$SettingsUpdateProfileSuccessFromJson(
  Map<String, dynamic> json,
) => SettingsUpdateProfileSuccess(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: SettingsUpdateProfileData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SettingsUpdateProfileSuccessToJson(
  SettingsUpdateProfileSuccess instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

SettingsUpdateProfileData _$SettingsUpdateProfileDataFromJson(
  Map<String, dynamic> json,
) => SettingsUpdateProfileData(
  updated: json['updated'] as bool,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SettingsUpdateProfileDataToJson(
  SettingsUpdateProfileData instance,
) => <String, dynamic>{
  'updated': instance.updated,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
