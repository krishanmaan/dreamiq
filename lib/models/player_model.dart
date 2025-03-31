class Player {
  final String id;
  final String name;
  final String teamName;
  final String role; // Batsman, Bowler, All-Rounder, Wicket-Keeper
  final String imageUrl;
  final double credits;
  final double selectionPercentage;
  final Map<String, dynamic> stats;
  final bool isInjured;
  final String? injuryInfo;
  final List<MatchPerformance> recentPerformances;

  Player({
    required this.id,
    required this.name,
    required this.teamName,
    required this.role,
    required this.imageUrl,
    required this.credits,
    required this.selectionPercentage,
    required this.stats,
    this.isInjured = false,
    this.injuryInfo,
    required this.recentPerformances,
  });

  // Factory constructor to create a Player from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      teamName: json['teamName'],
      role: json['role'],
      imageUrl: json['imageUrl'],
      credits: json['credits'].toDouble(),
      selectionPercentage: json['selectionPercentage'].toDouble(),
      stats: json['stats'],
      isInjured: json['isInjured'] ?? false,
      injuryInfo: json['injuryInfo'],
      recentPerformances: (json['recentPerformances'] as List)
          .map((performance) => MatchPerformance.fromJson(performance))
          .toList(),
    );
  }

  // Convert Player instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teamName': teamName,
      'role': role,
      'imageUrl': imageUrl,
      'credits': credits,
      'selectionPercentage': selectionPercentage,
      'stats': stats,
      'isInjured': isInjured,
      'injuryInfo': injuryInfo,
      'recentPerformances': recentPerformances.map((performance) => performance.toJson()).toList(),
    };
  }
}

class MatchPerformance {
  final String matchId;
  final String opponentTeam;
  final String venue;
  final DateTime date;
  final int runs;
  final int wickets;
  final int ballsFaced;
  final int ballsBowled;
  final double economyRate;
  final double strikeRate;
  final int dreamPoints;
  final String? matchResult; // Won, Lost, Draw, No Result

  MatchPerformance({
    required this.matchId,
    required this.opponentTeam,
    required this.venue,
    required this.date,
    required this.runs,
    required this.wickets,
    required this.ballsFaced,
    required this.ballsBowled,
    required this.economyRate,
    required this.strikeRate,
    required this.dreamPoints,
    this.matchResult,
  });

  // Factory constructor to create a MatchPerformance from JSON
  factory MatchPerformance.fromJson(Map<String, dynamic> json) {
    return MatchPerformance(
      matchId: json['matchId'],
      opponentTeam: json['opponentTeam'],
      venue: json['venue'],
      date: DateTime.parse(json['date']),
      runs: json['runs'],
      wickets: json['wickets'],
      ballsFaced: json['ballsFaced'],
      ballsBowled: json['ballsBowled'],
      economyRate: json['economyRate'].toDouble(),
      strikeRate: json['strikeRate'].toDouble(),
      dreamPoints: json['dreamPoints'],
      matchResult: json['matchResult'],
    );
  }

  // Convert MatchPerformance instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'opponentTeam': opponentTeam,
      'venue': venue,
      'date': date.toIso8601String(),
      'runs': runs,
      'wickets': wickets,
      'ballsFaced': ballsFaced,
      'ballsBowled': ballsBowled,
      'economyRate': economyRate,
      'strikeRate': strikeRate,
      'dreamPoints': dreamPoints,
      'matchResult': matchResult,
    };
  }
} 