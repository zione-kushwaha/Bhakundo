import 'package:equatable/equatable.dart';
import 'player.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final String captainId;
  final String captainName;
  final String logoUrl;
  final List<Player> roster;
  final int wins;
  final int losses;
  final int draws;
  final int matchesPlayed;

  const Team({
    required this.id,
    required this.name,
    required this.captainId,
    required this.captainName,
    required this.logoUrl,
    required this.roster,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.matchesPlayed,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        captainId,
        captainName,
        logoUrl,
        roster,
        wins,
        losses,
        draws,
        matchesPlayed,
      ];
}
