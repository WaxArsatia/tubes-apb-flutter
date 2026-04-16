// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSuccess _$DashboardSuccessFromJson(Map<String, dynamic> json) =>
    DashboardSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardSuccessToJson(DashboardSuccess instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      firstName: json['firstName'] as String,
      profilePicture: json['profilePicture'] as String?,
      totalBalance: (json['totalBalance'] as num).toInt(),
      budgetRemaining: (json['budgetRemaining'] as num).toInt(),
      income: (json['income'] as num).toInt(),
      expense: (json['expense'] as num).toInt(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>)
          .map((e) => RecentTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'profilePicture': instance.profilePicture,
      'totalBalance': instance.totalBalance,
      'budgetRemaining': instance.budgetRemaining,
      'income': instance.income,
      'expense': instance.expense,
      'recentTransactions': instance.recentTransactions,
    };

RecentTransaction _$RecentTransactionFromJson(Map<String, dynamic> json) =>
    RecentTransaction(
      name: json['name'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      kind: $enumDecode(_$TransactionKindEnumMap, json['kind']),
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$RecentTransactionToJson(RecentTransaction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'timestamp': instance.timestamp.toIso8601String(),
      'kind': _$TransactionKindEnumMap[instance.kind]!,
      'amount': instance.amount,
    };

const _$TransactionKindEnumMap = {
  TransactionKind.income: 'Income',
  TransactionKind.expense: 'Expense',
};
