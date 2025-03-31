import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/match_model.dart';
import '../screens/team_details_screen.dart';
import '../utils/theme.dart';

class TeamBuilderScreen extends StatefulWidget {
  final Player? preselectedPlayer;
  final Match? match;
  
  const TeamBuilderScreen({
    super.key, 
    this.preselectedPlayer,
    this.match,
  });

  @override
  State<TeamBuilderScreen> createState() => _TeamBuilderScreenState();
}

class _TeamBuilderScreenState extends State<TeamBuilderScreen> {
  bool _isLoading = true;
  Match? _match;
  List<Player> _availablePlayers = [];
  final List<Player> _selectedPlayers = [];
  String? _captainId;
  String? _viceCaptainId;
  double _totalCredits = 0;
  final double _maxCredits = 100;
  final Map<String, int> _roleCount = {
    'WK': 0,
    'BAT': 0,
    'AR': 0,
    'BOWL': 0,
  };
  String _selectedRoleFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // In a real app, this would fetch match and player data from an API
    // For now, we'll simulate a network request
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
        // Load match data from route arguments
        _match = widget.match;
        _availablePlayers = _createMockPlayers();
        
        // If there's a preselected player, add them to the selected players
        if (widget.preselectedPlayer != null) {
          final player = widget.preselectedPlayer!;
          _availablePlayers.removeWhere((p) => p.id == player.id);
          _selectedPlayers.add(player);
          
          // Update credits and role counts
          _totalCredits += player.credits;
          final role = _mapRoleToShortCode(player.role);
          _roleCount[role] = (_roleCount[role] ?? 0) + 1;
          
          // Show confirmation to the user
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${player.name} added to your team'),
                backgroundColor: Colors.green,
              ),
            );
          });
        }
      });
    });
  }

  void _selectPlayer(Player player) {
    if (_selectedPlayers.length >= 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only select 11 players'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_totalCredits + player.credits > _maxCredits) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough credits'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Update role count
    String role = _mapRoleToShortCode(player.role);
    if (!_checkRoleLimit(role)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only select up to ${_getMaxForRole(role)} $role players'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _selectedPlayers.add(player);
      _availablePlayers.remove(player);
      _totalCredits += player.credits;
      _roleCount[role] = (_roleCount[role] ?? 0) + 1;
    });
  }

  void _removePlayer(Player player) {
    String role = _mapRoleToShortCode(player.role);
    
    setState(() {
      if (_captainId == player.id) {
        _captainId = null;
      }
      if (_viceCaptainId == player.id) {
        _viceCaptainId = null;
      }
      
      _selectedPlayers.remove(player);
      _availablePlayers.add(player);
      _totalCredits -= player.credits;
      _roleCount[role] = (_roleCount[role] ?? 0) - 1;
    });
  }

  void _setCaptain(String playerId) {
    setState(() {
      if (_viceCaptainId == playerId) {
        _viceCaptainId = null;
      }
      _captainId = playerId;
    });
  }

  void _setViceCaptain(String playerId) {
    setState(() {
      if (_captainId == playerId) {
        _captainId = null;
      }
      _viceCaptainId = playerId;
    });
  }

  bool _checkRoleLimit(String role) {
    final currentCount = _roleCount[role] ?? 0;
    return currentCount < _getMaxForRole(role);
  }

  int _getMaxForRole(String role) {
    switch (role) {
      case 'WK':
        return 4;
      case 'BAT':
        return 6;
      case 'AR':
        return 4;
      case 'BOWL':
        return 6;
      default:
        return 0;
    }
  }

  String _mapRoleToShortCode(String role) {
    switch (role.toLowerCase()) {
      case 'wicket-keeper':
        return 'WK';
      case 'batsman':
        return 'BAT';
      case 'all-rounder':
        return 'AR';
      case 'bowler':
        return 'BOWL';
      default:
        return role;
    }
  }

  bool _isTeamValid() {
    if (_selectedPlayers.length != 11) return false;
    if (_captainId == null || _viceCaptainId == null) return false;
    if (_totalCredits > _maxCredits) return false;
    
    // Check minimum requirements for each role
    if ((_roleCount['WK'] ?? 0) < 1) return false;
    if ((_roleCount['BAT'] ?? 0) < 3) return false;
    if ((_roleCount['AR'] ?? 0) < 1) return false;
    if ((_roleCount['BOWL'] ?? 0) < 3) return false;
    
    return true;
  }

  void _saveTeam() {
    if (!_isTeamValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete your team selection'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    // In a real app, this would save the team to a database or API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Team saved successfully'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to team details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamDetailsScreen(
                  players: _selectedPlayers,
                  captainId: _captainId,
                  viceCaptainId: _viceCaptainId,
                  teamName: _match != null 
                      ? "${_match!.teamA.shortName} vs ${_match!.teamB.shortName} - My Team" 
                      : "My Dream Team",
                  totalCredits: _totalCredits,
                ),
              ),
            );
          },
          textColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Your Team'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Team'),
        actions: [
          TextButton.icon(
            onPressed: _saveTeam,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTeamInfo(),
          _buildRoleFilter(),
          Expanded(
            child: _buildPlayersList(),
          ),
          if (_selectedPlayers.isNotEmpty)
            _buildSelectedPlayersPreview(),
        ],
      ),
    );
  }

  Widget _buildTeamInfo() {
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
                    'Players',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${_selectedPlayers.length}/11',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credits Left',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    (_maxCredits - _totalCredits).toStringAsFixed(1),
                    style: TextStyle(
                      color: _maxCredits - _totalCredits < 0 ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (_match != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Match',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${_match!.teamA.shortName} vs ${_match!.teamB.shortName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          _buildRoleFilterChip('ALL', 'All'),
          const SizedBox(width: 8),
          _buildRoleFilterChip('WK', 'WK (${_roleCount['WK']}/4)'),
          const SizedBox(width: 8),
          _buildRoleFilterChip('BAT', 'BAT (${_roleCount['BAT']}/6)'),
          const SizedBox(width: 8),
          _buildRoleFilterChip('AR', 'AR (${_roleCount['AR']}/4)'),
          const SizedBox(width: 8),
          _buildRoleFilterChip('BOWL', 'BOWL (${_roleCount['BOWL']}/6)'),
        ],
      ),
    );
  }

  Widget _buildRoleFilterChip(String role, String label) {
    final isSelected = _selectedRoleFilter == role;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRoleFilter = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersList() {
    final filteredPlayers = _selectedRoleFilter == 'ALL'
        ? _availablePlayers
        : _availablePlayers.where((p) => _mapRoleToShortCode(p.role) == _selectedRoleFilter).toList();
    
    return ListView.builder(
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final player = filteredPlayers[index];
        return _buildPlayerListItem(player);
      },
    );
  }

  Widget _buildPlayerListItem(Player player) {
    final role = _mapRoleToShortCode(player.role);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(player.imageUrl),
          radius: 24,
          onBackgroundImageError: (_, __) {},
          child: player.imageUrl.isEmpty
              ? Text(
                  player.name.substring(0, 1),
                  style: const TextStyle(fontSize: 18),
                )
              : null,
        ),
        title: Row(
          children: [
            Text(
              player.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(role),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(player.teamName),
            if (player.isInjured)
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    player.injuryInfo ?? 'Injured',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${player.credits} Cr',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${player.selectionPercentage}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _selectPlayer(player),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _checkRoleLimit(role) && _selectedPlayers.length < 11
                      ? AppTheme.secondaryColor
                      : Colors.grey,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPlayersPreview() {
    return Container(
      height: 120,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Selected Players (${_selectedPlayers.length}/11)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedPlayers.length,
              itemBuilder: (context, index) {
                final player = _selectedPlayers[index];
                return _buildSelectedPlayerItem(player);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPlayerItem(Player player) {
    final isCaptain = _captainId == player.id;
    final isViceCaptain = _viceCaptainId == player.id;
    final role = _mapRoleToShortCode(player.role);
    
    return GestureDetector(
      onTap: () => _showPlayerActionSheet(player),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCaptain
                ? Colors.green
                : isViceCaptain
                    ? Colors.blue
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(player.imageUrl),
                  radius: 18,
                  onBackgroundImageError: (_, __) {},
                  child: player.imageUrl.isEmpty
                      ? Text(
                          player.name.substring(0, 1),
                          style: const TextStyle(fontSize: 18),
                        )
                      : null,
                ),
                if (isCaptain)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (isViceCaptain)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'VC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              player.name.split(' ').first,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(role),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlayerActionSheet(Player player) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Make Captain'),
                onTap: () {
                  Navigator.pop(context);
                  _setCaptain(player.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Make Vice Captain'),
                onTap: () {
                  Navigator.pop(context);
                  _setViceCaptain(player.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Remove from Team'),
                onTap: () {
                  Navigator.pop(context);
                  _removePlayer(player);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'WK':
        return Colors.red;
      case 'BAT':
        return Colors.blue;
      case 'AR':
        return Colors.purple;
      case 'BOWL':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  List<Player> _createMockPlayers() {
    // This is mock data for demonstration
    return [
      Player(
        id: 'p1',
        name: 'Virat Kohli',
        teamName: 'RCB',
        role: 'Batsman',
        imageUrl: 'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320,q_50/lsci/db/PICTURES/CMS/316400/316486.png',
        credits: 10.0,
        selectionPercentage: 85.7,
        stats: {'battingAvg': '50.3'},
        isInjured: false,
        recentPerformances: [],
      ),
      Player(
        id: 'p2',
        name: 'Rohit Sharma',
        teamName: 'MI',
        role: 'Batsman',
        imageUrl: 'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320,q_50/lsci/db/PICTURES/CMS/312300/312330.jpg',
        credits: 9.5,
        selectionPercentage: 76.8,
        stats: {'battingAvg': '45.1'},
        isInjured: false,
        recentPerformances: [],
      ),
      Player(
        id: 'p3',
        name: 'MS Dhoni',
        teamName: 'CSK',
        role: 'Wicket-Keeper',
        imageUrl: 'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320,q_50/lsci/db/PICTURES/CMS/312300/312352.jpg',
        credits: 9.0,
        selectionPercentage: 68.5,
        stats: {'battingAvg': '39.5'},
        isInjured: false,
        recentPerformances: [],
      ),
      Player(
        id: 'p4',
        name: 'Jasprit Bumrah',
        teamName: 'MI',
        role: 'Bowler',
        imageUrl: 'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320,q_50/lsci/db/PICTURES/CMS/312300/312368.jpg',
        credits: 9.0,
        selectionPercentage: 71.2,
        stats: {'economy': '6.7'},
        isInjured: false,
        recentPerformances: [],
      ),
      Player(
        id: 'p5',
        name: 'Ravindra Jadeja',
        teamName: 'CSK',
        role: 'All-Rounder',
        imageUrl: 'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320,q_50/lsci/db/PICTURES/CMS/312300/312344.jpg',
        credits: 9.0,
        selectionPercentage: 65.9,
        stats: {'battingAvg': '33.7', 'economy': '7.6'},
        isInjured: false,
        recentPerformances: [],
      ),
      // Add more mock players as needed
    ];
  }
} 