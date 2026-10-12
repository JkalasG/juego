import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/plant.dart';
import '../models/gamification.dart';

class GameStateService extends ChangeNotifier {
  static final GameStateService _instance = GameStateService._internal();
  factory GameStateService() => _instance;
  GameStateService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  double _monthlyBudget = 1500.0;
  double get monthlyBudget => _monthlyBudget;

  List<FinancialTransaction> _transactions = [];
  List<FinancialTransaction> get transactions => List.unmodifiable(_transactions);

  // Jardín Botánico
  List<GardenPlant> _plants = [];
  List<GardenPlant> get plants => List.unmodifiable(_plants);
  int _activePlantIndex = 0;
  int get activePlantIndex => _activePlantIndex;
  GardenPlant get activePlant => _plants[_activePlantIndex];

  // Jardinero / Héroe
  HeroStats _hero = HeroStats();
  HeroStats get hero => _hero;

  // Recursos botánicos
  int _waterDrops = 65; // Gotas de rocío para regar
  int get waterDrops => _waterDrops;

  final int _sunlightScore = 80; // Energía solar
  int get sunlightScore => _sunlightScore;

  List<DailyQuest> _quests = [];
  List<DailyQuest> get quests => List.unmodifiable(_quests);

  List<ShopItem> _shopItems = [];
  List<ShopItem> get shopItems => List.unmodifiable(_shopItems);

