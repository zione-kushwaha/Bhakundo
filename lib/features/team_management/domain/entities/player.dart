import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final String role; // "Forward", "Midfielder", "Defender", "Goalkeeper"
  final String avatarUrl;
  final int matchesPlayed;
  final int goals;

  const Player({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.matchesPlayed,
    required this.goals,
  });

  @override
  List<Object?> get props => [id, name, role, avatarUrl, matchesPlayed, goals];
}
