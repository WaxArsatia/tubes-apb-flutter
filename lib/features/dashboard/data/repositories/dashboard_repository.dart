import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/network/api_client.dart';
import 'package:tubes_apb_flutter/core/network/api_exception_parser.dart';
import 'package:tubes_apb_flutter/features/dashboard/data/models/dashboard_models.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepository(ref.watch(apiClientProvider)),
);

class DashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;

  Future<DashboardData> fetchDashboard() async {
    try {
      final response = await _dio.get<dynamic>('/dashboard');
      return DashboardSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    } on ApiException {
      rethrow;
    } on TypeError {
      throw const ApiException(message: 'Invalid dashboard response payload.');
    } on FormatException {
      throw const ApiException(message: 'Invalid dashboard response payload.');
    } on Exception {
      throw const ApiException(message: 'Invalid dashboard response payload.');
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const ApiException(message: 'Invalid dashboard response payload.');
  }
}
