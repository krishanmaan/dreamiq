class FantasyTeam {
  final String id;
  final String name;
  final String userId;
  final String matchId;
  final List<String> playerIds;
  final String? captainId;
  final String? viceCaptainId;
  final double totalCredits;
  final Map<String, int> roleCount; // {'WK': 1, 'BAT': 4, 'AR': 3, 'BOWL': 3}
  final int totalPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  FantasyTeam({
    required this.id,
    required this.name,
    required this.userId,
    required this.matchId,
    required this.playerIds,
    this.captainId,
    this.viceCaptainId,
    required this.totalCredits,
    required this.roleCount,
    this.totalPoints = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a FantasyTeam from JSON
  factory FantasyTeam.fromJson(Map<String, dynamic> json) {
    return FantasyTeam(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      matchId: json['matchId'],
      playerIds: List<String>.from(json['playerIds']),
      captainId: json['captainId'],
      viceCaptainId: json['viceCaptainId'],
      totalCredits: json['totalCredits'].toDouble(),
      roleCount: Map<String, int>.from(json['roleCount']),
      totalPoints: json['totalPoints'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert FantasyTeam instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'matchId': matchId,
      'playerIds': playerIds,
      'captainId': captainId,
      'viceCaptainId': viceCaptainId,
      'totalCredits': totalCredits,
      'roleCount': roleCount,
      'totalPoints': totalPoints,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Check if team is valid according to Dream11 rules
  bool isValid() {
    // Check if team has exactly 11 players
    if (playerIds.length != 11) {
      return false;
    }

    // Check if captain and vice-captain are selected
    if (captainId == null || viceCaptainId == null) {
      return false;
    }

    // Check if selected players include captain and vice-captain
    if (!playerIds.contains(captainId) || !playerIds.contains(viceCaptainId)) {
      return false;
    }

    // Check if captain and vice-captain are different players
    if (captainId == viceCaptainId) {
      return false;
    }

    // Check role constraints
    if (!_checkRoleConstraints()) {
      return false;
    }

    // Check if total credits are within the limit (100 credits)
    if (totalCredits > 100) {
      return false;
    }

    return true;
  }

  // Check if the team follows role constraints
  bool _checkRoleConstraints() {
    // Dream11 cricket constraints example:
    // 1-4 Wicket-keepers
    // 3-6 Batsmen
    // 1-4 All-rounders
    // 3-6 Bowlers

    final wk = roleCount['WK'] ?? 0;
    final bat = roleCount['BAT'] ?? 0;
    final ar = roleCount['AR'] ?? 0;
    final bowl = roleCount['BOWL'] ?? 0;

    if (wk < 1 || wk > 4) return false;
    if (bat < 3 || bat > 6) return false;
    if (ar < 1 || ar > 4) return false;
    if (bowl < 3 || bowl > 6) return false;

    // Make sure total is 11
    return (wk + bat + ar + bowl) == 11;
  }

  // Create a copy of the team with modifications
  FantasyTeam copyWith({
    String? name,
    List<String>? playerIds,
    String? captainId,
    String? viceCaptainId,
    double? totalCredits,
    Map<String, int>? roleCount,
    int? totalPoints,
  }) {
    return FantasyTeam(
      id: id,
      name: name ?? this.name,
      userId: userId,
      matchId: matchId,
      playerIds: playerIds ?? this.playerIds,
      captainId: captainId ?? this.captainId,
      viceCaptainId: viceCaptainId ?? this.viceCaptainId,
      totalCredits: totalCredits ?? this.totalCredits,
      roleCount: roleCount ?? this.roleCount,
      totalPoints: totalPoints ?? this.totalPoints,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class Team {
  final String id;
  final String name;
  final String shortName;
  final String flagImageUrl;
  final List<String> playerIds;
  final Map<String, dynamic>? stats;
  final String? score; // Used for live or completed matches

  Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.flagImageUrl,
    required this.playerIds,
    this.stats,
    this.score,
  });

  // Factory constructor to create a Team from JSON
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      shortName: json['shortName'],
      flagImageUrl: json['flagImageUrl'],
      playerIds: List<String>.from(json['playerIds']),
      stats: json['stats'],
      score: json['score'],
    );
  }

  // Convert Team instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'flagImageUrl': flagImageUrl,
      'playerIds': playerIds,
      'stats': stats,
      'score': score,
    };
  }

  // Create a copy of the team with optional new values
  Team copyWith({
    String? id,
    String? name,
    String? shortName,
    String? flagImageUrl,
    List<String>? playerIds,
    Map<String, dynamic>? stats,
    String? score,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      flagImageUrl: flagImageUrl ?? this.flagImageUrl,
      playerIds: playerIds ?? this.playerIds,
      stats: stats ?? this.stats,
      score: score ?? this.score,
    );
  }
}
