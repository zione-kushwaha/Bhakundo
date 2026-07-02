import 'package:equatable/equatable.dart';

class Challenge extends Equatable {
  final String id;
  final String hostTeamId;
  final String hostTeamName;
  final String hostCaptainName;
  final String venueName;
  final String matchDate;
  final String matchTime;
  final String status; // "Waiting", "Matched"
  final String opponentTeamId;
  final String opponentTeamName;
  final DateTime createdAt;

  const Challenge({
    required this.id,
    required this.hostTeamId,
    required this.hostTeamName,
    required this.hostCaptainName,
    required this.venueName,
    required this.matchDate,
    required this.matchTime,
    required this.status,
    required this.opponentTeamId,
    required this.opponentTeamName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        hostTeamId,
        hostTeamName,
        hostCaptainName,
        venueName,
        matchDate,
        matchTime,
        status,
        opponentTeamId,
        opponentTeamName,
        createdAt,
      ];
}
