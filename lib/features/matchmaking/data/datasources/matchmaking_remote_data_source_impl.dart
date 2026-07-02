import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge_model.dart';
import 'matchmaking_remote_data_source.dart';

class MatchmakingRemoteDataSourceImpl implements MatchmakingRemoteDataSource {
  final FirebaseFirestore _firestore;

  MatchmakingRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final List<Map<String, dynamic>> _mockChallenges = [
    {
      'hostTeamId': 'team-gorkha-1',
      'hostTeamName': 'Gorkha United FC',
      'hostCaptainName': 'Ramesh Thapa',
      'venueName': 'Camp Nou Futsal Arena',
      'matchDate': '2026-07-04',
      'matchTime': '07:00 PM - 08:00 PM',
      'status': 'Waiting',
      'opponentTeamId': '',
      'opponentTeamName': '',
      'createdAt': '2026-07-02T10:00:00.000Z',
    },
    {
      'hostTeamId': 'team-himalayan-2',
      'hostTeamName': 'Himalayan Sherpas',
      'hostCaptainName': 'Susan Gurung',
      'venueName': 'Old Trafford Turf',
      'matchDate': '2026-07-05',
      'matchTime': '06:00 PM - 07:00 PM',
      'status': 'Waiting',
      'opponentTeamId': '',
      'opponentTeamName': '',
      'createdAt': '2026-07-02T12:00:00.000Z',
    },
    {
      'hostTeamId': 'team-boys-3',
      'hostTeamName': 'Lalupate Boys',
      'hostCaptainName': 'Niraj Shrestha',
      'venueName': 'Bernabeu Futsal Hub',
      'matchDate': '2026-07-03',
      'matchTime': '08:00 PM - 09:00 PM',
      'status': 'Matched',
      'opponentTeamId': 'team-giants-4',
      'opponentTeamName': 'White Giants',
      'createdAt': '2026-07-01T15:00:00.000Z',
    }
  ];

  @override
  Future<List<ChallengeModel>> getOpenChallenges() async {
    try {
      final snapshot = await _firestore
          .collection('matchmaking')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        // Seed Firestore
        for (var mock in _mockChallenges) {
          await _firestore.collection('matchmaking').add(mock);
        }
        // Fetch again
        final seededSnapshot = await _firestore
            .collection('matchmaking')
            .orderBy('createdAt', descending: true)
            .get();

        return seededSnapshot.docs
            .map((doc) => ChallengeModel.fromMap(doc.id, doc.data()))
            .toList();
      }

      return snapshot.docs
          .map((doc) => ChallengeModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      // Local fallback in case Firebase is offline
      return _mockChallenges.asMap().entries.map((entry) {
        return ChallengeModel.fromMap('local-match-${entry.key}', entry.value);
      }).toList();
    }
  }

  @override
  Future<void> hostChallenge(ChallengeModel challenge) async {
    try {
      await _firestore.collection('matchmaking').doc(challenge.id).set(challenge.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptChallenge(
    String challengeId,
    String opponentTeamId,
    String opponentTeamName,
  ) async {
    try {
      await _firestore.collection('matchmaking').doc(challengeId).update({
        'status': 'Matched',
        'opponentTeamId': opponentTeamId,
        'opponentTeamName': opponentTeamName,
      });
    } catch (e) {
      rethrow;
    }
  }
}
