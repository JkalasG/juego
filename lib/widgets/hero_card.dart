import 'package:flutter/material.dart';
import '../models/gamification.dart';
import '../theme/app_theme.dart';

class HeroCard extends StatelessWidget {
  final HeroStats hero;

  const HeroCard({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.forestGreen.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.sageGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.mintGreen, width: 1.5),
                ),
                child: const Icon(
                  Icons.yard_rounded,
                  color: AppTheme.forestGreen,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Jardinero Financiero',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.mintGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'NV. ${hero.level}',
                            style: const TextStyle(
                              color: AppTheme.forestGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '🌱 ${_getBotanicalRank(hero.level)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Racha
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.shibaGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.shibaGold.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: AppTheme.shibaGoldDark, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      '${hero.streak} días racha',
                      style: const TextStyle(
                        color: AppTheme.shibaGoldDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Vitalidad del Jardín (HP)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite_rounded, color: AppTheme.mintGreen, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Vitalidad del Jardín (Salud)',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${hero.hp}/100 HP',
                style: const TextStyle(
                  color: AppTheme.forestGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hero.hp / 100.0,
              minHeight: 6,
              backgroundColor: AppTheme.sageGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.mintGreen),
            ),
          ),
          const SizedBox(height: 10),

          // Progreso XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.eco_rounded, color: AppTheme.forestGreen, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Sabiduría Botánica (XP)',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${hero.xp % 100} / ${hero.xpForNextLevel} XP',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hero.xpProgress,
              minHeight: 6,
              backgroundColor: AppTheme.sageGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.forestGreen),
            ),
          ),
        ],
      ),
    );
  }

  String _getBotanicalRank(int level) {
    if (level < 3) return 'Brote Principiante';
    if (level < 6) return 'Jardinero Constante';
    if (level < 10) return 'Botánico del Presupuesto';
    if (level < 15) return 'Guardián de la Floresta';
    return 'Maestro de la Cosecha Dorada';
  }
}
