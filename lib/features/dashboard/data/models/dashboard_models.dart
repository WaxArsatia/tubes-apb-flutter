import 'package:json_annotation/json_annotation.dart';

part 'dashboard_models.g.dart';

@JsonSerializable()
class DashboardSuccess {
  const DashboardSuccess({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final DashboardData data;

  factory DashboardSuccess.fromJson(Map<String, dynamic> json) =>
      _$DashboardSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSuccessToJson(this);
}

@JsonSerializable()
class DashboardData {
  const DashboardData({
    required this.firstName,
    required this.profilePicture,
    required this.totalBalance,
    required this.budgetRemaining,
    required this.income,
    required this.expense,
    required this.recentTransactions,
  });

  final String firstName;
  final String? profilePicture;
  final int totalBalance;
  final int budgetRemaining;
  final int income;
  final int expense;
  final List<RecentTransaction> recentTransactions;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

@JsonSerializable()
class RecentTransaction {
  const RecentTransaction({
    required this.name,
    required this.timestamp,
    required this.kind,
    required this.amount,
  });

  final String name;
  final DateTime timestamp;
  final TransactionKind kind;
  final int amount;

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      _$RecentTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$RecentTransactionToJson(this);
}

enum TransactionKind {
  @JsonValue('Income')
  income,
  @JsonValue('Expense')
  expense,
}
