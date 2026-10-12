import 'package:flutter/material.dart';
import '../services/game_state_service.dart';
import '../theme/app_theme.dart';
import '../models/gamification.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = GameStateService();

    return ListenableBuilder(
      listenable: gameService,
      builder: (context, _) {
        final hero = gameService.hero;
        final items = gameService.shopItems;

        return Scaffold(
          appBar: AppBar(
            title: const Text('🪴 Invernadero Botánico'),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.shibaGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.shibaGold),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: AppTheme.shibaGoldDark, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${hero.gold} MF',
                      style: const TextStyle(
                        color: AppTheme.shibaGoldDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Banner del Invernadero
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
                child: const Row(
                  children: [
                    Icon(Icons.storefront_rounded, color: AppTheme.forestGreen, size: 36),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Herramientas del Jardinero',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Canjea tus monedas MF ganadas con el ahorro por fertilizante, regaderas y macetas zen.',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Suministros Disponibles',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ...items.map((item) => _buildShopItemCard(context, item, hero, gameService)),

              const SizedBox(height: 24),
              // Inventario Actual
              const Text(
                'Tu Cobertizo de Herramientas',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (hero.inventory.isEmpty)
                const Text(
                  'Aún no posees herramientas adicionales en tu cobertizo.',
                  style: TextStyle(color: AppTheme.textMuted),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: hero.inventory.map((inv) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.handyman_rounded, color: AppTheme.forestGreen, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            inv,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopItemCard(
    BuildContext context,
    ShopItem item,
    HeroStats hero,
    GameStateService gameService,
  ) {
    final canAfford = hero.gold >= item.cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.sageGreen,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.5)),
            ),
            child: Icon(item.icon, color: AppTheme.forestGreen, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: canAfford
                ? () {
                    final success = gameService.buyShopItem(item);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡Adquiriste ${item.name}! Tu jardín se fortalece 🌿'),
                          backgroundColor: AppTheme.forestGreen,
                        ),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.forestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on_rounded, size: 15, color: AppTheme.shibaGold),
                const SizedBox(width: 4),
                Text('${item.cost}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
