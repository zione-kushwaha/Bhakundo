import '../../domain/entities/team.dart';
import 'player_model.dart';

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
    required super.captainId,
    required super.captainName,
    required super.logoUrl,
    required super.roster,
    required super.wins,
    required super.losses,
    required super.draws,
    required super.matchesPlayed,
  });

  factory TeamModel.fromMap(String id, Map<String, dynamic> map) {
    final rosterList = map['roster'] as List<dynamic>? ?? [];
    final roster = rosterList.map((item) => PlayerModel.fromMap(Map<String, dynamic>.from(item))).toList();

    return TeamModel(
      id: id,
      name: map['name'] as String? ?? '',
      captainId: map['captainId'] as String? ?? '',
      captainName: map['captainName'] as String? ?? '',
      logoUrl: map['logoUrl'] as String? ?? '',
      roster: roster,
      wins: map['wins'] as int? ?? 0,
      losses: map['losses'] as int? ?? 0,
      draws: map['draws'] as int? ?? 0,
      matchesPlayed: map['matchesPlayed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'captainId': captainId,
      'captainName': captainName,
      'logoUrl': logoUrl,
      'roster': roster.map((player) => PlayerModel.fromEntity(player).toMap()).toList(),
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'matchesPlayed': matchesPlayed,
    };
  }

  factory TeamModel.fromEntity(Team entity) {
    return TeamModel(
      id: entity.id,
      name: entity.name,
      captainId: entity.captainId,
      captainName: entity.captainName,
      logoUrl: entity.logoUrl,
      roster: entity.roster,
      wins: entity.wins,
      losses: entity.losses,
      draws: entity.draws,
      matchesPlayed: entity.matchesPlayed,
    );
  }
}
