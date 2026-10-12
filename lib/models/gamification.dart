import 'package:flutter/material.dart';

class HeroStats {
  String name;
  int level;
  int xp;
  int hp; // Salud Financiera 0 - 100
  int gold; // Monedas MetaFin
  int streak; // Días seguidos
  DateTime lastActiveDate;
  List<String> inventory;
  List<String> unlockedBadges;

  HeroStats({
    this.name = 'Guardián del Presupuesto',
    this.level = 1,
    this.xp = 45,
    this.hp = 92,
    this.gold = 150,
    this.streak = 3,
    DateTime? lastActiveDate,
    List<String>? inventory,
    List<String>? unlockedBadges,
  })  : lastActiveDate = lastActiveDate ?? DateTime.now(),
        inventory = inventory ?? ['Poción de Prudencia'],
        unlockedBadges = unlockedBadges ?? ['Primer Registro', 'Racha de 3 Días'];

  int get xpForNextLevel => level * 100;
  double get xpProgress => (xp % 100) / 100.0;

  String get rankTitle {
    if (level < 3) return 'Novato Frugal';
    if (level < 6) return 'Escudero del Ahorro';
    if (level < 10) return 'Guardián del Presupuesto';
    if (level < 15) return 'Caballero Antideuda';
    if (level < 20) return 'Paladín Financiero';
    return 'Archimago del Interés Compuesto';
  }

  void gainXp(int amount) {
    xp += amount;
    while (xp >= level * 100) {
      xp -= level * 100;
      level++;
      hp = (hp + 15).clamp(0, 100);
      gold += level * 25;
    }
  }

  void takeDamage(int damage) {
    hp = (hp - damage).clamp(0, 100);
  }

  void heal(int amount) {
    hp = (hp + amount).clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'level': level,
        'xp': xp,
        'hp': hp,
        'gold': gold,
        'streak': streak,
        'lastActiveDate': lastActiveDate.toIso8601String(),
        'inventory': inventory,
        'unlockedBadges': unlockedBadges,
      };

  factory HeroStats.fromJson(Map<String, dynamic> json) => HeroStats(
        name: json['name'] as String? ?? 'Guardián del Presupuesto',
        level: json['level'] as int? ?? 1,
        xp: json['xp'] as int? ?? 0,
        hp: json['hp'] as int? ?? 100,
        gold: json['gold'] as int? ?? 100,
        streak: json['streak'] as int? ?? 1,
        lastActiveDate: json['lastActiveDate'] != null
            ? DateTime.parse(json['lastActiveDate'] as String)
            : DateTime.now(),
        inventory: (json['inventory'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
        unlockedBadges: (json['unlockedBadges'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      );
}

class BossMonster {
  final String id;
  final String name;
  final String title;
  final String description;
  final String weakness;
  int currentHp;
  final int maxHp;
  final int goldReward;
  final int xpReward;
  final IconData icon;
  final Color themeColor;
  bool isDefeated;

  BossMonster({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.weakness,
    required this.currentHp,
    required this.maxHp,
    required this.goldReward,
    required this.xpReward,
    required this.icon,
    required this.themeColor,
    this.isDefeated = false,
  });

  double get hpPercent => (currentHp / maxHp).clamp(0.0, 1.0);

  void takeDamage(int damage) {
    currentHp = (currentHp - damage).clamp(0, maxHp);
    if (currentHp == 0) {
      isDefeated = true;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'weakness': weakness,
        'currentHp': currentHp,
        'maxHp': maxHp,
        'goldReward': goldReward,
        'xpReward': xpReward,
        'isDefeated': isDefeated,
      };

  factory BossMonster.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    // Map icons and colors
    IconData icon = Icons.bug_report_rounded;
    Color color = Colors.orange;
    if (id == 'boss_debt') {
      icon = Icons.credit_card_off_rounded;
      color = const Color(0xFFEF4444);
    } else if (id == 'boss_inflation') {
      icon = Icons.local_fire_department_rounded;
      color = const Color(0xFFDC2626);
    } else if (id == 'boss_subscriptions') {
      icon = Icons.cyclone_rounded;
      color = const Color(0xFF8B5CF6);
    }

    return BossMonster(
      id: id,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      weakness: json['weakness'] as String,
      currentHp: json['currentHp'] as int,
      maxHp: json['maxHp'] as int,
      goldReward: json['goldReward'] as int,
      xpReward: json['xpReward'] as int,
      icon: icon,
      themeColor: color,
      isDefeated: json['isDefeated'] as bool? ?? false,
    );
  }
}

class DailyQuest {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  int currentCount;
  final int xpReward;
  final int goldReward;
  bool isCompleted;
  final IconData icon;

  DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    this.currentCount = 0,
    required this.xpReward,
    required this.goldReward,
    this.isCompleted = false,
    required this.icon,
  });

  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'xpReward': xpReward,
        'goldReward': goldReward,
        'isCompleted': isCompleted,
      };

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    IconData icon = Icons.task_alt_rounded;
    final id = json['id'] as String;
    if (id == 'quest_log_first') icon = Icons.edit_note_rounded;
    if (id == 'quest_needs_only') icon = Icons.shield_rounded;
    if (id == 'quest_save_income') icon = Icons.savings_rounded;

    return DailyQuest(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int? ?? 0,
      xpReward: json['xpReward'] as int,
      goldReward: json['goldReward'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      icon: icon,
    );
  }
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int cost;
  final IconData icon;
  final Color color;
  bool isPurchased;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.icon,
    required this.color,
    this.isPurchased = false,
  });
}
