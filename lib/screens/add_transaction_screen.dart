import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/game_state_service.dart';
import '../theme/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool initialIsExpense;

  const AddTransactionScreen({super.key, this.initialIsExpense = true});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  late bool _isExpense;
  late ExpenseCategory _selectedCategory;
  late ExpenseNature _selectedNature;
  PaymentMethod _selectedPayment = PaymentMethod.debitCard;

  @override
  void initState() {
    super.initState();
    _isExpense = widget.initialIsExpense;
    _selectedCategory = _isExpense ? ExpenseCategory.food : ExpenseCategory.incomeSalary;
    _selectedNature = _isExpense ? ExpenseNature.essential : ExpenseNature.investment;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un monto válido mayor a 0')),
      );
      return;
    }

    final newTx = FinancialTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      amount: amount,
      date: DateTime.now(),
      isExpense: _isExpense,
      category: _selectedCategory,
      nature: _isExpense ? _selectedNature : ExpenseNature.investment,
      paymentMethod: _selectedPayment,
      note: _noteController.text.trim(),
    );

    final report = await GameStateService().addTransaction(newTx);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppTheme.border, width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.local_florist_rounded,
                color: AppTheme.forestGreen,
                size: 26,
              ),
              SizedBox(width: 8),
              Text(
                '¡Impacto en tu Jardín!',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            report,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Volver al Jardín'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isExpense ? '🌱 Registrar Gasto' : '💎 Registrar Ingreso'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Tipo: Gasto vs Ingreso
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpense = true;
                            _selectedCategory = ExpenseCategory.food;
                            _selectedNature = ExpenseNature.essential;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isExpense ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: _isExpense ? Border.all(color: AppTheme.border) : null,
                            boxShadow: _isExpense
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 4,
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward_rounded,
                                color: _isExpense ? AppTheme.coralSoft : AppTheme.textMuted,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Gasto',
                                style: TextStyle(
                                  color: _isExpense ? AppTheme.textPrimary : AppTheme.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpense = false;
                            _selectedCategory = ExpenseCategory.incomeSalary;
                            _selectedNature = ExpenseNature.investment;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isExpense ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: !_isExpense ? Border.all(color: AppTheme.border) : null,
                            boxShadow: !_isExpense
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 4,
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward_rounded,
                                color: !_isExpense ? AppTheme.forestGreen : AppTheme.textMuted,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Ingreso',
                                style: TextStyle(
                                  color: !_isExpense ? AppTheme.forestGreen : AppTheme.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Monto
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Monto (\$) *',
                  prefixIcon: Icon(Icons.attach_money_rounded, color: AppTheme.forestGreen),
                  hintText: '0.00',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Ingresa un monto';
                  if (double.tryParse(val.replaceAll(',', '.')) == null) return 'Monto no válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Concepto / Título
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Concepto o Título *',
                  prefixIcon: Icon(Icons.edit_note_rounded, color: AppTheme.forestGreen),
                  hintText: 'Ej. Supermercado, Alquiler, Café...',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Ingresa el concepto';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Selector de Naturaleza (Mecánica Botánica de Cuidado)
              if (_isExpense) ...[
                const Text(
                  'Impacto en tu Jardín (Naturaleza del Gasto)',
                  style: TextStyle(
                    color: AppTheme.forestGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ExpenseNature.values.map((nature) {
                    final isSelected = _selectedNature == nature;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedNature = nature),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (nature == ExpenseNature.investment
                                    ? AppTheme.mintGreen.withValues(alpha: 0.2)
                                    : nature == ExpenseNature.essential
                                        ? AppTheme.sageGreen
                                        : AppTheme.coralSoft.withValues(alpha: 0.12))
                                : AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? (nature == ExpenseNature.investment
                                      ? AppTheme.mintGreen
                                      : nature == ExpenseNature.essential
                                          ? AppTheme.forestGreen
                                          : AppTheme.coralSoft)
                                  : AppTheme.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                nature.displayName,
                                style: TextStyle(
                                  color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco_rounded, color: AppTheme.mintGreen, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedNature.rpgEffect,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Categoría
              const Text(
                'Categoría',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (_isExpense
                        ? [
                            ExpenseCategory.food,
                            ExpenseCategory.housing,
                            ExpenseCategory.transport,
                            ExpenseCategory.leisure,
                            ExpenseCategory.shopping,
                            ExpenseCategory.health,
                            ExpenseCategory.education,
                            ExpenseCategory.subscriptions,
                            ExpenseCategory.debt,
                            ExpenseCategory.investment,
                            ExpenseCategory.other,
                          ]
                        : [
                            ExpenseCategory.incomeSalary,
                            ExpenseCategory.incomeExtra,
                            ExpenseCategory.investment,
                            ExpenseCategory.other,
                          ])
                    .map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.color),
                    label: Text(cat.displayName),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppTheme.forestGreen,
                    backgroundColor: AppTheme.surfaceMuted,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppTheme.forestGreen : AppTheme.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Método de Pago
              const Text(
                'Método de Pago',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: PaymentMethod.values.map((method) {
                  final isSelected = _selectedPayment == method;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPayment = method),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.sageGreen : AppTheme.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.forestGreen : AppTheme.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              method.icon,
                              size: 18,
                              color: isSelected ? AppTheme.forestGreen : AppTheme.textSecondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method.displayName,
                              style: TextStyle(
                                color: isSelected ? AppTheme.forestGreen : AppTheme.textSecondary,
                                fontSize: 10.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Nota opcional
              TextFormField(
                controller: _noteController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Nota o detalle (opcional)',
                  prefixIcon: Icon(Icons.sticky_note_2_rounded, color: AppTheme.textMuted),
                  hintText: 'Detalles adicionales...',
                ),
              ),
              const SizedBox(height: 30),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: Text(_isExpense ? 'Guardar Gasto & Nutrir Jardín' : 'Guardar Ingreso & Regar Plantas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
