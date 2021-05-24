import 'package:cloud_firestore/cloud_firestore.dart';

import 'config/config.dart';
import 'models/rank_score.dart';

abstract class EscapaUtility {
  static Future<RankScore> getPlayerRankAndGlobalBest(int personalBest) async {
    final QuerySnapshot qs = await FirebaseFirestore.instance
        .collection(Config.firestoreCollectionScore)
        .get();

    final List<int> scores = qs.docs
        .map<int>((QueryDocumentSnapshot qds) =>
            qds.get(Config.firestoreCollectionScoreKey) as int)
        .toList()
          ..sort();

    return RankScore(scores.length - scores.lastIndexOf(personalBest),
        scores.isNotEmpty ? scores.last : 0);
  }
}
