import 'package:flutter/material.dart';
import '../services/game_state_service.dart';
import '../theme/app_theme.dart';
import '../models/gamification.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = GameStateService();

    return ListenableBuilder(
      listenable: gameService,
      builder: (context, _) {
        final quests = gameService.quests;
        final hero = gameService.hero;

        return Scaffold(
          appBar: AppBar(
            title: const Text('📋 Cuidados & Misiones'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Banner de Cabecera con estética botánica
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE5EFE9), Color(0xFFFDFBF7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.mintGreen.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.yard_rounded, color: AppTheme.forestGreen, size: 30),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tablón de Cuidados Diarios',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Cada hábito financiero registrado aporta agua, sol y nutrientes a tus plantas.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Lista de Misiones
              const Text(
                'Tareas del Día',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...quests.map((quest) => _buildQuestCard(context, quest, gameService)),
              const SizedBox(height: 24),

              // Sección de Insignias Botánicas
              const Text(
                'Insignias Botánicas Desbloqueadas',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: hero.unlockedBadges.map((badge) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.shibaGold.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: AppTheme.shibaGoldDark, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          badge,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
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

  Widget _buildQuestCard(BuildContext context, DailyQuest quest, GameStateService gameService) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: quest.isCompleted ? AppTheme.mintGreen.withValues(alpha: 0.6) : AppTheme.border,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (quest.isCompleted ? AppTheme.mintGreen : AppTheme.sageGreen).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  quest.icon,
                  color: quest.isCompleted ? AppTheme.forestGreen : AppTheme.forestGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quest.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (quest.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.mintGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.mintGreen, width: 0.8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, color: AppTheme.forestGreen, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Completada',
                        style: TextStyle(
                          color: AppTheme.forestGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Barra de Progreso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso: ${quest.currentCount} / ${quest.targetCount}',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11.5),
              ),
              Row(
                children: [
                  const Icon(Icons.eco_rounded, color: AppTheme.forestGreen, size: 13),
                  Text(
                    '+${quest.xpReward} XP  ',
                    style: const TextStyle(color: AppTheme.forestGreen, fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.monetization_on_rounded, color: AppTheme.shibaGoldDark, size: 13),
                  Text(
                    '+${quest.goldReward} MF',
                    style: const TextStyle(color: AppTheme.shibaGoldDark, fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: quest.progress,
              minHeight: 6,
              backgroundColor: AppTheme.sageGreen,
              valueColor: AlwaysStoppedAnimation<Color>(
                quest.isCompleted ? AppTheme.mintGreen : AppTheme.forestGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
