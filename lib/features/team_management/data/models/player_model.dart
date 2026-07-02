import '../../domain/entities/player.dart';

class PlayerModel extends Player {
  const PlayerModel({
    required super.id,
    required super.name,
    required super.role,
    required super.avatarUrl,
    required super.matchesPlayed,
    required super.goals,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? 'Forward',
      avatarUrl: map['avatarUrl'] as String? ?? '',
      matchesPlayed: map['matchesPlayed'] as int? ?? 0,
      goals: map['goals'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'avatarUrl': avatarUrl,
      'matchesPlayed': matchesPlayed,
      'goals': goals,
    };
  }

  factory PlayerModel.fromEntity(Player entity) {
    return PlayerModel(
      id: entity.id,
      name: entity.name,
      role: entity.role,
      avatarUrl: entity.avatarUrl,
      matchesPlayed: entity.matchesPlayed,
      goals: entity.goals,
    );
  }
}
