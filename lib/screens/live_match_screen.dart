import 'package:flutter/material.dart';
import 'dart:async';
import '../models/match_model.dart';
import '../models/team_model.dart';
import '../utils/theme.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  Match? _match;
  late TabController _tabController;
  Timer? _refreshTimer;

  // Mock live match data
  final List<Map<String, dynamic>> _liveBallUpdates = [];
  final List<Map<String, dynamic>> _keyEvents = [];
  final Map<String, int> _playerFantasyPoints = {};
  String _currentBowler = '';
  String _currentBatsman1 = '';
  String _currentBatsman2 = '';
  int _currentOver = 0;
  int _currentBall = 0;
  String _lastBallOutcome = '';
  int _team1Score = 0;
  int _team1Wickets = 0;
  double _team1Overs = 0.0;
  double _currentRunRate = 0.0;
  double _requiredRunRate = 0.0;
  int _targetScore = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();

    // In a real app, this would be replaced with WebSocket or API polling
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateLiveData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadData() {
    // In a real app, this would fetch match data from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
        _match = _createMockMatch();
        _initializeMockLiveData();
      });
    });
  }

  void _initializeMockLiveData() {
    // Initialize mock live data
    _currentBowler = 'Jasprit Bumrah';
    _currentBatsman1 = 'Virat Kohli';
    _currentBatsman2 = 'Faf du Plessis';
    _currentOver = 8;
    _currentBall = 2;
    _lastBallOutcome = 'FOUR';
    _team1Score = 72;
    _team1Wickets = 1;
    _team1Overs = 8.2;
    _currentRunRate = 8.7;
    _requiredRunRate = 9.5;
    _targetScore = 187;

    // Initialize mock ball updates
    _liveBallUpdates.addAll([
      {
        'over': 8.2,
        'bowler': 'Jasprit Bumrah',
        'batsman': 'Virat Kohli',
        'outcome': 'FOUR',
        'description':
            'Full and outside off, Kohli drives through covers for a boundary',
        'timeStamp': DateTime.now().subtract(const Duration(seconds: 15)),
      },
      {
        'over': 8.1,
        'bowler': 'Jasprit Bumrah',
        'batsman': 'Virat Kohli',
        'outcome': '1',
        'description': 'Good length delivery, pushed to mid-on for a single',
        'timeStamp': DateTime.now().subtract(const Duration(seconds: 45)),
      },
      {
        'over': 8.0,
        'bowler': 'Jasprit Bumrah',
        'batsman': 'Faf du Plessis',
        'outcome': '0',
        'description':
            'Dot ball. Beaten outside off stump with a good delivery',
        'timeStamp': DateTime.now().subtract(
          const Duration(minutes: 1, seconds: 15),
        ),
      },
      {
        'over': 7.6,
        'bowler': 'Trent Boult',
        'batsman': 'Faf du Plessis',
        'outcome': '1',
        'description': 'Worked to leg side for a single to keep strike',
        'timeStamp': DateTime.now().subtract(
          const Duration(minutes: 1, seconds: 45),
        ),
      },
      {
        'over': 7.5,
        'bowler': 'Trent Boult',
        'batsman': 'Virat Kohli',
        'outcome': '4',
        'description':
            'Short ball pulled away to deep mid-wicket for four runs',
        'timeStamp': DateTime.now().subtract(
          const Duration(minutes: 2, seconds: 15),
        ),
      },
      {
        'over': 7.4,
        'bowler': 'Trent Boult',
        'batsman': 'Virat Kohli',
        'outcome': '6',
        'description': 'SIX! Magnificent shot over long-on. Kohli at his best!',
        'timeStamp': DateTime.now().subtract(
          const Duration(minutes: 2, seconds: 45),
        ),
      },
    ]);

    // Initialize mock key events
    _keyEvents.addAll([
      {
        'type': 'WICKET',
        'description': 'OUT! Glenn Maxwell b Bumrah 12(8)',
        'timeStamp': DateTime.now().subtract(const Duration(minutes: 10)),
      },
      {
        'type': 'MILESTONE',
        'description': 'Virat Kohli completes 1000 runs in this IPL season',
        'timeStamp': DateTime.now().subtract(const Duration(minutes: 7)),
      },
      {
        'type': 'BOUNDARY',
        'description': 'SIX! Kohli smashes Chahar over long-off',
        'timeStamp': DateTime.now().subtract(const Duration(minutes: 5)),
      },
      {
        'type': 'STRATEGIC_TIMEOUT',
        'description': 'Strategic Timeout taken by RCB',
        'timeStamp': DateTime.now().subtract(const Duration(minutes: 3)),
      },
    ]);

    // Initialize mock fantasy points
    _playerFantasyPoints.addAll({
      'Virat Kohli': 78,
      'Faf du Plessis': 45,
      'Glenn Maxwell': 18,
      'Jasprit Bumrah': 57,
      'Trent Boult': 32,
      'Rohit Sharma': 22,
    });
  }

  void _updateLiveData() {
    // In a real app, this would fetch updated data from an API
    // For demonstration, we'll add random updates

    // Only update if match is loaded
    if (_match == null) return;

    setState(() {
      if (_currentBall < 6) {
        _currentBall++;
      } else {
        _currentOver++;
        _currentBall = 1;

        // Alternate bowlers
        _currentBowler =
            _currentBowler == 'Jasprit Bumrah'
                ? 'Trent Boult'
                : 'Jasprit Bumrah';
      }

      _team1Overs = _currentOver + (_currentBall / 10);

      // Generate a random outcome for the ball
      final outcomes = ['0', '1', '2', '4', '6', 'WICKET'];
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % outcomes.length;
      _lastBallOutcome = outcomes[randomIndex];

      // Update the score based on the outcome
      switch (_lastBallOutcome) {
        case '0':
          // No change
          break;
        case '1':
          _team1Score += 1;
          // Swap batsmen
          final temp = _currentBatsman1;
          _currentBatsman1 = _currentBatsman2;
          _currentBatsman2 = temp;
          break;
        case '2':
          _team1Score += 2;
          break;
        case '4':
          _team1Score += 4;
          break;
        case '6':
          _team1Score += 6;
          break;
        case 'WICKET':
          _team1Wickets++;
          // New batsman
          _currentBatsman1 =
              [
                'Dinesh Karthik',
                'Glenn Maxwell',
                'Mahipal Lomror',
              ][_team1Wickets - 1];
          break;
      }

      // Update run rates
      _currentRunRate = _team1Score / (_team1Overs == 0 ? 1 : _team1Overs);
      final remainingOvers = 20 - _team1Overs;
      final runsNeeded = _targetScore - _team1Score;
      _requiredRunRate =
          runsNeeded / (remainingOvers == 0 ? 1 : remainingOvers);

      // Add ball update
      final descriptions = {
        '0': 'Dot ball. Good defensive shot.',
        '1': 'Pushed to mid-off for a single.',
        '2': 'Driven through covers for two runs.',
        '4': 'FOUR! Beautifully timed through the off side.',
        '6': 'SIX! Smashed over long-on!',
        'WICKET': 'OUT! Caught at deep mid-wicket. Great catch!',
      };

      _liveBallUpdates.insert(0, {
        'over': _team1Overs,
        'bowler': _currentBowler,
        'batsman': _currentBatsman1,
        'outcome': _lastBallOutcome,
        'description': descriptions[_lastBallOutcome],
        'timeStamp': DateTime.now(),
      });

      // Occasionally add a key event
      if (DateTime.now().second % 30 == 0) {
        _keyEvents.insert(0, {
          'type':
              ['MILESTONE', 'BOUNDARY', 'STRATEGY'][DateTime.now().minute % 3],
          'description': 'Important match event update!',
          'timeStamp': DateTime.now(),
        });
      }

      // Update fantasy points
      _playerFantasyPoints.forEach((player, points) {
        final random = DateTime.now().millisecondsSinceEpoch % 3;
        if (random == 1) {
          _playerFantasyPoints[player] = points + 2;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Match')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final match = _match!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(match),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildScorecard(match),
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondaryColor,
                  tabs: const [
                    Tab(text: 'Ball by Ball'),
                    Tab(text: 'Key Events'),
                    Tab(text: 'Fantasy Points'),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBallByBallTab(),
                      _buildKeyEventsTab(),
                      _buildFantasyPointsTab(),
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

  Widget _buildAppBar(Match match) {
    return SliverAppBar(
      expandedHeight: 120,
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7 * 255),
                  ],
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
            // Share live match
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_active),
          onPressed: () {
            // Notification settings
          },
        ),
      ],
    );
  }

  Widget _buildScorecard(Match match) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.teamA.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_team1Score/$_team1Wickets (${_team1Overs.toStringAsFixed(1)})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _targetScore > 0 ? 'Target: $_targetScore' : '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _targetScore > 0
                        ? 'Need ${_targetScore - _team1Score} in ${(20 - _team1Overs).toStringAsFixed(1)} overs'
                        : '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBatsmanInfo(_currentBatsman1, '38(24)', true),
              _buildBatsmanInfo(_currentBatsman2, '26(19)', false),
              _buildBowlerInfo(_currentBowler, '2/24 (4.2)'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRateInfo('CRR', _currentRunRate),
              _buildRateInfo('RRR', _requiredRunRate),
              _buildLastBallInfo(_lastBallOutcome),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatsmanInfo(String name, String score, bool isOnStrike) {
    return Row(
      children: [
        if (isOnStrike)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              score,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBowlerInfo(String name, String figures) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          figures,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRateInfo(String label, double rate) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          rate.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLastBallInfo(String outcome) {
    Color color;
    switch (outcome) {
      case 'FOUR':
        color = Colors.green;
        break;
      case 'SIX':
        color = Colors.blue;
        break;
      case 'WICKET':
        color = Colors.red;
        break;
      default:
        color = Colors.white;
    }

    return Column(
      children: [
        const Text(
          'Last Ball',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.1 * 255),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            outcome,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBallByBallTab() {
    if (_liveBallUpdates.isEmpty) {
      return const Center(child: Text('No updates yet'));
    }

    return ListView.builder(
      itemCount: _liveBallUpdates.length,
      itemBuilder: (context, index) {
        final update = _liveBallUpdates[index];
        return _buildBallUpdateItem(update);
      },
    );
  }

  Widget _buildBallUpdateItem(Map<String, dynamic> update) {
    Color ballColor;
    switch (update['outcome']) {
      case 'FOUR':
        ballColor = Colors.green;
        break;
      case 'SIX':
        ballColor = Colors.blue;
        break;
      case 'WICKET':
        ballColor = Colors.red;
        break;
      case '0':
        ballColor = Colors.grey;
        break;
      default:
        ballColor = Colors.amber;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ballColor.withValues(alpha: 0.2 * 255),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  update['outcome'],
                  style: TextStyle(
                    color: ballColor,
                    fontWeight: FontWeight.bold,
                    fontSize: update['outcome'].length > 1 ? 10 : 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Over ${update['over'].toString()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${update['bowler']} to ${update['batsman']}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(update['description']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyEventsTab() {
    if (_keyEvents.isEmpty) {
      return const Center(child: Text('No key events yet'));
    }

    return ListView.builder(
      itemCount: _keyEvents.length,
      itemBuilder: (context, index) {
        final event = _keyEvents[index];
        return _buildKeyEventItem(event);
      },
    );
  }

  Widget _buildKeyEventItem(Map<String, dynamic> event) {
    Color eventColor;
    IconData eventIcon;

    switch (event['type']) {
      case 'WICKET':
        eventColor = Colors.red;
        eventIcon = Icons.sports_cricket;
        break;
      case 'MILESTONE':
        eventColor = Colors.purple;
        eventIcon = Icons.emoji_events;
        break;
      case 'BOUNDARY':
        eventColor = Colors.blue;
        eventIcon = Icons.timeline;
        break;
      case 'STRATEGIC_TIMEOUT':
        eventColor = Colors.orange;
        eventIcon = Icons.timer;
        break;
      case 'STRATEGY':
        eventColor = Colors.teal;
        eventIcon = Icons.psychology;
        break;
      default:
        eventColor = Colors.grey;
        eventIcon = Icons.info;
    }

    final timestamp = event['timeStamp'] as DateTime;
    final minutes = DateTime.now().difference(timestamp).inMinutes;
    final timeAgo = minutes == 0 ? 'Just now' : '$minutes mins ago';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: eventColor.withValues(alpha: 0.2 * 255),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(eventIcon, color: eventColor, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event['type'],
                        style: TextStyle(
                          color: eventColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(event['description']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFantasyPointsTab() {
    if (_playerFantasyPoints.isEmpty) {
      return const Center(child: Text('No fantasy point updates yet'));
    }

    // Sort players by points in descending order
    final sortedPlayers =
        _playerFantasyPoints.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      itemCount: sortedPlayers.length,
      itemBuilder: (context, index) {
        final player = sortedPlayers[index];
        return _buildFantasyPointItem(player.key, player.value, index + 1);
      },
    );
  }

  Widget _buildFantasyPointItem(String name, int points, int rank) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9 * 255),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$points pts',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Match _createMockMatch() {
    // This is a mock match for demonstration
    return Match(
      id: 'm1',
      tournamentName: 'IPL 2023',
      venue: 'M. Chinnaswamy Stadium, Bangalore',
      matchTime: DateTime.now(),
      status: 'Live',
      teamA: Team(
        id: 't1',
        name: 'Royal Challengers Bangalore',
        shortName: 'RCB',
        flagImageUrl:
            'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/RCB/Logos/Medium/RCB.png',
        playerIds: ['p1', 'p2', 'p3', 'p4'],
        score:
            '$_team1Score/$_team1Wickets (${_team1Overs.toStringAsFixed(1)})',
      ),
      teamB: Team(
        id: 't2',
        name: 'Mumbai Indians',
        shortName: 'MI',
        flagImageUrl:
            'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/MI/Logos/Medium/MI.png',
        playerIds: ['p5', 'p6', 'p7', 'p8'],
        score: '186/5 (20.0)',
      ),
    );
  }
}
