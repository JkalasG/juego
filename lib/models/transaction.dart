import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  housing,
  transport,
  leisure,
  shopping,
  health,
  education,
  subscriptions,
  debt,
  investment,
  incomeSalary,
  incomeExtra,
  other;

  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Alimentación & Súper';
      case ExpenseCategory.housing:
        return 'Vivienda & Servicios';
      case ExpenseCategory.transport:
        return 'Transporte & Movilidad';
      case ExpenseCategory.leisure:
        return 'Ocio & Salidas';
      case ExpenseCategory.shopping:
        return 'Compras Personales';
      case ExpenseCategory.health:
        return 'Salud & Cuidado';
      case ExpenseCategory.education:
        return 'Educación & Libros';
      case ExpenseCategory.subscriptions:
        return 'Suscripciones & Streaming';
      case ExpenseCategory.debt:
        return 'Pago de Deudas';
      case ExpenseCategory.investment:
        return 'Ahorro & Inversión';
      case ExpenseCategory.incomeSalary:
        return 'Salario / Sueldo';
      case ExpenseCategory.incomeExtra:
        return 'Ingreso Extra';
      case ExpenseCategory.other:
        return 'Otros';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.housing:
        return Icons.home_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.leisure:
        return Icons.sports_esports_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.health:
        return Icons.local_hospital_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.subscriptions:
        return Icons.ondemand_video_rounded;
      case ExpenseCategory.debt:
        return Icons.credit_card_off_rounded;
      case ExpenseCategory.investment:
        return Icons.trending_up_rounded;
      case ExpenseCategory.incomeSalary:
        return Icons.account_balance_wallet_rounded;
      case ExpenseCategory.incomeExtra:
        return Icons.monetization_on_rounded;
      case ExpenseCategory.other:
        return Icons.category_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return const Color(0xFFF59E0B); // Amber
      case ExpenseCategory.housing:
        return const Color(0xFF3B82F6); // Blue
      case ExpenseCategory.transport:
        return const Color(0xFF06B6D4); // Cyan
      case ExpenseCategory.leisure:
        return const Color(0xFFEC4899); // Pink
      case ExpenseCategory.shopping:
        return const Color(0xFFA855F7); // Purple
      case ExpenseCategory.health:
        return const Color(0xFFEF4444); // Red
      case ExpenseCategory.education:
        return const Color(0xFF6366F1); // Indigo
      case ExpenseCategory.subscriptions:
        return const Color(0xFF8B5CF6); // Violet
      case ExpenseCategory.debt:
        return const Color(0xFFE11D48); // Rose
      case ExpenseCategory.investment:
        return const Color(0xFF10B981); // Emerald
      case ExpenseCategory.incomeSalary:
        return const Color(0xFF10B981); // Emerald
      case ExpenseCategory.incomeExtra:
        return const Color(0xFF34D399); // Light green
      case ExpenseCategory.other:
        return const Color(0xFF94A3B8); // Slate
    }
  }
}

enum ExpenseNature {
  essential, // Necesidad básica (alimentación, techo, salud) -> Da bonos de estabilidad
  optional,  // Deseo / Gusto (antojos, caprichos) -> Cuidado con despertar al jefe
  investment; // Ahorro / Inversión de futuro -> ¡Ataque crítico al jefe!

  String get displayName {
    switch (this) {
      case ExpenseNature.essential:
        return '🛡️ Necesidad Básica';
      case ExpenseNature.optional:
        return '✨ Gusto / Opcional';
      case ExpenseNature.investment:
        return '💎 Ahorro / Inversión';
    }
  }

  String get rpgEffect {
    switch (this) {
      case ExpenseNature.essential:
        return '🌱 Nutre el Suelo: +15 XP y +10 Gotas de Rocío';
      case ExpenseNature.optional:
        return '🍂 Podar con Cuidado: registrarlo evita malezas';
      case ExpenseNature.investment:
        return '☀️ Sol Radiante: +40 XP, +25 Monedas MF y acelera la Floración';
    }
  }
}

enum PaymentMethod {
  cash,
  debitCard,
  creditCard,
  transfer;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Efectivo';
      case PaymentMethod.debitCard:
        return 'Tarjeta Débito';
      case PaymentMethod.creditCard:
        return 'Tarjeta Crédito';
      case PaymentMethod.transfer:
        return 'Transferencia';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.payments_rounded;
      case PaymentMethod.debitCard:
        return Icons.credit_card_rounded;
      case PaymentMethod.creditCard:
        return Icons.credit_score_rounded;
      case PaymentMethod.transfer:
        return Icons.account_balance_rounded;
    }
  }
}

class FinancialTransaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final ExpenseCategory category;
  final ExpenseNature nature;
  final PaymentMethod paymentMethod;
  final String note;

  FinancialTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.category,
    this.nature = ExpenseNature.essential,
    this.paymentMethod = PaymentMethod.debitCard,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'isExpense': isExpense,
      'category': category.name,
      'nature': nature.name,
      'paymentMethod': paymentMethod.name,
      'note': note,
    };
  }

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) {
    return FinancialTransaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      isExpense: json['isExpense'] as bool? ?? true,
      category: ExpenseCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      nature: ExpenseNature.values.firstWhere(
        (n) => n.name == json['nature'],
        orElse: () => ExpenseNature.essential,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == json['paymentMethod'],
        orElse: () => PaymentMethod.debitCard,
      ),
      note: json['note'] as String? ?? '',
    );
  }
}
