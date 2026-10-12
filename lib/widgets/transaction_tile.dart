import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final FinancialTransaction transaction;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormatter = DateFormat('dd MMM, hh:mm a');

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.coralSoft.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 26),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            // Icono de Categoría
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: transaction.category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: transaction.category.color.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Icon(
                transaction.category.icon,
                color: transaction.category.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Título, Naturaleza del gasto y Método de Pago
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Badge Botánico de Naturaleza del Gasto
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: transaction.nature == ExpenseNature.investment
                              ? AppTheme.mintGreen.withValues(alpha: 0.2)
                              : transaction.nature == ExpenseNature.essential
                                  ? AppTheme.sageGreen
                                  : AppTheme.coralSoft.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          transaction.nature.displayName,
                          style: TextStyle(
                            color: transaction.nature == ExpenseNature.investment
                                ? AppTheme.forestGreen
                                : transaction.nature == ExpenseNature.essential
                                    ? AppTheme.forestGreen
                                    : AppTheme.coralSoft,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(transaction.paymentMethod.icon, size: 12, color: AppTheme.textMuted),
                      const SizedBox(width: 3),
                      Text(
                        transaction.paymentMethod.displayName,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  if (transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      transaction.note,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Monto y Fecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isExpense ? '-' : '+'} ${currencyFormatter.format(transaction.amount)}',
                  style: TextStyle(
                    color: transaction.isExpense ? AppTheme.coralSoft : AppTheme.forestGreen,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormatter.format(transaction.date),
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
