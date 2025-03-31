import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../utils/theme.dart';

class PlayerSelectionCard extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final VoidCallback onSelect;
  final bool isCaptain;
  final bool isViceCaptain;
  final VoidCallback? onCaptainSelect;
  final VoidCallback? onViceCaptainSelect;
  final bool showCaptainControls;

  const PlayerSelectionCard({
    super.key,
    required this.player,
    required this.isSelected,
    required this.onSelect,
    this.isCaptain = false,
    this.isViceCaptain = false,
    this.onCaptainSelect,
    this.onViceCaptainSelect,
    this.showCaptainControls = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: isSelected ? 1.5 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? AppTheme.primaryColor.withValues(alpha: 0.1 * 255)
                : Colors.grey.withValues(alpha: 0.05 * 255),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  _buildPlayerImage(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isCaptain)
                              _buildCaptainBadge('C')
                            else if (isViceCaptain)
                              _buildCaptainBadge('VC'),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                player.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppTheme.textPrimaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildTeamTag(),
                            const SizedBox(width: 8),
                            _buildRoleTag(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${player.credits} Cr',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selected by ${player.selectionPercentage}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (showCaptainControls) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _buildCaptainControls(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerImage() {
    return Stack(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.5),
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
        ),
        if (player.isInjured)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppTheme.errorColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTeamTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        player.teamName,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRoleTag() {
    Color bgColor;
    
    switch (player.role) {
      case 'Batsman':
        bgColor = Colors.blue.shade100;
        break;
      case 'Bowler':
        bgColor = Colors.green.shade100;
        break;
      case 'All-Rounder':
        bgColor = Colors.purple.shade100;
        break;
      case 'Wicket-Keeper':
        bgColor = Colors.orange.shade100;
        break;
      default:
        bgColor = Colors.grey.shade100;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        player.role,
        style: TextStyle(
          color: HSLColor.fromColor(bgColor).withLightness(
            (HSLColor.fromColor(bgColor).lightness - 0.5).clamp(0.0, 1.0)
          ).toColor(),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCaptainBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCaptainControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCaptainButton(
          'C',
          isCaptain,
          onCaptainSelect,
          AppTheme.primaryColor,
        ),
        _buildCaptainButton(
          'VC',
          isViceCaptain,
          onViceCaptainSelect,
          AppTheme.accentColor,
        ),
      ],
    );
  }

  Widget _buildCaptainButton(
    String text,
    bool isActive,
    VoidCallback? onPressed,
    Color activeColor,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? activeColor : Colors.grey.shade200,
        foregroundColor: isActive ? Colors.white : Colors.grey.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: isActive ? 2 : 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isActive ? Colors.white : Colors.grey.shade800,
        ),
      ),
    );
  }
} 