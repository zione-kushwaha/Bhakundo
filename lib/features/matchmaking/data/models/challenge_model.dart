import '../../domain/entities/challenge.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({
    required super.id,
    required super.hostTeamId,
    required super.hostTeamName,
    required super.hostCaptainName,
    required super.venueName,
    required super.matchDate,
    required super.matchTime,
    required super.status,
    required super.opponentTeamId,
    required super.opponentTeamName,
    required super.createdAt,
  });

  factory ChallengeModel.fromMap(String id, Map<String, dynamic> map) {
    return ChallengeModel(
      id: id,
      hostTeamId: map['hostTeamId'] as String? ?? '',
      hostTeamName: map['hostTeamName'] as String? ?? '',
      hostCaptainName: map['hostCaptainName'] as String? ?? '',
      venueName: map['venueName'] as String? ?? '',
      matchDate: map['matchDate'] as String? ?? '',
      matchTime: map['matchTime'] as String? ?? '',
      status: map['status'] as String? ?? 'Waiting',
      opponentTeamId: map['opponentTeamId'] as String? ?? '',
      opponentTeamName: map['opponentTeamName'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostTeamId': hostTeamId,
      'hostTeamName': hostTeamName,
      'hostCaptainName': hostCaptainName,
      'venueName': venueName,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'status': status,
      'opponentTeamId': opponentTeamId,
      'opponentTeamName': opponentTeamName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChallengeModel.fromEntity(Challenge entity) {
    return ChallengeModel(
      id: entity.id,
      hostTeamId: entity.hostTeamId,
      hostTeamName: entity.hostTeamName,
      hostCaptainName: entity.hostCaptainName,
      venueName: entity.venueName,
      matchDate: entity.matchDate,
      matchTime: entity.matchTime,
      status: entity.status,
      opponentTeamId: entity.opponentTeamId,
      opponentTeamName: entity.opponentTeamName,
      createdAt: entity.createdAt,
    );
  }
}
