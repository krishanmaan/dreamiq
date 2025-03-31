import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../utils/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../screens/team_builder_screen.dart';

class PlayerDetailsScreen extends StatefulWidget {
  final Player? player;
  
  const PlayerDetailsScreen({
    super.key,
    this.player,
  });

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

// Use a simple ValueNotifier to track favorites without needing SharedPreferences
final ValueNotifier<Set<String>> _favoritesNotifier = ValueNotifier<Set<String>>({});

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Player? _player;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPlayerData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _loadPlayerData() {
    if (widget.player != null) {
      setState(() {
        _player = widget.player;
        _isLoading = false;
      });
      return;
    }
    
    // If no player is provided via constructor, try to get from route arguments
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args.containsKey('player')) {
        setState(() {
          _player = args['player'] as Player;
          _isLoading = false;
        });
      } else {
        // No player data found, fallback to mock data
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Error reading arguments, fallback to mock data
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _toggleFavorite(String playerId) {
    final favorites = Set<String>.from(_favoritesNotifier.value);
    if (favorites.contains(playerId)) {
      favorites.remove(playerId);
    } else {
      favorites.add(playerId);
    }
    _favoritesNotifier.value = favorites;
    _showSnackBar(
      favorites.contains(playerId) 
        ? 'Added to favorites' 
        : 'Removed from favorites'
    );
  }
  
  void _sharePlayer(Player player) {
    // In a real app, this would use a sharing package
    _showSnackBar('Shared ${player.name}\'s profile');
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Player Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // Fallback to mock data if no player is provided
    final player = _player ?? _createMockPlayer();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePlayer(player),
          ),
          ValueListenableBuilder<Set<String>>(
            valueListenable: _favoritesNotifier,
            builder: (context, favorites, _) {
              final isFavorite = favorites.contains(player.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(player.id),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(player),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerHeader(player),
                  const SizedBox(height: 24),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 500, // Fixed height for tab content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildStatsTab(player),
                        _buildPerformanceTab(player),
                        _buildPitchAnalysisTab(player),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamBuilderScreen(
                preselectedPlayer: player,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add to Team'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
  
  Widget _buildAppBar(Player player) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          player.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              player.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.primaryColor,
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white54,
                  ),
                );
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
    );
  }
  
  Widget _buildPlayerHeader(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1 * 255),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              player.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${player.teamName} • ${player.role}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              if (player.isInjured)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1 * 255),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppTheme.errorColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          player.injuryInfo ?? 'Injured',
                          style: const TextStyle(
                            color: AppTheme.errorColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${player.credits} Cr',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected by ${player.selectionPercentage}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: AppTheme.primaryColor,
      unselectedLabelColor: AppTheme.textSecondaryColor,
      indicatorColor: AppTheme.secondaryColor,
      tabs: const [
        Tab(text: 'Stats'),
        Tab(text: 'Performance'),
        Tab(text: 'Pitch Analysis'),
      ],
    );
  }
  
  Widget _buildStatsTab(Player player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Player Stats',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatsGrid(player),
        const SizedBox(height: 24),
        Text(
          'Dream11 Points History',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: _buildPointsChart(player),
        ),
      ],
    );
  }
  
  Widget _buildStatsGrid(Player player) {
    // Extract stats from player model
    // In a real app, these would come from the player data
    final battingAvg = player.stats['battingAvg'] ?? '0';
    final strikeRate = player.stats['strikeRate'] ?? '0';
    final bowlingAvg = player.stats['bowlingAvg'] ?? '0';
    final economy = player.stats['economy'] ?? '0';
    final matches = player.stats['matches'] ?? '0';
    final dreamPoints = player.stats['avgDreamPoints'] ?? '0';
    
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Batting Avg', battingAvg),
        _buildStatCard('Strike Rate', strikeRate),
        _buildStatCard('Bowling Avg', bowlingAvg),
        _buildStatCard('Economy', economy),
        _buildStatCard('Matches', matches),
        _buildStatCard('Avg Points', dreamPoints),
      ],
    );
  }
  
  Widget _buildStatCard(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9 * 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05 * 255),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPointsChart(Player player) {
    final performances = player.recentPerformances;
    
    if (performances.isEmpty) {
      return const Center(
        child: Text('No recent performances'),
      );
    }
    
    // Get the last 5 performances
    final recentPerformances = performances.take(5).toList();
    
    // Sort by date
    recentPerformances.sort((a, b) => a.date.compareTo(b.date));
    
    // Create data points
    final List<FlSpot> spots = [];
    for (int i = 0; i < recentPerformances.length; i++) {
      spots.add(FlSpot(i.toDouble(), recentPerformances[i].dreamPoints.toDouble()));
    }
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2 * 255),
              strokeWidth: 1,
            );
          },
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2 * 255),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= recentPerformances.length) {
                  return const SizedBox.shrink();
                }
                final match = recentPerformances[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    match.opponentTeam,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: (recentPerformances.length - 1).toDouble(),
        minY: 0,
        maxY: recentPerformances.map((e) => e.dreamPoints.toDouble()).reduce(
              (a, b) => a > b ? a : b,
            ) + 20,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.secondaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.secondaryColor,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.secondaryColor.withValues(alpha: 0.3 * 255),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPerformanceTab(Player player) {
    final performances = player.recentPerformances;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Performances',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (performances.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No recent performances'),
            ),
          )
        else
          ...performances.map((performance) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildPerformanceCard(performance),
          )),
      ],
    );
  }
  
  Widget _buildPerformanceCard(MatchPerformance performance) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'vs ${performance.opponentTeam}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: performance.matchResult == 'Won'
                        ? Colors.green.withValues(alpha: 0.2 * 255)
                        : Colors.red.withValues(alpha: 0.2 * 255),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    performance.matchResult ?? 'No Result',
                    style: TextStyle(
                      color: performance.matchResult == 'Won'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              performance.venue,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
            Text(
              '${performance.date.day}/${performance.date.month}/${performance.date.year}',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Runs', performance.runs.toString()),
                _buildStatItem('Balls Faced', performance.ballsFaced.toString()),
                _buildStatItem('Strike Rate', performance.strikeRate.toStringAsFixed(1)),
                _buildStatItem('Dream Points', performance.dreamPoints.toString()),
              ],
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
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPitchAnalysisTab(Player player) {
    // This would be a more complex visualization in a real app
    // For now, we'll just show a placeholder
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_cricket,
            size: 64,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Pitch Analysis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Advanced pitch analysis features will be available soon.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Creates a mock player for testing
  Player _createMockPlayer() {
    return Player(
      id: 'mock1',
      name: 'Virat Kohli',
      teamName: 'RCB',
      role: 'Batsman',
      credits: 10.5,
      selectionPercentage: 92.5,
      imageUrl: 'https://picsum.photos/200',
      isInjured: false,
      stats: {
        'battingAvg': '53.4',
        'strikeRate': '138.6',
        'bowlingAvg': '0',
        'economy': '0',
        'matches': '245',
        'avgDreamPoints': '78.3',
      },
      recentPerformances: [
        MatchPerformance(
          matchId: 'm1',
          opponentTeam: 'CSK',
          venue: 'M. Chinnaswamy Stadium',
          date: DateTime.now().subtract(const Duration(days: 3)),
          runs: 82,
          wickets: 0,
          ballsFaced: 52,
          ballsBowled: 0,
          economyRate: 9.5,
          strikeRate: 157.7,
          dreamPoints: 112,
          matchResult: 'Won',
        ),
        MatchPerformance(
          matchId: 'm2',
          opponentTeam: 'MI',
          venue: 'Wankhede Stadium',
          date: DateTime.now().subtract(const Duration(days: 8)),
          runs: 48,
          wickets: 0,
          ballsFaced: 32,
          ballsBowled: 0,
          economyRate: 0.0,
          strikeRate: 150.0,
          dreamPoints: 68,
          matchResult: 'Lost',
        ),
        MatchPerformance(
          matchId: 'm3',
          opponentTeam: 'KKR',
          venue: 'Eden Gardens',
          date: DateTime.now().subtract(const Duration(days: 12)),
          runs: 26,
          wickets: 0,
          ballsFaced: 17,
          ballsBowled: 0,
          economyRate: 0.0,
          strikeRate: 152.9,
          dreamPoints: 42,
          matchResult: 'Lost',
        ),
      ],
    );
  }
} 