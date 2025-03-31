import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/player_model.dart';
import '../utils/theme.dart';
import '../widgets/live_match_card.dart';
import '../widgets/upcoming_match_card.dart';
import '../widgets/trending_player_card.dart';
import '../widgets/top_player_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedSport = 'Cricket';
  final List<String> _sports = ['Cricket', 'Football', 'Kabaddi', 'Basketball'];
  final List<String> _tournaments = [
    'Indian T20 League',
    'ECS T10 Santarem',
    'Bago T10',
  ];

  // Mock data for demonstration
  final List<Match> _upcomingMatches = [];
  final List<Match> _liveMatches = [];
  final List<Player> _trendingPlayers = [];
  final List<Player> _topPlayers = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // In a real app, this would be fetched from an API
    // For now, we're using mock data

    // Create mock teams
    final miTeam = Team(
      id: 't1',
      name: 'Mumbai Indians',
      shortName: 'MI',
      flagImageUrl:
          'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/MI/Logos/Roundbig/MIroundbig.png',
      playerIds: ['p1', 'p2', 'p3', 'p4', 'p5'],
    );

    final kkrTeam = Team(
      id: 't2',
      name: 'Kolkata Knight Riders',
      shortName: 'KKR',
      flagImageUrl:
          'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/KKR/Logos/Roundbig/KKRroundbig.png',
      playerIds: ['p6', 'p7', 'p8', 'p9', 'p10'],
    );

    final lsgTeam = Team(
      id: 't3',
      name: 'Lucknow Super Giants',
      shortName: 'LSG',
      flagImageUrl:
          'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/LSG/Logos/Roundbig/LSGroundbig.png',
      playerIds: ['p11', 'p12', 'p13', 'p14', 'p15'],
    );

    final pbksTeam = Team(
      id: 't4',
      name: 'Punjab Kings',
      shortName: 'PBKS',
      flagImageUrl:
          'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/PBKS/Logos/Roundbig/PBKSroundbig.png',
      playerIds: ['p16', 'p17', 'p18', 'p19', 'p20'],
    );

    // ECS T10 Teams
    final oeirasTeam = Team(
      id: 't5',
      name: 'Oeiras',
      shortName: 'OEI',
      flagImageUrl: '',
      playerIds: [],
    );

    final gamblersTeam = Team(
      id: 't6',
      name: 'Gamblers SC',
      shortName: 'GAM',
      flagImageUrl: '',
      playerIds: [],
    );

    final gorkhaTeam = Team(
      id: 't7',
      name: 'Gorkha 11',
      shortName: 'GOR',
      flagImageUrl: '',
      playerIds: [],
    );

    final lisbonTeam = Team(
      id: 't8',
      name: 'Lisbon Capitals',
      shortName: 'LCA',
      flagImageUrl: '',
      playerIds: [],
    );

    // Kolkata NCC T20 Teams
    final alipurduarTeam = Team(
      id: 't9',
      name: 'Alipurduar Thunders',
      shortName: 'AT',
      flagImageUrl: '',
      playerIds: [],
    );

    final darjeelingTeam = Team(
      id: 't10',
      name: 'Darjeeling Unstoppables',
      shortName: 'DU',
      flagImageUrl: '',
      playerIds: [],
    );

    // Create upcoming matches
    final upcomingMatches = [
      // MI vs KKR Match
      Match(
        id: 'm1',
        tournamentName: 'Indian T20 League',
        venue: 'Wankhede Stadium, Mumbai',
        matchTime: DateTime.now().add(const Duration(hours: 8, minutes: 32)),
        status: 'Upcoming',
        teamA: miTeam,
        teamB: kkrTeam,
        pitchReport: {
          'condition': 'Batting friendly',
          'expected_behavior': 'Good for batting',
        },
        weatherInfo: {'temperature': '32°C', 'weather': 'Sunny'},
      ),
      // LSG vs PBKS Match
      Match(
        id: 'm2',
        tournamentName: 'Indian T20 League',
        venue: 'Ekana Stadium, Lucknow',
        matchTime: DateTime.now().add(
          const Duration(days: 1, hours: 7, minutes: 30),
        ),
        status: 'Upcoming',
        teamA: lsgTeam,
        teamB: pbksTeam,
        pitchReport: {
          'condition': 'Balanced',
          'expected_behavior': 'Good for both batting and bowling',
        },
        weatherInfo: {'temperature': '30°C', 'weather': 'Clear'},
      ),
      // Kolkata NCC T20 Match
      Match(
        id: 'm3',
        tournamentName: 'Kolkata NCC T20',
        venue: 'Kolkata',
        matchTime: DateTime.now().add(const Duration(hours: 2, minutes: 2)),
        status: 'Upcoming',
        teamA: alipurduarTeam,
        teamB: darjeelingTeam,
        pitchReport: {
          'condition': 'Dry',
          'expected_behavior': 'Will assist spinners',
        },
        weatherInfo: {'temperature': '30°C', 'weather': 'Humid'},
      ),
      // ECS T10 Match 1
      Match(
        id: 'm4',
        tournamentName: 'ECS T10 Santarem Premier',
        venue: 'Santarem',
        matchTime: DateTime.now().add(const Duration(hours: 3, minutes: 31)),
        status: 'Upcoming',
        teamA: oeirasTeam,
        teamB: gamblersTeam,
        pitchReport: {
          'condition': 'Good',
          'expected_behavior': 'Batting friendly',
        },
        weatherInfo: {'temperature': '25°C', 'weather': 'Sunny'},
      ),
      // ECS T10 Match 2
      Match(
        id: 'm5',
        tournamentName: 'ECS T10 Santarem Premier',
        venue: 'Santarem',
        matchTime: DateTime.now().add(const Duration(hours: 5, minutes: 31)),
        status: 'Upcoming',
        teamA: gorkhaTeam,
        teamB: lisbonTeam,
        pitchReport: {
          'condition': 'Good',
          'expected_behavior': 'Batting friendly',
        },
        weatherInfo: {'temperature': '25°C', 'weather': 'Sunny'},
      ),
    ];

    setState(() {
      _upcomingMatches.addAll(upcomingMatches);
    });
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
              'DREAM11',
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
          _buildPromotion(),
          _buildSportsTabs(),
          _buildTournamentFilters(),
          Expanded(child: _buildMatchList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildPromotion() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF3C1053), Color(0xFF7B1FA2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FREE ENTRY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'BIG WINNINGS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.directions_car, color: Colors.white, size: 40),
                      SizedBox(width: 8),
                      Icon(
                        Icons.sports_motorsports,
                        color: Colors.white,
                        size: 40,
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
  }

  Widget _buildOfferBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color(0xFFFFCD36),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.red[800], size: 20),
          const SizedBox(width: 8),
          const Text(
            '100% off, up to ₹20 per match*',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSportsTabs() {
    return Column(
      children: [
        _buildOfferBanner(),
        Container(
          height: 50,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _sports.length,
            itemBuilder: (context, index) {
              final sport = _sports[index];
              final isSelected = sport == _selectedSport;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSport = sport;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border:
                        isSelected
                            ? const Border(
                              bottom: BorderSide(color: Colors.red, width: 2),
                            )
                            : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getSportIcon(sport),
                        size: 16,
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        sport,
                        style: TextStyle(
                          color: isSelected ? Colors.red : Colors.grey[700],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getSportIcon(String sport) {
    switch (sport) {
      case 'Cricket':
        return Icons.sports_cricket;
      case 'Football':
        return Icons.sports_soccer;
      case 'Kabaddi':
        return Icons.sports_kabaddi;
      case 'Basketball':
        return Icons.sports_basketball;
      default:
        return Icons.sports;
    }
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

          return Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                tournament,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
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

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _upcomingMatches.length,
      itemBuilder: (context, index) {
        final match = _upcomingMatches[index];

        // If it's a new tournament type, show the header
        if (index == 0 ||
            match.tournamentName !=
                _upcomingMatches[index - 1].tournamentName) {
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
    } else if (name == 'ECS T10 Santarem Premier') {
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
    } else if (name == 'ECS T10 Santarem Premier') {
      return '• ECS T10 Santarem Premier';
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
          ] else if (match.tournamentName == 'ECS T10 Santarem Premier' &&
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
          ] else if (match.tournamentName == 'ECS T10 Santarem Premier' &&
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_add_check),
          label: 'My Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'DreamCoins',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          label: 'Refer & Win',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Games'),
      ],
      currentIndex: 0,
    );
  }
}
