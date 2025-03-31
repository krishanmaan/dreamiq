import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Contest {
  final String id;
  final String name;
  final int entryFee;
  final int totalSpots;
  final int filledSpots;
  final int prizePool;
  final int maxTeamsPerUser;
  final bool isGuaranteed;
  final bool isMultipleEntry;

  Contest({
    required this.id,
    required this.name,
    required this.entryFee,
    required this.totalSpots,
    required this.filledSpots,
    required this.prizePool,
    required this.maxTeamsPerUser,
    required this.isGuaranteed,
    required this.isMultipleEntry,
  });
}

class MatchContestCard extends StatelessWidget {
  final Contest contest;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  const MatchContestCard({
    super.key,
    required this.contest,
    required this.onTap,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05 * 255),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildProgressBar(),
            _buildDetails(),
            _buildPrizes(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            contest.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          _buildEntryTag(),
        ],
      ),
    );
  }

  Widget _buildEntryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: contest.isMultipleEntry
            ? Colors.blue.withValues(alpha: 0.1 * 255)
            : Colors.green.withValues(alpha: 0.1 * 255),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        contest.isMultipleEntry ? 'Multiple Entry' : 'Single Entry',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: contest.isMultipleEntry ? Colors.blue : Colors.green,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final filledPercentage = (contest.filledSpots / contest.totalSpots) * 100;
    final spotsLeft = contest.totalSpots - contest.filledSpots;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: filledPercentage / 100,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2 * 255),
                    color: _getProgressColor(filledPercentage),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$spotsLeft ${spotsLeft == 1 ? 'spot' : 'spots'} left',
                style: TextStyle(
                  fontSize: 12,
                  color: _getProgressColor(filledPercentage),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${contest.totalSpots} spots',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 50) {
      return Colors.green;
    } else if (percentage < 80) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '₹${_formatCurrency(contest.prizePool)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              if (contest.isGuaranteed) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2 * 255),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'G',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ],
          ),
          ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: const Size(60, 32),
            ),
            child: Text(
              '₹${contest.entryFee}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.military_tech,
                color: AppTheme.primaryColor,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '₹10,000',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.people,
                  color: AppTheme.textSecondaryColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${(contest.totalSpots * 0.4).floor()}% winners',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textSecondaryColor,
            size: 14,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    if (amount >= 10000000) {  // 1 crore or more
      return '${(amount / 10000000).toStringAsFixed(amount % 10000000 == 0 ? 0 : 1)} Cr';
    } else if (amount >= 100000) {  // 1 lakh or more
      return '${(amount / 100000).toStringAsFixed(amount % 100000 == 0 ? 0 : 1)} L';
    } else if (amount >= 1000) {  // 1 thousand or more
      return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
    } else {
      return amount.toString();
    }
  }
} 