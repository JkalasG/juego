import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/game_state_service.dart';
import '../theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = GameStateService();
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return ListenableBuilder(
      listenable: gameService,
      builder: (context, _) {
        final catMap = gameService.expensesByCategory;
        final natureMap = gameService.expensesByNature;
        final totalExp = gameService.totalExpenses;
        final totalInc = gameService.totalIncome;
        final savingsRate = gameService.savingsRate;

        return Scaffold(
          appBar: AppBar(
            title: const Text('📊 Analítica & Oráculo'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Oráculo Botánico
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE5EFE9), Color(0xFFFDFBF7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.wb_sunny_rounded, color: AppTheme.shibaGoldDark, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consejo del Oráculo Botánico',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getGardenAdvice(savingsRate, totalExp, totalInc, natureMap),
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Desglose Botánico (Regla 50/30/20)
              const Text(
                'Nutrientes del Presupuesto (Regla 50/30/20)',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    _buildNatureBar(
                      '🌱 Necesidades Básicas (Suelo Fértil)',
                      natureMap[ExpenseNature.essential] ?? 0.0,
                      totalExp,
                      AppTheme.forestGreen,
                      currencyFormatter,
                    ),
                    const SizedBox(height: 14),
                    _buildNatureBar(
                      '🍂 Gustos / Caprichos (Podar con Cuidado)',
                      natureMap[ExpenseNature.optional] ?? 0.0,
                      totalExp,
                      AppTheme.coralSoft,
                      currencyFormatter,
                    ),
                    const SizedBox(height: 14),
                    _buildNatureBar(
                      '☀️ Ahorro & Inversión (Luz de Floración)',
                      natureMap[ExpenseNature.investment] ?? 0.0,
                      totalExp,
                      AppTheme.shibaGoldDark,
                      currencyFormatter,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Desglose por Categorías
              const Text(
                'Distribución por Categorías',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (catMap.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No hay gastos registrados todavía.',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                )
              else
                ...catMap.entries.map((entry) {
                  final cat = entry.key;
                  final amount = entry.value;
                  final percent = totalExp > 0 ? (amount / totalExp) : 0.0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(cat.icon, color: cat.color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cat.displayName,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currencyFormatter.format(amount),
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${(percent * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 6,
                            backgroundColor: AppTheme.sageGreen,
                            valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNatureBar(
    String label,
    double amount,
    double total,
    Color color,
    NumberFormat formatter,
  ) {
    final ratio = total > 0 ? (amount / total).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Text(
              '${formatter.format(amount)} (${(ratio * 100).toStringAsFixed(0)}%)',
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppTheme.sageGreen,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  String _getGardenAdvice(
    double savingsRate,
    double totalExp,
    double totalInc,
    Map<ExpenseNature, double> natureMap,
  ) {
    final optionalExpenses = natureMap[ExpenseNature.optional] ?? 0.0;
    if (totalExp > totalInc && totalInc > 0) {
      return 'Tus gastos superan tus ingresos este mes. Evita compras impulsivas para que tu jardín no pierda humedad y tus plantas no se marchiten.';
    }
    if (savingsRate >= 20.0) {
      return '¡Tu jardín está bañado de luz dorada! Estás ahorrando más del 20% de tus ingresos, lo que hará florecer a tu Árbol de Jade.';
    }
    if (optionalExpenses > (totalExp * 0.4)) {
      return 'La maleza de gastos por capricho representa más del 40%. Poda algunos gastos hormiga y canalízalos a tu fondo de emergencia.';
    }
    return 'El ecosistema de tu jardín se mantiene equilibrado. Continúa regando tus plantas a diario registrando tus gastos a tiempo.';
  }
}