  Future<void> init() async {
    if (_isInitialized) return;

    _initializeGardenPlants();
    _initializeQuests();
    _initializeShop();

    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionsJson = prefs.getString('metafin_transactions');
      if (transactionsJson != null) {
        final List<dynamic> decoded = jsonDecode(transactionsJson);
        _transactions = decoded.map((e) => FinancialTransaction.fromJson(e)).toList();
      } else {
        _loadDefaultTransactions();
      }

      final heroJson = prefs.getString('metafin_hero');
      if (heroJson != null) {
        _hero = HeroStats.fromJson(jsonDecode(heroJson));
      }

      final budgetVal = prefs.getDouble('metafin_budget');
      if (budgetVal != null) {
        _monthlyBudget = budgetVal;
      }

      final waterVal = prefs.getInt('metafin_water');
      if (waterVal != null) {
        _waterDrops = waterVal;
      }

      final plantsJson = prefs.getString('metafin_plants');
      if (plantsJson != null) {
        final List<dynamic> pList = jsonDecode(plantsJson);
        _plants = pList.map((p) => GardenPlant.fromJson(p)).toList();
      }
    } catch (e) {
      debugPrint('Error cargando datos locales del jardín: $e');
      if (_transactions.isEmpty) {
        _loadDefaultTransactions();
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  void _initializeGardenPlants() {
    _plants = [
      GardenPlant(
        id: 'plant_pothos',
        name: 'Pothos de la Frugalidad',
        species: 'Epipremnum Frugale',
        lore: 'Una planta resistente y leal. Crece con cada registro diario de gastos y purifica tu aire financiero.',
        stage: PlantStage.growing,
        currentWater: 35,
        waterPerStage: 50,
        sunlightScore: 40,
        themeColor: const Color(0xFF2ED59A),
      ),
      GardenPlant(
        id: 'plant_sunflower',
        name: 'Girasol del Presupuesto',
        species: 'Helianthus Fiduciario',
        lore: 'Sigue la luz dorada de tus metas. Cuando te mantienes bajo tu presupuesto mensual, produce hermosas flores doradas.',
        stage: PlantStage.sprout,
        currentWater: 15,
        waterPerStage: 60,
        sunlightScore: 70,
        themeColor: const Color(0xFFF6A843),
      ),
      GardenPlant(
        id: 'plant_bamboo',
        name: 'Bambú de la Disciplina',
        species: 'Bambusa Constans',
        lore: 'Flexible pero inquebrantable. Aumenta su altura con cada día que mantienes tu racha de control financiero.',
        stage: PlantStage.sprout,
        currentWater: 20,
        waterPerStage: 50,
        sunlightScore: 30,
        themeColor: const Color(0xFF10B981),
      ),
      GardenPlant(
        id: 'plant_jade',
        name: 'Árbol de Jade de la Abundancia',
        species: 'Crassula Ovata Fortuna',
        lore: 'El árbol botánico de la prosperidad. Absorbe tus ahorros e inversiones y genera monedas MF periódicamente.',
        stage: PlantStage.seed,
        currentWater: 10,
        waterPerStage: 80,
        sunlightScore: 85,
        themeColor: const Color(0xFF0C5844),
      ),
    ];
  }

  void selectPlant(int index) {
    if (index >= 0 && index < _plants.length) {
      _activePlantIndex = index;
      notifyListeners();
    }
  }

  void _initializeQuests() {
    _quests = [
      DailyQuest(
        id: 'quest_water_daily',
        title: 'Rocío Matutino',
        description: 'Registra al menos 1 movimiento hoy para ganar agua fresca.',
        targetCount: 1,
        currentCount: 1,
        xpReward: 25,
        goldReward: 15,
        isCompleted: true,
        icon: Icons.water_drop_rounded,
      ),
      DailyQuest(
        id: 'quest_nourish_soil',
        title: 'Tierra Fértil',
        description: 'Registra un gasto en Necesidad Básica para fertilizar el suelo.',
        targetCount: 1,
        currentCount: 0,
        xpReward: 35,
        goldReward: 20,
        isCompleted: false,
        icon: Icons.eco_rounded,
      ),
      DailyQuest(
        id: 'quest_sunlight_save',
        title: 'Baño de Sol Radiante',
        description: 'Registra un ahorro o inversión para bañar tu jardín con luz.',
        targetCount: 1,
        currentCount: 0,
        xpReward: 50,
        goldReward: 35,
        isCompleted: false,
        icon: Icons.wb_sunny_rounded,
      ),
      DailyQuest(
        id: 'quest_streak_care',
        title: 'Cuidado Constante',
        description: 'Riega a tu planta al menos 3 veces para fortalecer sus raíces.',
        targetCount: 3,
        currentCount: 1,
        xpReward: 60,
        goldReward: 40,
        isCompleted: false,
        icon: Icons.yard_rounded,
      ),
    ];
  }

  void _initializeShop() {
    _shopItems = [
      ShopItem(
        id: 'item_super_fertilizer',
        name: 'Abono Orgánico Premium',
        description: 'Acelera el crecimiento de tu planta aportando +30 de riego inmediato.',
        cost: 45,
        icon: Icons.eco_rounded,
        color: const Color(0xFF2ED59A),
      ),
      ShopItem(
        id: 'item_golden_watering_can',
        name: 'Regadera Shiba Dorada',
        description: 'Aumenta en un 25% las gotas de rocío obtenidas por cada registro.',
        cost: 90,
        icon: Icons.shower_rounded,
        color: const Color(0xFFF6A843),
      ),
      ShopItem(
        id: 'item_zen_pot',
        name: 'Maceta de Cerámica Zen',
        description: 'Protege a tu planta contra la maleza de compras impulsivas.',
        cost: 120,
        icon: Icons.local_florist_rounded,
        color: const Color(0xFF0C5844),
      ),
      ShopItem(
        id: 'item_shiba_charm',
        name: 'Amuleto Botánico del Shiba',
        description: 'Otorga un bono de floración y duplica los frutos de cosecha.',
        cost: 200,
        icon: Icons.stars_rounded,
        color: const Color(0xFFF59E0B),
      ),
    ];
  }

  void _loadDefaultTransactions() {
    final now = DateTime.now();
    _transactions = [
      FinancialTransaction(
        id: 'tx_1',
        title: 'Supermercado semanal',
        amount: 78.50,
        date: now.subtract(const Duration(hours: 3)),
        isExpense: true,
        category: ExpenseCategory.food,
        nature: ExpenseNature.essential,
        paymentMethod: PaymentMethod.debitCard,
        note: 'Verduras frescas y despensa del hogar',
      ),
      FinancialTransaction(
        id: 'tx_2',
        title: 'Ingreso Nómina',
        amount: 850.00,
        date: now.subtract(const Duration(days: 2)),
        isExpense: false,
        category: ExpenseCategory.incomeSalary,
        nature: ExpenseNature.investment,
        paymentMethod: PaymentMethod.transfer,
        note: 'Salario quincenal',
      ),
      FinancialTransaction(
        id: 'tx_3',
        title: 'Café & Pastelería',
        amount: 6.40,
        date: now.subtract(const Duration(days: 1)),
        isExpense: true,
        category: ExpenseCategory.leisure,
        nature: ExpenseNature.optional,
        paymentMethod: PaymentMethod.cash,
        note: 'Antojo de media tarde',
      ),
      FinancialTransaction(
        id: 'tx_4',
        title: 'Transporte público / Metro',
        amount: 18.00,
        date: now.subtract(const Duration(days: 3)),
        isExpense: true,
        category: ExpenseCategory.transport,
        nature: ExpenseNature.essential,
        paymentMethod: PaymentMethod.debitCard,
        note: 'Recarga tarjeta de transporte',
      ),
      FinancialTransaction(
        id: 'tx_5',
        title: 'Aporte a Inversión / Ahorro',
        amount: 100.00,
        date: now.subtract(const Duration(days: 4)),
        isExpense: true,
        category: ExpenseCategory.investment,
        nature: ExpenseNature.investment,
        paymentMethod: PaymentMethod.transfer,
        note: 'Fondo de crecimiento futuro',
      ),
    ];
  }

  // Cálculos financieros
  double get totalIncome => _transactions
      .where((t) => !t.isExpense)
      .fold(0.0, (acc, t) => acc + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.isExpense)
      .fold(0.0, (acc, t) => acc + t.amount);

  double get currentBalance => totalIncome - totalExpenses;

  double get budgetProgress => (totalExpenses / _monthlyBudget).clamp(0.0, 1.0);

  double get savingsRate {
    if (totalIncome == 0) return 0.0;
    final saved = totalIncome - totalExpenses;
    if (saved <= 0) return 0.0;
    return (saved / totalIncome) * 100;
  }

  Map<ExpenseCategory, double> get expensesByCategory {
    final Map<ExpenseCategory, double> map = {};
    for (var tx in _transactions.where((t) => t.isExpense)) {
      map[tx.category] = (map[tx.category] ?? 0.0) + tx.amount;
    }
    return map;
  }

  Map<ExpenseNature, double> get expensesByNature {
    final Map<ExpenseNature, double> map = {
      ExpenseNature.essential: 0.0,
      ExpenseNature.optional: 0.0,
      ExpenseNature.investment: 0.0,
    };
    for (var tx in _transactions.where((t) => t.isExpense)) {
      map[tx.nature] = (map[tx.nature] ?? 0.0) + tx.amount;
    }
    return map;
  }

  // Acción de regar planta
  bool waterActivePlant(int dropsToSpend) {
    if (_waterDrops >= dropsToSpend && dropsToSpend > 0) {
      _waterDrops -= dropsToSpend;
      activePlant.waterPlant(dropsToSpend);
      _hero.gainXp(dropsToSpend);
      _hero.heal(5);
      _updateQuestProgress('quest_streak_care', 1);
      _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Mecánicas de Gamificación botánica al registrar transacciones
  Future<String> addTransaction(FinancialTransaction tx) async {
    _transactions.insert(0, tx);

    String gardenReport = '';

    if (!tx.isExpense) {
      // Registró Ingreso
      final earnedWater = 25;
      final earnedGold = 30;
      final earnedXp = 40;

      _waterDrops += earnedWater;
      _hero.gold += earnedGold;
      _hero.gainXp(earnedXp);
      _hero.heal(10);
      activePlant.addSunlight(20);

      gardenReport = '🌿 ¡Lluvia nutricia en tu jardín! Ganaste +$earnedWater Gotas de Rocío 💧, +$earnedGold Monedas MF 🪙 y +$earnedXp XP.';
      _updateQuestProgress('quest_sunlight_save', 1);
    } else {
      // Registró Gasto
      if (tx.nature == ExpenseNature.investment) {
        // Ahorro/Inversión -> Baño de sol directo
        final earnedWater = 20;
        final earnedGold = 25;
        _waterDrops += earnedWater;
        _hero.gold += earnedGold;
        _hero.gainXp(35);
        _hero.heal(8);
        activePlant.addSunlight(35);
        activePlant.waterPlant(15);

        gardenReport = '☀️ ¡Rayo de Sol Radiante! Tu ahorro nutre directamente a ${activePlant.name}. Ganaste +$earnedWater Gotas de Rocío y +$earnedGold Monedas MF.';
        _updateQuestProgress('quest_sunlight_save', 1);
      } else if (tx.nature == ExpenseNature.essential) {
        // Necesidad básica
        final earnedWater = 12;
        _waterDrops += earnedWater;
        _hero.gold += 10;
        _hero.gainXp(20);
        activePlant.waterPlant(8);

        gardenReport = '🌱 ¡Tierra fértil! Registraste un gasto esencial planificado. Tu jardín recibe +$earnedWater Gotas de Rocío y +20 XP.';
        _updateQuestProgress('quest_nourish_soil', 1);
      } else {
        // Deseo / Opcional (Gasto Hormiga)
        _waterDrops += 5; // Aún gana un poco por ser sincero
        _hero.gainXp(10);
        final hpLoss = (tx.amount * 0.12).clamp(2.0, 15.0).toInt();
        _hero.takeDamage(hpLoss);

        gardenReport = '🍂 ¡Apareció un brote de maleza! Podarlo es fácil registrando con moderación. Ganaste +5 Gotas de Rocío por sinceridad, pero tu vitalidad disminuyó -$hpLoss HP.';
      }
    }

    _updateQuestProgress('quest_water_daily', 1);

    await _saveData();
    notifyListeners();
    return gardenReport;
  }

  void _updateQuestProgress(String questId, int amount) {
    for (var quest in _quests) {
      if (quest.id == questId && !quest.isCompleted) {
        quest.currentCount += amount;
        if (quest.currentCount >= quest.targetCount) {
          quest.currentCount = quest.targetCount;
          quest.isCompleted = true;
          _hero.gainXp(quest.xpReward);
          _hero.gold += quest.goldReward;
          _waterDrops += 15;
        }
      }
    }
  }

  bool buyShopItem(ShopItem item) {
    if (_hero.gold >= item.cost) {
      _hero.gold -= item.cost;
      if (item.id == 'item_super_fertilizer') {
        activePlant.waterPlant(30);
      } else if (item.id == 'item_golden_watering_can') {
        _waterDrops += 50;
      }
      _hero.inventory.add(item.name);
      _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateBudget(double newBudget) async {
    _monthlyBudget = newBudget;
    await _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final txList = _transactions.map((t) => t.toJson()).toList();
      await prefs.setString('metafin_transactions', jsonEncode(txList));
      await prefs.setString('metafin_hero', jsonEncode(_hero.toJson()));
      await prefs.setDouble('metafin_budget', _monthlyBudget);
      await prefs.setInt('metafin_water', _waterDrops);

      final plantsList = _plants.map((p) => p.toJson()).toList();
      await prefs.setString('metafin_plants', jsonEncode(plantsList));
    } catch (e) {
      debugPrint('Error guardando datos botánicos: $e');
    }
  }
}
