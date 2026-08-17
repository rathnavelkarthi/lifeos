import 'package:flutter/material.dart';

// ─── Stat Model ───────────────────────────────────────────────────────────────
class StatModel {
  final String name;
  final String icon;
  final Color color;
  int xp;
  DateTime? lastActivity;

  StatModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.xp,
    this.lastActivity,
  });

  int get level => (xp / 300).floor();
  double get levelProgress => (xp % 300) / 300;
  bool get isDecaying =>
      lastActivity != null &&
      DateTime.now().difference(lastActivity!).inHours >= 72;

  factory StatModel.fromMap(Map<String, dynamic> map) {
    return StatModel(
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as Color,
      xp: map['xp'] as int,
      lastActivity: map['lastActivity'] != null
          ? DateTime.parse(map['lastActivity'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'icon': icon,
    'xp': xp,
    'lastActivity': lastActivity?.toIso8601String(),
  };
}

// ─── Mission Model ─────────────────────────────────────────────────────────────
enum MissionStatus { pending, inProgress, claimed }

class MissionModel {
  final String id;
  final String title;
  final String statName;
  final int xpReward;
  final int goldReward;
  final int durationMinutes;
  final String iconEmoji;
  MissionStatus status;
  final bool isRecovery;

  MissionModel({
    required this.id,
    required this.title,
    required this.statName,
    required this.xpReward,
    required this.goldReward,
    required this.durationMinutes,
    required this.iconEmoji,
    this.status = MissionStatus.pending,
    this.isRecovery = false,
  });

  static MissionStatus _statusFromString(String v) {
    switch (v) {
      case 'inProgress':
        return MissionStatus.inProgress;
      case 'claimed':
        return MissionStatus.claimed;
      default:
        return MissionStatus.pending;
    }
  }

  factory MissionModel.fromMap(Map<String, dynamic> map) {
    return MissionModel(
      id: map['id'] as String,
      title: map['title'] as String,
      statName: map['statName'] as String,
      xpReward: map['xpReward'] as int,
      goldReward: map['goldReward'] as int,
      durationMinutes: map['durationMinutes'] as int,
      iconEmoji: map['iconEmoji'] as String,
      status: _statusFromString(map['status'] as String? ?? 'pending'),
      isRecovery: map['isRecovery'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'statName': statName,
    'xpReward': xpReward,
    'goldReward': goldReward,
    'durationMinutes': durationMinutes,
    'iconEmoji': iconEmoji,
    'status': status.name,
    'isRecovery': isRecovery,
  };
}

// ─── Habit Model ───────────────────────────────────────────────────────────────
class HabitModel {
  final String id;
  final String title;
  final String iconEmoji;
  final String statName;
  final int xpReward;
  int streakDays;
  bool completedToday;

  HabitModel({
    required this.id,
    required this.title,
    required this.iconEmoji,
    required this.statName,
    required this.xpReward,
    required this.streakDays,
    required this.completedToday,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      iconEmoji: map['iconEmoji'] as String,
      statName: map['statName'] as String,
      xpReward: map['xpReward'] as int,
      streakDays: map['streakDays'] as int,
      completedToday: map['completedToday'] as bool,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'iconEmoji': iconEmoji,
    'statName': statName,
    'xpReward': xpReward,
    'streakDays': streakDays,
    'completedToday': completedToday,
  };
}

// ─── Timeline Entry ────────────────────────────────────────────────────────────
enum TimelineType { mission, habit, levelUp, achievement, claim }

class TimelineEntry {
  final String id;
  final String title;
  final String subtitle;
  final int xpGained;
  final TimelineType type;
  final DateTime timestamp;

  TimelineEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.xpGained,
    required this.type,
    required this.timestamp,
  });

  static TimelineType _typeFromString(String v) {
    switch (v) {
      case 'habit':
        return TimelineType.habit;
      case 'levelUp':
        return TimelineType.levelUp;
      case 'achievement':
        return TimelineType.achievement;
      case 'claim':
        return TimelineType.claim;
      default:
        return TimelineType.mission;
    }
  }

  factory TimelineEntry.fromMap(Map<String, dynamic> map) {
    return TimelineEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      xpGained: map['xpGained'] as int,
      type: _typeFromString(map['type'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}

// ─── Player Model ──────────────────────────────────────────────────────────────
class PlayerModel {
  String name;
  String playerClass;
  int totalXp;
  int gold;
  int streakDays;
  String avatarUrl;

  PlayerModel({
    required this.name,
    required this.playerClass,
    required this.totalXp,
    required this.gold,
    required this.streakDays,
    required this.avatarUrl,
  });

  int get level {
    int lvl = 1;
    int xpLeft = totalXp;
    while (xpLeft >= lvl * 350) {
      xpLeft -= lvl * 350;
      lvl++;
    }
    return lvl;
  }

  int get xpForCurrentLevel {
    int xpLeft = totalXp;
    int lvl = 1;
    while (xpLeft >= lvl * 350) {
      xpLeft -= lvl * 350;
      lvl++;
    }
    return xpLeft;
  }

  int get xpNeededForNextLevel => level * 350;

  double get levelProgress => xpForCurrentLevel / xpNeededForNextLevel;
}
