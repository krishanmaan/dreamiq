import '../models/team_model.dart';

class IPLTeams {
  static final miTeam = Team(
    id: 't1',
    name: 'Mumbai Indians',
    shortName: 'MI',
    flagImageUrl:
        'https://ssl.gstatic.com/onebox/media/sports/logos/HmiWb77BmJDs6sHvn77v_Q_48x48.png',
    playerIds: [],
  );

  static final cskTeam = Team(
    id: 't2',
    name: 'Chennai Super Kings',
    shortName: 'CSK',
    flagImageUrl:
        'https://ssl.gstatic.com/onebox/media/sports/logos/5G8eFjkPKNalIgL2FOtovg_48x48.png',
    playerIds: [],
  );

  static final kkrTeam = Team(
    id: 't3',
    name: 'Kolkata Knight Riders',
    shortName: 'KKR',
    flagImageUrl:
        'https://ssl.gstatic.com/onebox/media/sports/logos/eDkEYCyMSAHSQFjQNOQF1w_48x48.png',
    playerIds: [],
  );

  static final srhTeam = Team(
    id: 't4',
    name: 'Sunrisers Hyderabad',
    shortName: 'SRH',
    flagImageUrl:
        'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/SRH/Logos/Roundbig/SRHroundbig.png',
    playerIds: [],
  );

  static final lsgTeam = Team(
    id: 't5',
    name: 'Lucknow Super Giants',
    shortName: 'LSG',
    flagImageUrl:
        'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/LSG/Logos/Roundbig/LSGroundbig.png',
    playerIds: [],
  );

  static final pbksTeam = Team(
    id: 't6',
    name: 'Punjab Kings',
    shortName: 'PBKS',
    flagImageUrl:
        'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/PBKS/Logos/Roundbig/PBKSroundbig.png',
    playerIds: [],
  );

  static final gtTeam = Team(
    id: 't7',
    name: 'Gujarat Titans',
    shortName: 'GT',
    flagImageUrl:
        'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/GT/Logos/Roundbig/GTroundbig.png',
    playerIds: [],
  );

  static final dcTeam = Team(
    id: 't8',
    name: 'Delhi Capitals',
    shortName: 'DC',
    flagImageUrl:
        'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/DC/Logos/Roundbig/DCroundbig.png',
    playerIds: [],
  );

  static final rrTeam = Team(
    id: 't9',
    name: 'Rajasthan Royals',
    shortName: 'RR',
    flagImageUrl:
        'https://ssl.gstatic.com/onebox/media/sports/logos/GqIU6xhQAnCpy_Cbr2LZRA_48x48.png',
    playerIds: [],
  );

  static final rcbTeam = Team(
    id: 't10',
    name: 'Royal Challengers Bangalore',
    shortName: 'RCB',
    flagImageUrl:
        'https://bcciplayerimages.s3.ap-south-1.amazonaws.com/ipl/RCB/Logos/Roundbig/RCBroundbig.png',
    playerIds: [],
  );

  static List<Team> getAllTeams() {
    return [
      miTeam,
      cskTeam,
      kkrTeam,
      srhTeam,
      lsgTeam,
      pbksTeam,
      gtTeam,
      dcTeam,
      rrTeam,
      rcbTeam,
    ];
  }
}
