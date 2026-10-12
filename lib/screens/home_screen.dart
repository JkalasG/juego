import 'package:flutter/material.dart';
import '../services/game_state_service.dart';
import '../theme/app_theme.dart';
import '../widgets/hero_card.dart';
import '../widgets/garden_overview_card.dart';
import '../widgets/financial_summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';
import 'quests_screen.dart';
import 'analytics_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    GameStateService().init();
  }

  void _openAddTransaction([bool isExpense = true]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(initialIsExpense: isExpense),
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, double currentBudget) {
    final controller = TextEditingController(text: currentBudget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Row(
          children: [
            Icon(Icons.tune_rounded, color: AppTheme.forestGreen),
            SizedBox(width: 8),
            Text(
              'Presupuesto Mensual',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            labelText: 'Meta Máxima Mensual (\$)',
            prefixIcon: Icon(Icons.attach_money_rounded, color: AppTheme.forestGreen),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? currentBudget;
              if (val > 0) {
                GameStateService().updateBudget(val);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameService = GameStateService();

    final pages = [
      _buildGardenTab(gameService),
      const QuestsScreen(),
      const AnalyticsScreen(),
      const ShopScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _openAddTransaction(true),
              backgroundColor: AppTheme.forestGreen,
              foregroundColor: Colors.white,
              elevation: 3,
              icon: const Icon(Icons.add_rounded, size: 24),
              label: const Text(
                'Registrar Movimiento',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.yard_outlined),
            selectedIcon: Icon(Icons.yard_rounded),
            label: 'Jardín',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt_rounded),
            label: 'Cuidados',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Oráculo',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Invernadero',
          ),
        ],
      ),
    );
  }

  Widget _buildGardenTab(GameStateService gameService) {
    return ListenableBuilder(
      listenable: gameService,
      builder: (context, _) {
        if (!gameService.isInitialized) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.forestGreen));
        }

        final hero = gameService.hero;
        final plant = gameService.activePlant;
        final allPlants = gameService.plants;
        final transactions = gameService.transactions;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.sageGreen,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/shiba_mascota.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.eco_rounded,
                          color: AppTheme.forestGreen,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MetaFin',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: AppTheme.forestGreen,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Registrar Ingreso Rápido',
                  icon: const Icon(Icons.savings_rounded, color: AppTheme.forestGreen),
                  onPressed: () => _openAddTransaction(false),
                ),
                IconButton(
                  tooltip: 'Registrar Gasto Rápido',
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: AppTheme.coralSoft),
                  onPressed: () => _openAddTransaction(true),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Tarjeta del Jardinero
                    HeroCard(hero: hero),
                    const SizedBox(height: 16),

                    // 2. Tarjeta del Jardín y Planta en Crecimiento
                    GardenOverviewCard(
                      plant: plant,
                      allPlants: allPlants,
                      selectedIndex: gameService.activePlantIndex,
                      onSelectPlant: (i) => gameService.selectPlant(i),
                      waterDrops: gameService.waterDrops,
                      goldCoins: hero.gold,
                      onWaterTap: () {
                        final success = gameService.waterActivePlant(10);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('¡Regaste a ${plant.name}! Crecimiento acelerado 🌿'),
                              backgroundColor: AppTheme.forestGreen,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    // 3. Resumen Financiero Realista
                    FinancialSummaryCard(
                      currentBalance: gameService.currentBalance,
                      totalIncome: gameService.totalIncome,
                      totalExpenses: gameService.totalExpenses,
                      monthlyBudget: gameService.monthlyBudget,
                      savingsRate: gameService.savingsRate,
                      onEditBudgetTap: () => _showEditBudgetDialog(context, gameService.monthlyBudget),
                    ),
                    const SizedBox(height: 22),

                    // 4. Registro de Movimientos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Movimientos Recientes',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${transactions.length} registros',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (transactions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: const Text(
                          'No hay transacciones registradas aún.\n¡Presiona el botón "+" para registrar tu primer gasto o ingreso!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      )
                    else
                      ...transactions.map(
                        (tx) => TransactionTile(
                          transaction: tx,
                          onDelete: () => gameService.deleteTransaction(tx.id),
                        ),
                      ),
                    const SizedBox(height: 80), // Margen para el FAB
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
