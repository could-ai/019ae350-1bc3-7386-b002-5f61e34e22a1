class MatchResult {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final DateTime date;
  final bool isSRL; // True for Simulated Reality League, False for Real Football

  MatchResult({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.date,
    required this.isSRL,
  });
}

class TeamStats {
  final String teamName;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;

  TeamStats(this.teamName);

  int get goalDifference => goalsFor - goalsAgainst;
  int get points => (won * 3) + (drawn * 1);
}
