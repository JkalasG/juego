import 'package:flutter/material.dart';

enum PlantStage {
  seed,     // Semilla en maceta 🌱
  sprout,   // Primer brote verde 🌿
  growing,  // Planta en desarrollo 🪴
  mature,   // Planta frondosa 🎋
  blooming; // Floración dorada con frutos 🌸✨

  String get stageName {
    switch (this) {
      case PlantStage.seed:
        return 'Semilla Plantada';
      case PlantStage.sprout:
        return 'Brote Verde';
      case PlantStage.growing:
        return 'En Crecimiento';
      case PlantStage.mature:
        return 'Planta Frondosa';
      case PlantStage.blooming:
        return 'Floración & Frutos';
    }
  }

  String get emoji {
    switch (this) {
      case PlantStage.seed:
        return '🌱';
      case PlantStage.sprout:
        return '🌿';
      case PlantStage.growing:
        return '🪴';
      case PlantStage.mature:
        return '🎋';
      case PlantStage.blooming:
        return '🌸';
    }
  }
}

class GardenPlant {
  final String id;
  final String name;
  final String species;
  final String lore;
  PlantStage stage;
  int currentWater;
  final int waterPerStage;
  int sunlightScore;
  final Color themeColor;
  final DateTime plantedDate;

  GardenPlant({
    required this.id,
    required this.name,
    required this.species,
    required this.lore,
    this.stage = PlantStage.sprout,
    this.currentWater = 20,
    this.waterPerStage = 50,
    this.sunlightScore = 30,
    required this.themeColor,
    DateTime? plantedDate,
  }) : plantedDate = plantedDate ?? DateTime.now();

  double get stageProgress => (currentWater / waterPerStage).clamp(0.0, 1.0);

  bool get canEvolve => currentWater >= waterPerStage && stage != PlantStage.blooming;

  void waterPlant(int drops) {
    currentWater += drops;
    if (currentWater >= waterPerStage && stage.index < PlantStage.values.length - 1) {
      currentWater -= waterPerStage;
      stage = PlantStage.values[stage.index + 1];
    }
  }

  void addSunlight(int light) {
    sunlightScore += light;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'lore': lore,
        'stage': stage.name,
        'currentWater': currentWater,
        'waterPerStage': waterPerStage,
        'sunlightScore': sunlightScore,
        'plantedDate': plantedDate.toIso8601String(),
      };

  factory GardenPlant.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    Color color = const Color(0xFF2ED59A);
    if (id == 'plant_sunflower') color = const Color(0xFFF6A843);
    if (id == 'plant_bamboo') color = const Color(0xFF10B981);
    if (id == 'plant_bonsai') color = const Color(0xFF0C5844);

    return GardenPlant(
      id: id,
      name: json['name'] as String,
      species: json['species'] as String,
      lore: json['lore'] as String,
      stage: PlantStage.values.firstWhere(
        (s) => s.name == json['stage'],
        orElse: () => PlantStage.sprout,
      ),
      currentWater: json['currentWater'] as int? ?? 0,
      waterPerStage: json['waterPerStage'] as int? ?? 50,
      sunlightScore: json['sunlightScore'] as int? ?? 0,
      themeColor: color,
      plantedDate: json['plantedDate'] != null
          ? DateTime.parse(json['plantedDate'] as String)
          : DateTime.now(),
    );
  }
}

class GardenMascot {
  final String name = 'Shiba Guardián';
  final String title = 'Guía Botánico Financiero';
  final String quote = '¡Cuida tus finanzas como a tu jardín: un riego diario florece en abundancia!';
}
