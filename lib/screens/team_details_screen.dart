import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../utils/theme.dart';

class TeamDetailsScreen extends StatelessWidget {
  final List<Player> players;
  final String? captainId;
  final String? viceCaptainId;
  final String teamName;
  final double totalCredits;

  const TeamDetailsScreen({
    super.key,
    required this.players,
    required this.captainId,
    required this.viceCaptainId,
    required this.teamName,
    required this.totalCredits,
  });

  @override
  Widget build(BuildContext context) {
    // Group players by role
    final wicketKeepers = players.where((p) => p.role.toLowerCase() == 'wicket-keeper').toList();
    final batsmen = players.where((p) => p.role.toLowerCase() == 'batsman').toList();
    final allRounders = players.where((p) => p.role.toLowerCase() == 'all-rounder').toList();
    final bowlers = players.where((p) => p.role.toLowerCase() == 'bowler').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(teamName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTeamHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, 'Wicket Keepers (${wicketKeepers.length})'),
                    const SizedBox(height: 8),
                    ...wicketKeepers.map((p) => _buildPlayerCard(context, p)),
                    const SizedBox(height: 16),
                    
                    _buildSectionHeader(context, 'Batsmen (${batsmen.length})'),
                    const SizedBox(height: 8),
                    ...batsmen.map((p) => _buildPlayerCard(context, p)),
                    const SizedBox(height: 16),
                    
                    _buildSectionHeader(context, 'All Rounders (${allRounders.length})'),
                    const SizedBox(height: 8),
                    ...allRounders.map((p) => _buildPlayerCard(context, p)),
                    const SizedBox(height: 16),
                    
                    _buildSectionHeader(context, 'Bowlers (${bowlers.length})'),
                    const SizedBox(height: 8),
                    ...bowlers.map((p) => _buildPlayerCard(context, p)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamHeader(BuildContext context) {
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
                  const Text(
                    'Team Name',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    teamName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Credits',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    totalCredits.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, Player player) {
    final isCaptain = player.id == captainId;
    final isViceCaptain = player.id == viceCaptainId;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Player image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCaptain 
                    ? AppTheme.secondaryColor 
                    : (isViceCaptain ? Colors.orange : Colors.transparent),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(player.imageUrl),
                child: player.imageUrl.isEmpty
                  ? Text(
                      player.name.substring(0, 1),
                      style: const TextStyle(fontSize: 18),
                    )
                  : null,
              ),
            ),
            const SizedBox(width: 12),
            
            // Player details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (isCaptain)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (isViceCaptain)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'VC',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${player.teamName} • ${player.role}',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Player credits
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.4 * 255),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${player.credits} Cr',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 