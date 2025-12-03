import 'package:flutter/material.dart';
import '../models/match_result.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;

  MockDataService._internal() {
    // Add some dummy data for demonstration
    _matches.addAll([
      MatchResult(
        id: '1',
        homeTeam: 'Manchester City',
        awayTeam: 'Liverpool',
        homeScore: 2,
        awayScore: 2,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isSRL: false,
      ),
      MatchResult(
        id: '2',
        homeTeam: 'Real Madrid (SRL)',
        awayTeam: 'Barcelona (SRL)',
        homeScore: 3,
        awayScore: 1,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isSRL: true,
      ),
    ]);
  }

  final List<MatchResult> _matches = [];

  List<MatchResult> get matches => List.unmodifiable(_matches);

  void addMatch(MatchResult match) {
    _matches.add(match);
    notifyListeners();
  }

  void deleteMatch(String id) {
    _matches.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  List<TeamStats> getStandings({bool? onlySRL}) {
    Map<String, TeamStats> stats = {};

    for (var match in _matches) {
      // Filter logic: if onlySRL is true, skip real games. If false, skip SRL. If null, include all.
      if (onlySRL != null && match.isSRL != onlySRL) continue;

      stats.putIfAbsent(match.homeTeam, () => TeamStats(match.homeTeam));
      stats.putIfAbsent(match.awayTeam, () => TeamStats(match.awayTeam));

      var home = stats[match.homeTeam]!;
      var away = stats[match.awayTeam]!;

      home.played++;
      away.played++;

      home.goalsFor += match.homeScore;
      home.goalsAgainst += match.awayScore;
      away.goalsFor += match.awayScore;
      away.goalsAgainst += match.homeScore;

      if (match.homeScore > match.awayScore) {
        home.won++;
        away.lost++;
      } else if (match.homeScore < match.awayScore) {
        away.won++;
        home.lost++;
      } else {
        home.drawn++;
        away.drawn++;
      }
    }

    var sortedStats = stats.values.toList();
    sortedStats.sort((a, b) {
      if (b.points != a.points) return b.points.compareTo(a.points);
      if (b.goalDifference != a.goalDifference) return b.goalDifference.compareTo(a.goalDifference);
      return b.goalsFor.compareTo(a.goalsFor);
    });

    return sortedStats;
  }
}
