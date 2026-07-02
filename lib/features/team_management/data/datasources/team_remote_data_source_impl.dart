import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';
import '../models/player_model.dart';
import 'team_remote_data_source.dart';

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final FirebaseFirestore _firestore;

  TeamRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Premium Nepalese Futsal Team seed details
  final Map<String, dynamic> _mockTeamTemplate = {
    'name': 'Bhakundo Athletic Club',
    'captainName': 'Kapil Bhakundo',
    'logoUrl': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=150',
    'wins': 14,
    'losses': 4,
    'draws': 2,
    'matchesPlayed': 20,
    'roster': [
      {
        'id': 'p-1',
        'name': 'Kiran Chemjong',
        'role': 'Goalkeeper',
        'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=100',
        'matchesPlayed': 20,
        'goals': 0,
      },
      {
        'id': 'p-2',
        'name': 'Rohit Chand',
        'role': 'Defender',
        'avatarUrl': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=100',
        'matchesPlayed': 18,
        'goals': 2,
      },
      {
        'id': 'p-3',
        'name': 'Bimal Gharti Magar',
        'role': 'Forward',
        'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100',
        'matchesPlayed': 20,
        'goals': 15,
      },
      {
        'id': 'p-4',
        'name': 'Anjan Bista',
        'role': 'Midfielder',
        'avatarUrl': 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=100',
        'matchesPlayed': 15,
        'goals': 8,
      }
    ]
  };

  @override
  Future<TeamModel?> getMyTeam(String captainId) async {
    try {
      final querySnapshot = await _firestore
          .collection('teams')
          .where('captainId', isEqualTo: captainId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Build and seed default team for this user
        final docRef = _firestore.collection('teams').doc('team-$captainId');
        
        final Map<String, dynamic> newTeamData = Map.from(_mockTeamTemplate);
        newTeamData['captainId'] = captainId;

        await docRef.set(newTeamData);
        
        return TeamModel.fromMap(docRef.id, newTeamData);
      }

      final doc = querySnapshot.docs.first;
      return TeamModel.fromMap(doc.id, doc.data());
    } catch (e) {
      // Local fallback for offline testing
      final Map<String, dynamic> fallbackData = Map.from(_mockTeamTemplate);
      fallbackData['captainId'] = captainId;
      return TeamModel.fromMap('offline-team-id', fallbackData);
    }
  }

  @override
  Future<void> createTeam(TeamModel team) async {
    try {
      await _firestore.collection('teams').doc(team.id).set(team.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addPlayerToTeam(String teamId, PlayerModel player) async {
    try {
      final docRef = _firestore.collection('teams').doc(teamId);
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data()!;
        final rosterList = List<dynamic>.from(data['roster'] ?? []);
        rosterList.add(player.toMap());
        await docRef.update({'roster': rosterList});
      }
    } catch (e) {
      rethrow;
    }
  }
}
