import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/network/api_client.dart';
import 'package:tubes_apb_flutter/core/network/api_exception_parser.dart';
import 'package:tubes_apb_flutter/features/settings/data/models/settings_models.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(apiClientProvider)),
);

class SelectedImageUpload {
  const SelectedImageUpload({
    required this.fileName,
    this.filePath,
    this.bytes,
  });

  final String fileName;
  final String? filePath;
  final Uint8List? bytes;
}

class SettingsRepository {
  SettingsRepository(this._dio);

  final Dio _dio;

  Future<SettingsUpdateProfileData> updateProfile({
    required String firstName,
    required String lastName,
    SelectedImageUpload? image,
  }) async {
    try {
      final payload = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
      };

      if (image != null) {
        if (image.bytes != null) {
          payload['profilePicture'] = MultipartFile.fromBytes(
            image.bytes!,
            filename: image.fileName,
          );
        } else if (image.filePath != null) {
          payload['profilePicture'] = await MultipartFile.fromFile(
            image.filePath!,
            filename: image.fileName,
          );
        }
      }

      final response = await _dio.patch<dynamic>(
        '/settings/profile',
        data: FormData.fromMap(payload),
      );

      return SettingsUpdateProfileSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const ApiException(
      message: 'Invalid profile update response payload.',
    );
  }
}
