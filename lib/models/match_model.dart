import 'team_model.dart';

class Match {
  final String id;
  final String tournamentName;
  final String venue;
  final DateTime matchTime;
  final String status; // Upcoming, Live, Completed
  final Team teamA;
  final Team teamB;
  final String? tossResult;
  final Map<String, dynamic>? pitchReport;
  final Map<String, dynamic>? weatherInfo;
  final String? matchResult;
  final List<String>? keyHighlights;

  Match({
    required this.id,
    required this.tournamentName,
    required this.venue,
    required this.matchTime,
    required this.status,
    required this.teamA,
    required this.teamB,
    this.tossResult,
    this.pitchReport,
    this.weatherInfo,
    this.matchResult,
    this.keyHighlights,
  });

  // Factory constructor to create a Match from JSON
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      tournamentName: json['tournamentName'],
      venue: json['venue'],
      matchTime: DateTime.parse(json['matchTime']),
      status: json['status'],
      teamA: Team.fromJson(json['teamA']),
      teamB: Team.fromJson(json['teamB']),
      tossResult: json['tossResult'],
      pitchReport: json['pitchReport'],
      weatherInfo: json['weatherInfo'],
      matchResult: json['matchResult'],
      keyHighlights:
          json['keyHighlights'] != null
              ? List<String>.from(json['keyHighlights'])
              : null,
    );
  }

  // Convert Match instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentName': tournamentName,
      'venue': venue,
      'matchTime': matchTime.toIso8601String(),
      'status': status,
      'teamA': teamA.toJson(),
      'teamB': teamB.toJson(),
      'tossResult': tossResult,
      'pitchReport': pitchReport,
      'weatherInfo': weatherInfo,
      'matchResult': matchResult,
      'keyHighlights': keyHighlights,
    };
  }

  // Helper method to check if match is live
  bool get isLive => status == 'Live';

  // Helper method to check if match is completed
  bool get isCompleted => status == 'Completed';

  // Helper method to check if match is upcoming
  bool get isUpcoming => status == 'Upcoming';

  // Helper method to get time remaining for upcoming match
  String getTimeRemaining() {
    if (!isUpcoming) return '';

    final now = DateTime.now();
    final difference = matchTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m remaining';
    } else {
      return 'Starting soon';
    }
  }
}
