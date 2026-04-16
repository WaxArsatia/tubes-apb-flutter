import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/core/utils/currency_formatter.dart';
import 'package:tubes_apb_flutter/features/dashboard/data/models/dashboard_models.dart';
import 'package:tubes_apb_flutter/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_avatar.dart';

final dashboardDataProvider = FutureProvider.autoDispose<DashboardData>((
  ref,
) async {
  final sessionController = ref.read(authSessionControllerProvider.notifier);
  final repository = ref.read(dashboardRepositoryProvider);

  return sessionController.withRefreshRetry(repository.fetchDashboard);
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dashboardDataProvider.future),
        child: dashboardState.when(
          data: (dashboard) => _DashboardBody(dashboard: dashboard),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              Icon(
                Icons.wifi_tethering_error_rounded,
                size: 42,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load dashboard',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Center(
                child: FilledButton(
                  onPressed: () => ref.invalidate(dashboardDataProvider),
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.dashboard});

  final DashboardData dashboard;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning,',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    dashboard.firstName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            AppAvatar(imageUrl: dashboard.profilePicture, radius: 22),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 6),
              Text(
                CurrencyFormatter.idr(dashboard.totalBalance),
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.surface),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.circle, color: AppColors.warning, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Remaining: ${CurrencyFormatter.idr(dashboard.budgetRemaining)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.surface),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text('Overview', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                title: 'Income',
                amount: dashboard.income,
                isIncome: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewCard(
                title: 'Expense',
                amount: dashboard.expense,
                isIncome: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: () => context.push(RoutePaths.transactions),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...dashboard.recentTransactions.take(3).map((transaction) {
          final isIncome = transaction.kind == TransactionKind.income;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: isIncome
                        ? AppColors.income.withValues(alpha: 0.12)
                        : AppColors.expense.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: isIncome ? AppColors.income : AppColors.expense,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        DateFormat(
                          'dd MMM, HH:mm',
                        ).format(transaction.timestamp),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isIncome ? '+' : '-'} ${CurrencyFormatter.idr(transaction.amount)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isIncome ? AppColors.income : AppColors.expense,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final int amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: isIncome
                  ? AppColors.income.withValues(alpha: 0.1)
                  : AppColors.expense.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isIncome ? AppColors.income : AppColors.expense,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '${isIncome ? '+' : '-'} ${CurrencyFormatter.idr(amount)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
