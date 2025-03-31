import 'package:flutter/material.dart';
import '../models/team_model.dart';

class LiveScoreCard extends StatelessWidget {
  final Team teamA;
  final Team teamB;
  final String result;

  const LiveScoreCard({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildTeamScore(
                  teamA.shortName,
                  '182-9 (20)',
                  teamA.flagImageUrl,
                  true,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'D',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildTeamScore(
                  teamB.shortName,
                  '176-6 (20)',
                  teamB.flagImageUrl,
                  false,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Handle scorecard tap
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scorecard',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                        size: 16,
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

  Widget _buildTeamScore(
    String teamName,
    String score,
    String flagUrl,
    bool isTeamA,
  ) {
    return Expanded(
      child: Row(
        mainAxisAlignment:
            isTeamA ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isTeamA) _buildTeamLogo(flagUrl),
          if (isTeamA) const SizedBox(width: 8),
          Column(
            crossAxisAlignment:
                isTeamA ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                teamName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                score,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          if (!isTeamA) const SizedBox(width: 8),
          if (!isTeamA) _buildTeamLogo(flagUrl),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String flagUrl) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(flagUrl), fit: BoxFit.cover),
      ),
    );
  }
}
