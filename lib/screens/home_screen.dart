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
          // Live Score Card - 40% height, non-scrollable
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: LiveScoreCard(
              teamA: IPLTeams.rrTeam,
              teamB: IPLTeams.cskTeam,
              result: 'RR beat CHE by 6 runs',
            ),
          ),

          // Match Cards Section - 30% height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Kolkata NCC T20',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                      const Spacer(),
                      const Icon(Icons.notifications_none),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _upcomingMatches.length,
                    itemBuilder: (context, index) {
                      final match = _upcomingMatches[index];
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1 * 255),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _buildTeamInfo(match.teamA),
                                      const Text(
                                        ' v ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      _buildTeamInfo(match.teamB),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tomorrow, 9:00 AM',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.monetization_on,
                                          size: 16,
                                          color: Colors.amber[900],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '₹90 Lakhs +',
                                          style: TextStyle(
                                            color: Colors.amber[900],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(Team team) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(team.flagImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          team.shortName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
