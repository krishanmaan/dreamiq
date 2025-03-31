import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../utils/theme.dart';

class PlayerStatsCard extends StatelessWidget {
  final Player player;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const PlayerStatsCard({
    super.key,
    required this.player,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1 * 255),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [_buildHeader(), if (isExpanded) _buildExpandedContent()],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: onToggleExpand,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildPlayerImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${player.teamName} • ${player.role}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${player.credits} Cr',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Selected by ',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    Text(
                      '${player.selectionPercentage}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerImage() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          player.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Text(
                player.name.substring(0, 1),
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 4),
          const Text(
            'Statistics',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatistics(),
          const SizedBox(height: 16),
          const Text(
            'Recent Performances',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildRecentPerformances(),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final stats = Map<String, dynamic>.from(player.stats);
    final mainStats = _getMainStatsForRole(player.role);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          mainStats.map((statName) {
            final value = stats[statName] ?? 0;
            return _buildStatItem(statName, value);
          }).toList(),
    );
  }

  List<String> _getMainStatsForRole(String role) {
    switch (role) {
      case 'Batsman':
        return ['Matches', 'Runs', 'Average', 'Strike Rate', '50s', '100s'];
      case 'Bowler':
        return [
          'Matches',
          'Wickets',
          'Economy',
          'Average',
          'Strike Rate',
          '5W',
        ];
      case 'All-Rounder':
        return ['Matches', 'Runs', 'Wickets', 'Bat Avg', 'Bowl Avg', 'SR'];
      case 'Wicket-Keeper':
        return [
          'Matches',
          'Runs',
          'Average',
          'Strike Rate',
          'Dismissals',
          'Stumpings',
        ];
      default:
        return ['Matches', 'Runs', 'Wickets', 'Average', 'Strike Rate'];
    }
  }

  Widget _buildStatItem(String name, dynamic value) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
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

  Widget _buildRecentPerformances() {
    final performances = player.recentPerformances;

    if (performances.isEmpty) {
      return const Text(
        'No recent match data available',
        style: TextStyle(
          fontSize: 13,
          color: AppTheme.textSecondaryColor,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      children:
          performances.take(3).map((performance) {
            return _buildPerformanceItem(performance);
          }).toList(),
    );
  }

  Widget _buildPerformanceItem(MatchPerformance performance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                performance.opponentTeam,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              Text(
                _formatDate(performance.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPerformanceStat('Runs', performance.runs.toString()),
              _buildPerformanceStat('Wickets', performance.wickets.toString()),
              _buildPerformanceStat(
                'Dream Pts',
                performance.dreamPoints.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 2),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
