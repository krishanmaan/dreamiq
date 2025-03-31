import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/team_model.dart';
import '../utils/theme.dart';
import '../data/ipl_teams.dart';
import '../widgets/live_score_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Match> _upcomingMatches = [];
  final List<String> _tournaments = [
    'Indian T20 League',
    'ECS T10',
    'Kolkata NCC T20',
  ];
  String _selectedTournament = 'Indian T20 League';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Load IPL matches
    _upcomingMatches.addAll([
      Match(
        id: 'm1',
        tournamentName: 'Indian T20 League',
        venue: 'MA Chidambaram Stadium, Chennai',
        matchTime: DateTime(2024, 4, 2, 19, 30),
        status: 'Upcoming',
        teamA: IPLTeams.cskTeam,
        teamB: IPLTeams.rcbTeam,
        pitchReport: {
          'condition': 'Dry',
          'behavior': 'Expected to assist spinners',
        },
        weatherInfo: {
          'temperature': '32°C',
          'humidity': '75%',
          'windSpeed': '12 km/h',
        },
      ),
      Match(
        id: 'm2',
        tournamentName: 'Indian T20 League',
        venue: 'Eden Gardens, Kolkata',
        matchTime: DateTime(2024, 4, 3, 19, 30),
        status: 'Upcoming',
        teamA: IPLTeams.kkrTeam,
        teamB: IPLTeams.srhTeam,
        pitchReport: {
          'condition': 'Good batting surface',
          'behavior': 'Even bounce expected',
        },
        weatherInfo: {
          'temperature': '30°C',
          'humidity': '70%',
          'windSpeed': '8 km/h',
        },
      ),
      Match(
        id: 'm3',
        tournamentName: 'Indian T20 League',
        venue: 'Rajiv Gandhi International Stadium, Hyderabad',
        matchTime: DateTime(2024, 4, 4, 19, 30),
        status: 'Upcoming',
        teamA: IPLTeams.srhTeam,
        teamB: IPLTeams.miTeam,
        pitchReport: {
          'condition': 'Fresh pitch',
          'behavior': 'Good for batting',
        },
        weatherInfo: {
          'temperature': '35°C',
          'humidity': '65%',
          'windSpeed': '10 km/h',
        },
      ),
      Match(
        id: 'm4',
        tournamentName: 'Indian T20 League',
        venue: 'Wankhede Stadium, Mumbai',
        matchTime: DateTime(2024, 4, 5, 19, 30),
        status: 'Upcoming',
        teamA: IPLTeams.miTeam,
        teamB: IPLTeams.rrTeam,
        pitchReport: {
          'condition': 'Hard surface',
          'behavior': 'Good pace and bounce',
        },
        weatherInfo: {
          'temperature': '33°C',
          'humidity': '80%',
          'windSpeed': '15 km/h',
        },
      ),
      Match(
        id: 'm5',
        tournamentName: 'Indian T20 League',
        venue: 'M.Chinnaswamy Stadium, Bangalore',
        matchTime: DateTime(2024, 4, 6, 19, 30),
        status: 'Upcoming',
        teamA: IPLTeams.rcbTeam,
        teamB: IPLTeams.lsgTeam,
        pitchReport: {
          'condition': 'Batting friendly',
          'behavior': 'High scoring expected',
        },
        weatherInfo: {
          'temperature': '28°C',
          'humidity': '60%',
          'windSpeed': '12 km/h',
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/player_placeholder.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'DREAMIQ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chat_outlined),
                onPressed: () {
                  // Handle messages
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          LiveScoreCard(
            teamA: IPLTeams.rrTeam,
            teamB: IPLTeams.cskTeam,
            result: 'RR beat CHE by 6 runs',
          ),
          _buildTournamentFilters(),
          Expanded(child: _buildMatchList()),
        ],
      ),
    );
  }

  Widget _buildTournamentFilters() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _tournaments.length,
        itemBuilder: (context, index) {
          final tournament = _tournaments[index];
          final isSelected = tournament == _selectedTournament;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTournament = tournament;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppTheme.primaryColor.withValues(alpha: 0.1 * 255)
                        : null,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Text(
                  tournament,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        isSelected ? AppTheme.primaryColor : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchList() {
    if (_upcomingMatches.isEmpty) {
      return const Center(child: Text('No matches available'));
    }

    final filteredMatches =
        _upcomingMatches
            .where((match) => match.tournamentName == _selectedTournament)
            .toList();

    if (filteredMatches.isEmpty) {
      return Center(
        child: Text(
          'No matches available for $_selectedTournament',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredMatches.length,
      itemBuilder: (context, index) {
        final match = filteredMatches[index];

        // If it's a new tournament type, show the header
        if (index == 0 ||
            match.tournamentName != filteredMatches[index - 1].tournamentName) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 16),
              _buildTournamentHeader(match.tournamentName),
              const SizedBox(height: 8),
              _buildMatchCard(match),
            ],
          );
        }

        return _buildMatchCard(match);
      },
    );
  }

  Widget _buildTournamentHeader(String tournamentName) {
    return Row(
      children: [
        Text(
          _getTournamentShortName(tournamentName),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          _getTournamentFullName(tournamentName),
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
        const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ],
    );
  }

  String _getTournamentShortName(String name) {
    if (name == 'Indian T20 League') {
      return 'T20';
    } else if (name == 'ECS T10') {
      return 'T10';
    } else if (name == 'Kolkata NCC T20') {
      return 'T20';
    } else {
      return 'T20';
    }
  }

  String _getTournamentFullName(String name) {
    if (name == 'Kolkata NCC T20') {
      return '• Kolkata NCC T20';
    } else if (name == 'ECS T10') {
      return '• ECS T10';
    } else {
      return '';
    }
  }

  Widget _buildMatchCard(Match match) {
    final bool isFirstMatch =
        match.tournamentName == 'Indian T20 League' &&
        match.teamA.shortName == 'MI';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                _buildTeamInfo(match.teamA),
                Expanded(child: _buildMatchCenterInfo(match, isFirstMatch)),
                _buildTeamInfo(match.teamB),
              ],
            ),
            if (isFirstMatch) ...[
              const Divider(),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.amber[700],
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child:
                        isFirstMatch
                            ? Row(
                              children: [
                                Text(
                                  '₹62 Lakhs +',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                            : Container(),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo(Team team) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
                  team.flagImageUrl.isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(team.flagImageUrl),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: team.flagImageUrl.isEmpty ? Colors.grey[200] : null,
            ),
            child:
                team.flagImageUrl.isEmpty
                    ? Center(
                      child: Text(
                        team.shortName.substring(0, 1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                    : null,
          ),
          const SizedBox(height: 8),
          Text(
            team.shortName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCenterInfo(Match match, bool isSpecialMatch) {
    final DateTime matchTime = match.matchTime;
    final Duration timeLeft = matchTime.difference(DateTime.now());

    String timeDisplay;
    if (timeLeft.inDays > 0) {
      timeDisplay = '${timeLeft.inDays}d : ${timeLeft.inHours % 24}h';
    } else if (timeLeft.inHours > 0) {
      timeDisplay = '${timeLeft.inHours}h : ${timeLeft.inMinutes % 60}m';
    } else {
      timeDisplay = '${timeLeft.inMinutes}m';
    }

    return Column(
      children: [
        if (isSpecialMatch) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'MEGA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '75',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Text(
            'CRORES +',
            style: TextStyle(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ] else ...[
          if (match.tournamentName == 'Kolkata NCC T20') ...[
            Text(
              '2h : ${timeLeft.inMinutes % 60}m',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Text(
              '1:00 PM',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ] else if (match.tournamentName == 'ECS T10' &&
              match.teamA.shortName == 'OEI') ...[
            Text(
              '3h : ${timeLeft.inMinutes % 60}m',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Text(
              '2:30 PM',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ] else if (match.tournamentName == 'ECS T10' &&
              match.teamA.shortName == 'GOR') ...[
            Text(
              '5h : ${timeLeft.inMinutes % 60}m',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Text(
              '4:30 PM',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ] else if (match.teamA.shortName == 'LSG') ...[
            const Text(
              'Tomorrow, 7:30 PM',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ] else ...[
            Text(
              timeDisplay,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
