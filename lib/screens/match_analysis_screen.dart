import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../utils/theme.dart';

class MatchAnalysisScreen extends StatefulWidget {
  const MatchAnalysisScreen({super.key});

  @override
  State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
}

class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
  bool _isLoading = true;
  Match? _match;

  @override
  void initState() {
    super.initState();
    _loadMatchData();
  }

  void _loadMatchData() {
    // In a real app, this would fetch match data from an API
    // For now, we'll simulate a network request
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
        // In a real app, match data would come from route arguments
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Match Analysis')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Use mock data if no match is provided
    final match = _match ?? _createMockMatch();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(match),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMatchHeader(match),
                _buildPitchAnalysis(match),
                _buildTeamHeadToHead(match),
                _buildBestPlayersSection(match),
                _buildAISuggestions(match),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to team builder
          Navigator.pushNamed(context, '/team-builder', arguments: {'matchId': match.id});
        },
        backgroundColor: AppTheme.secondaryColor,
        icon: const Icon(Icons.create),
        label: const Text('Create Team'),
      ),
    );
  }

  Widget _buildAppBar(Match match) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${match.teamA.shortName} vs ${match.teamB.shortName}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://img1.hscicdn.com/image/upload/f_auto,t_ds_wide_w_1280,q_70/lsci/db/PICTURES/CMS/295800/295894.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppTheme.primaryColor);
              },
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/stadium_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.5 * 255),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Share match analysis
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Set notifications for match
          },
        ),
      ],
    );
  }

  Widget _buildMatchHeader(Match match) {
    final isUpcoming = match.isUpcoming;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.tournamentName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(match.status).withValues(alpha: 0.1 * 255),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  match.status,
                  style: TextStyle(
                    color: _getStatusColor(match.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            match.venue,
            style: const TextStyle(color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 4),
          Text(
            _formatMatchTime(match.matchTime),
            style: const TextStyle(color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTeamInfo(match.teamA),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: _buildTeamInfo(match.teamB, alignRight: true),
              ),
            ],
          ),
          if (isUpcoming) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9 * 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    isUpcoming ? 'Match starts in' : 'Match Info',
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUpcoming ? match.getTimeRemaining() : _getMatchResult(match),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamInfo(Team team, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!alignRight) _buildTeamLogo(team),
            if (!alignRight) const SizedBox(width: 8),
            Text(
              team.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: alignRight ? TextAlign.right : TextAlign.left,
            ),
            if (alignRight) const SizedBox(width: 8),
            if (alignRight) _buildTeamLogo(team),
          ],
        ),
        if (team.score != null) ...[
          const SizedBox(height: 4),
          Text(
            team.score!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTeamLogo(Team team) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          team.flagImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                team.shortName.substring(0, 1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPitchAnalysis(Match match) {
    // In a real app, this would come from the match.pitchReport
    final pitchReport = {
      'type': 'Batting friendly',
      'pace': 'Medium',
      'spin': 'Low',
      'weather': 'Clear',
      'humidity': '65%',
      'temperature': '28°C',
      'windSpeed': '5 km/h',
      'chanceOfRain': '10%',
    };
    
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.landscape, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Pitch & Ground Analysis',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPitchInfoItem('Pitch Type', pitchReport['type']!),
                      const SizedBox(height: 8),
                      _buildPitchInfoItem('Pace', pitchReport['pace']!),
                      const SizedBox(height: 8),
                      _buildPitchInfoItem('Spin', pitchReport['spin']!),
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWeatherInfoItem('Weather', pitchReport['weather']!),
                        const SizedBox(height: 8),
                        _buildWeatherInfoItem('Temperature', pitchReport['temperature']!),
                        const SizedBox(height: 8),
                        _buildWeatherInfoItem('Rain Chance', pitchReport['chanceOfRain']!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'DreamIQ Analysis',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a batting-friendly pitch with minimal help for spinners. Expect high scores and consider picking top-order batsmen and fast bowlers who can vary their pace.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPitchInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamHeadToHead(Match match) {
    // In a real app, this would come from match data or API
    final headToHeadStats = {
      'matches': 24,
      'teamAWins': 14,
      'teamBWins': 8,
      'noResults': 2,
      'teamAAvgScore': 176,
      'teamBAvgScore': 162,
      'venueStat': '${match.teamA.shortName} have won 3 out of 5 matches at this venue',
    };
    
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Head to Head Stats',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      headToHeadStats['teamAWins'].toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.teamA.shortName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        headToHeadStats['noResults'].toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'DRAW',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      headToHeadStats['teamBWins'].toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.teamB.shortName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Total Matches', headToHeadStats['matches'].toString()),
                _buildStatItem('${match.teamA.shortName} Avg', '${headToHeadStats['teamAAvgScore']}'),
                _buildStatItem('${match.teamB.shortName} Avg', '${headToHeadStats['teamBAvgScore']}'),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Venue Stats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              headToHeadStats['venueStat'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBestPlayersSection(Match match) {
    // In a real app, this would come from an algorithm
    final topBatsmen = [
      {'name': 'Virat Kohli', 'team': match.teamA.shortName, 'points': 9.5},
      {'name': 'Rohit Sharma', 'team': match.teamA.shortName, 'points': 9.0},
      {'name': 'Kane Williamson', 'team': match.teamB.shortName, 'points': 8.8},
    ];
    
    final topBowlers = [
      {'name': 'Jasprit Bumrah', 'team': match.teamA.shortName, 'points': 9.2},
      {'name': 'Trent Boult', 'team': match.teamB.shortName, 'points': 9.0},
      {'name': 'Rashid Khan', 'team': match.teamB.shortName, 'points': 8.7},
    ];
    
    final topAllRounders = [
      {'name': 'Hardik Pandya', 'team': match.teamA.shortName, 'points': 8.8},
      {'name': 'Mitchell Santner', 'team': match.teamB.shortName, 'points': 8.5},
    ];
    
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Best Players for This Match',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Top Batsmen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...topBatsmen.map((player) => _buildPlayerRating(
              player['name'] as String,
              player['team'] as String,
              player['points'] as double,
            )),
            const SizedBox(height: 16),
            const Text(
              'Top Bowlers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...topBowlers.map((player) => _buildPlayerRating(
              player['name'] as String,
              player['team'] as String,
              player['points'] as double,
            )),
            const SizedBox(height: 16),
            const Text(
              'Top All-Rounders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...topAllRounders.map((player) => _buildPlayerRating(
              player['name'] as String,
              player['team'] as String,
              player['points'] as double,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRating(String name, String team, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    team,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          _buildRatingStars(rating),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    return Row(
      children: [
        ...List.generate(
          fullStars,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
        ),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 16),
        ...List.generate(
          5 - fullStars - (hasHalfStar ? 1 : 0),
          (index) => const Icon(Icons.star_border, color: Colors.amber, size: 16),
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAISuggestions(Match match) {
    // In a real app, this would come from an AI model
    final suggestions = [
      'Prefer batsmen from ${match.teamA.shortName} as they have scored 20% more runs on this pitch',
      'Pick Mohammed Shami as he has taken 8 wickets in the last 2 matches at this venue',
      'Avoid spinners as the pitch offers minimal turn',
      'Rohit Sharma has scored 3 fifties in his last 4 matches against ${match.teamB.shortName}',
      'Consider choosing more players from ${match.teamA.shortName} as they have won 3 out of 5 matches at this venue',
    ];
    
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: AppTheme.infoColor),
                const SizedBox(width: 8),
                const Text(
                  'AI Suggested Picks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withValues(alpha: 0.1 * 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppTheme.infoColor,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'DreamIQ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: AppTheme.infoColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              suggestion,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'upcoming':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatMatchTime(DateTime dateTime) {
    final day = dateTime.day;
    final month = dateTime.month;
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : hour == 0 ? 12 : hour;
    final minuteString = minute.toString().padLeft(2, '0');
    
    return '$day ${monthNames[month-1]} $year, $hour12:$minuteString $period';
  }

  String _getMatchResult(Match match) {
    if (match.matchResult != null) {
      return match.matchResult!;
    }
    if (match.isLive) {
      return 'Live';
    }
    return 'TBD';
  }

  Match _createMockMatch() {
    // This is a mock match for demonstration
    return Match(
      id: 'm1',
      tournamentName: 'IPL 2023',
      venue: 'M. Chinnaswamy Stadium, Bangalore',
      matchTime: DateTime.now().add(const Duration(days: 2)),
      status: 'Upcoming',
      teamA: Team(
        id: 't1',
        name: 'Royal Challengers Bangalore',
        shortName: 'RCB',
        flagImageUrl: 'https://pbs.twimg.com/media/GJCsUKsWQAAjTBF?format=jpg&name=small',
        playerIds: ['p1', 'p2', 'p3', 'p4'],
      ),
      teamB: Team(
        id: 't2',
        name: 'Chennai Super Kings',
        shortName: 'CSK',
        flagImageUrl: 'https://static.wixstatic.com/media/0293d4_0be320985f284973a119aaada3d6933f~mv2.jpg/v1/fill/w_740,h_513,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/0293d4_0be320985f284973a119aaada3d6933f~mv2.jpg',
        playerIds: ['p5', 'p6', 'p7', 'p8'],
      ),
      pitchReport: {
        'type': 'Batting friendly',
        'bounce': 'Medium',
        'spin': 'Low',
      },
      weatherInfo: {
        'weather': 'Clear',
        'temperature': '28°C',
        'windSpeed': '5 km/h',
        'chanceOfRain': '10%',
      },
    );
  }
} 