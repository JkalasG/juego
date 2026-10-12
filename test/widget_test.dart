import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:metafin/main.dart';
import 'package:metafin/services/game_state_service.dart';
import 'package:metafin/models/transaction.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MetaFinApp carga y muestra el título principal del jardín', (WidgetTester tester) async {
    await tester.pumpWidget(const MetaFinApp());
    await tester.pump();
    expect(find.text('MetaFin'), findsOneWidget);
  });

  test('GameStateService calcula balances y riega las plantas del jardín', () async {
    final service = GameStateService();
    await service.init();

    final initialCount = service.transactions.length;
    final initialWater = service.waterDrops;
    expect(initialWater, greaterThan(0));

    // Agregar un gasto de prueba
    await service.addTransaction(FinancialTransaction(
      id: 'test_tx',
      title: 'Abono para jardín',
      amount: 45.0,
      date: DateTime.now(),
      isExpense: true,
      category: ExpenseCategory.food,
      nature: ExpenseNature.essential,
    ));

    expect(service.transactions.length, initialCount + 1);
    expect(service.transactions.first.title, 'Abono para jardín');

    // Regar planta activa
    final canWater = service.waterActivePlant(10);
    expect(canWater, isTrue);
  });
}
