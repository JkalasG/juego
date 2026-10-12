import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../theme/app_theme.dart';

class GardenOverviewCard extends StatelessWidget {
  final GardenPlant plant;
  final List<GardenPlant> allPlants;
  final int selectedIndex;
  final ValueChanged<int> onSelectPlant;
  final int waterDrops;
  final int goldCoins;
  final VoidCallback onWaterTap;

  const GardenOverviewCard({
    super.key,
    required this.plant,
    required this.allPlants,
    required this.selectedIndex,
    required this.onSelectPlant,
    required this.waterDrops,
    required this.goldCoins,
    required this.onWaterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.forestGreen.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Mascota Shiba & Recursos Botánicos
          Row(
            children: [
              // Avatar con la Mascota Shiba
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.shibaGold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shibaGold.withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/shiba_mascota.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.sageGreen,
                      child: const Icon(Icons.pets_rounded, color: AppTheme.forestGreen, size: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shiba Guardián',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '🐾 Tu Invernadero Financiero',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Contadores: Rocío 💧 y Monedas MF 🪙
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.waterBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.waterBlue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop_rounded, color: AppTheme.waterBlue, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$waterDrops',
                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.shibaGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.shibaGold.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_rounded, color: AppTheme.shibaGoldDark, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$goldCoins',
                          style: const TextStyle(
                            color: AppTheme.shibaGoldDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Selector de Plantas del Jardín
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allPlants.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final p = allPlants[i];
                final isSelected = i == selectedIndex;
                return GestureDetector(
                  onTap: () => onSelectPlant(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.forestGreen : AppTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppTheme.forestGreen : AppTheme.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(p.stage.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          p.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Tarjeta Central de la Planta Activa
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.sageGreen.withValues(alpha: 0.7),
                  AppTheme.background,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Maceta con Emoji en Grande
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.forestGreen.withValues(alpha: 0.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          plant.stage.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  plant.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.mintGreen.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  plant.stage.stageName,
                                  style: const TextStyle(
                                    color: AppTheme.forestGreen,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plant.species,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontStyle: FontStyle.italic,
                              fontSize: 11.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            plant.lore,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progreso de Riego & Crecimiento
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.water_drop_outlined, color: AppTheme.waterBlue, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          'Cuidado de Riego: ${plant.currentWater}/${plant.waterPerStage}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${(plant.stageProgress * 100).toInt()}% para evolucionar',
                      style: const TextStyle(
                        color: AppTheme.forestGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: plant.stageProgress,
                    minHeight: 10,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.mintGreen),
                  ),
                ),
                const SizedBox(height: 14),

                // Botón interactivo de regar planta
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: waterDrops >= 10 ? onWaterTap : null,
                        icon: const Icon(Icons.shower_rounded, size: 18),
                        label: Text(
                          waterDrops >= 10
                              ? 'Regar Planta (-10 Gotas 💧)'
                              : 'Registra gastos para recargar gotas',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.forestGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
