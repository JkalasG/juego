import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class FinancialSummaryCard extends StatelessWidget {
  final double currentBalance;
  final double totalIncome;
  final double totalExpenses;
  final double monthlyBudget;
  final double savingsRate;
  final VoidCallback onEditBudgetTap;

  const FinancialSummaryCard({
    super.key,
    required this.currentBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.monthlyBudget,
    required this.savingsRate,
    required this.onEditBudgetTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final budgetRatio = monthlyBudget > 0 ? (totalExpenses / monthlyBudget).clamp(0.0, 1.0) : 0.0;
    final isBudgetExceeded = totalExpenses > monthlyBudget;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.forestGreen.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Balance y Tasa de Ahorro
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BALANCE FINANCIERO',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.mintGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.savings_rounded, color: AppTheme.forestGreen, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${savingsRate.toStringAsFixed(1)}% Ahorro',
                      style: const TextStyle(
                        color: AppTheme.forestGreen,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            currencyFormatter.format(currentBalance),
            style: TextStyle(
              color: currentBalance >= 0 ? AppTheme.forestGreen : AppTheme.coralSoft,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 18),

          // Ingresos vs Gastos
          Row(
            children: [
              // Ingresos
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.mintGreen.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_downward_rounded, color: AppTheme.forestGreen, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ingresos',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                            Text(
                              currencyFormatter.format(totalIncome),
                              style: const TextStyle(
                                color: AppTheme.forestGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Gastos
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.coralSoft.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_upward_rounded, color: AppTheme.coralSoft, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gastos',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                            Text(
                              currencyFormatter.format(totalExpenses),
                              style: const TextStyle(
                                color: AppTheme.coralSoft,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Presupuesto Mensual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Presupuesto Mensual',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: onEditBudgetTap,
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(Icons.edit_rounded, color: AppTheme.forestGreen, size: 14),
                    ),
                  ),
                ],
              ),
              Text(
                '${currencyFormatter.format(totalExpenses)} / ${currencyFormatter.format(monthlyBudget)}',
                style: TextStyle(
                  color: isBudgetExceeded ? AppTheme.coralSoft : AppTheme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: budgetRatio,
              minHeight: 8,
              backgroundColor: AppTheme.sageGreen,
              valueColor: AlwaysStoppedAnimation<Color>(
                isBudgetExceeded
                    ? AppTheme.coralSoft
                    : budgetRatio > 0.8
                        ? AppTheme.shibaGold
                        : AppTheme.mintGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
