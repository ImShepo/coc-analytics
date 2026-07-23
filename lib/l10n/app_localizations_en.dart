// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Clash Companion';

  @override
  String get language => 'Language';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'English';

  @override
  String get languagePt => 'Português';

  @override
  String get languageFr => 'Français';

  @override
  String get languageIt => 'Italiano';

  @override
  String get navHome => 'Home';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get searchClanPlaceholder => 'Search clan';

  @override
  String get welcomeSignUpOrLogin => 'Sign up or Log in';

  @override
  String get welcomeGreeting => 'Welcome, ';

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginNoAccountPrompt => 'Don\'t have an account?';

  @override
  String get loginCreateAccountAction => 'Create one now!';

  @override
  String get signUpTitle => 'Sign up';

  @override
  String get signUpHasAccountPrompt => 'Already have an account?';

  @override
  String get signUpLoginAction => 'Log in now!';

  @override
  String get emailPlaceholder => 'Email';

  @override
  String get passwordPlaceholder => 'Password';

  @override
  String get namePlaceholder => 'Name';

  @override
  String get signInButton => 'Sign in';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get signingUp => 'Creating account…';

  @override
  String get authFieldsRequired => 'Please fill in all fields.';

  @override
  String get signOutButton => 'Sign out';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get accountMenuTooltip => 'Account';

  @override
  String get unlinkPlayerButton => 'Unlink player';

  @override
  String get unlinkPlayerTitle => 'Unlink player';

  @override
  String get unlinkPlayerMessage => 'This will remove the link to your Clash of Clans player. You can link a different tag afterwards.';

  @override
  String get cancel => 'Cancel';

  @override
  String get linkPlayerTitle => 'Link your player';

  @override
  String get linkPlayerSubtitle => 'Enter your Clash of Clans player tag to load your stats. If you don\'t play, you can continue without linking.';

  @override
  String get linkPlayerAltHelp => 'Don\'t have the game installed? Search your clan, pick your name, and verify with the API Token. If you don\'t play, you can continue without linking.';

  @override
  String get linkPlayerTagPlaceholder => 'Player tag (#ABC123)';

  @override
  String get linkPlayerTagRequired => 'Enter your player tag.';

  @override
  String get linkPlayerTagHelp => 'In Clash of Clans:\nOpen your profile (village icon), go to “My Profile”, and copy the tag under your name.';

  @override
  String get linkPlayerTokenPlaceholder => 'API Token';

  @override
  String get linkPlayerTokenRequired => 'Enter the in-game API Token.';

  @override
  String get linkPlayerTokenHelp => 'In Clash of Clans:\nGo to Settings → More settings, find the “API Token” section, and tap “SHOW” to view and copy it.';

  @override
  String get linkPlayerSeeGuide => 'See guide';

  @override
  String get linkPlayerTokenInvalid => 'That API Token is not valid for this tag. Generate a new one in-game and try again.';

  @override
  String get linkPlayerPickMemberFirst => 'Pick your player from the list first.';

  @override
  String linkPlayerVerifySelected(String name, String tag) {
    return 'Verify $name ($tag)';
  }

  @override
  String get linkPlayerButton => 'Verify and link';

  @override
  String get linkingPlayer => 'Verifying…';

  @override
  String get linkPlayerSkip => 'Continue without linking';

  @override
  String get guestHomeUnlinkedTag => 'Not linked';

  @override
  String get guestHomeLinkCta => 'Link my player';

  @override
  String get guestHomeStatsHint => 'Link your player to see your stats.';

  @override
  String get guestHomeCompareHint => 'Link your player to compare with others.';

  @override
  String get guestHomeClanHint => 'Link your player to see your clan.';

  @override
  String get guestHomeCategoriesHint => 'Link your player to see troops, heroes, and more.';

  @override
  String get linkPlayerModeTag => 'By tag';

  @override
  String get linkPlayerModeClan => 'By clan';

  @override
  String get linkPlayerSearchClan => 'Search clan';

  @override
  String get linkPlayerClanQueryHint => 'By name: at least 3 letters. By tag: include # (e.g. #2GQYGPLOC).';

  @override
  String get linkPlayerPickClan => 'Choose your clan';

  @override
  String linkPlayerClanCount(int count) {
    return '$count clans';
  }

  @override
  String linkPlayerMemberCount(int count) {
    return '$count players';
  }

  @override
  String get linkPlayerPickMember => 'Choose your player';

  @override
  String get linkPlayerLookupOnline => 'Look up tag online';

  @override
  String get browseHomeTitle => 'Browse';

  @override
  String get browseHomeSubtitle => 'Search clans or look up any player. Link yours whenever you want to see your stats.';

  @override
  String get browseLookupPlayerTitle => 'Look up a player';

  @override
  String get browseLookupPlayerButton => 'View player';

  @override
  String get browseLinkPlayerCta => 'Link my player';

  @override
  String get termsAndConditions => 'Terms and conditions of use';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get retry => 'Retry';

  @override
  String get dataRefreshing => 'Updating data…';

  @override
  String get dataUpdatedJustNow => 'Updated just now';

  @override
  String dataUpdatedAgo(int minutes) {
    return 'Updated $minutes min ago';
  }

  @override
  String get dataRefreshFailed => 'Could not refresh. Showing saved data.';

  @override
  String get playerErrorForbiddenHint => 'If you see \"Forbidden\", update COC_KEY in the .env file with a valid API key from developer.clashofclans.com';

  @override
  String get apiErrorPlayerNotFound => 'We couldn\'t find a player with that tag. Check that it\'s typed correctly.';

  @override
  String get apiErrorBadRequest => 'Invalid request. Check the tag and try again.';

  @override
  String get apiErrorUnauthorized => 'Unauthorized. Check your API configuration.';

  @override
  String get apiErrorForbidden => 'Access denied. Check your API key in the .env file.';

  @override
  String get apiErrorRateLimited => 'Too many requests. Wait a moment and try again.';

  @override
  String get apiErrorServer => 'The server is unavailable. Try again later.';

  @override
  String get apiErrorNetwork => 'Connection error. Check your internet.';

  @override
  String get apiErrorUnexpected => 'An unexpected error occurred. Please try again.';

  @override
  String get yourStats => 'Your Statistics';

  @override
  String get seeAll => 'See All';

  @override
  String get compare => 'Compare';

  @override
  String get open => 'Open';

  @override
  String get yourClan => 'Your Clan';

  @override
  String get seeMore => 'See More';

  @override
  String get playerNotInClan => 'This player is not in a clan.';

  @override
  String get categories => 'Categories';

  @override
  String get categoryTroops => 'Troops';

  @override
  String get categoryBuildings => 'Buildings';

  @override
  String get categoryHeroes => 'Heroes';

  @override
  String get categorySpells => 'Spells';

  @override
  String get categoryCollapseHint => 'Tap a header to collapse or expand a section.';

  @override
  String get noTroopsRegistered => 'No troops registered.';

  @override
  String get noSpellsRegistered => 'No spells registered.';

  @override
  String get noBuildingsRegistered => 'No buildings registered.';

  @override
  String get noHeroesOrEquipmentRegistered => 'No heroes or equipment registered.';

  @override
  String get equipment => 'Equipment';

  @override
  String get superTroopActive => 'Super active';

  @override
  String get superTroopActiveBadge => 'SUPER';

  @override
  String get levelPerUnit => 'Level per unit';

  @override
  String get noUnitsToCompare => 'No shared units to compare.';

  @override
  String get troopsInProfile => 'troops in your profile';

  @override
  String get buildingsInVillage => 'buildings in your village';

  @override
  String get heroesAndEquipment => 'heroes and equipment';

  @override
  String get spellsInProfile => 'spells in your profile';

  @override
  String get troopsAndUnits => 'Troops and units';

  @override
  String get troopsLoadError => 'Could not load troops.';

  @override
  String get compareTitle => 'COMPARE';

  @override
  String get compareSelfError => 'You cannot compare with yourself';

  @override
  String get compareRecentSearches => 'Recent searches';

  @override
  String get compareClearRecent => 'Clear';

  @override
  String get compareNoRecentMatches => 'No matches in history';

  @override
  String get opponentDefaultName => 'Opponent';

  @override
  String get versus => 'VS';

  @override
  String get compareTabSummary => 'Summary';

  @override
  String get compareTabStats => 'Statistics';

  @override
  String get compareTabAchievements => 'Achievements';

  @override
  String get compareTabTroops => 'Troops';

  @override
  String get opponentTagHint => 'Opponent tag (#ABC123)';

  @override
  String get search => 'Search';

  @override
  String get compareEnterTagPrompt => 'Enter the opponent\'s tag in the search bar above.';

  @override
  String get clanMates => 'CLAN MATES';

  @override
  String get compareNoClanHint => 'The Supercell API does not expose in-game friends. Without a clan, you can only compare by tag.';

  @override
  String compareClanMatesHint(String clanName) {
    return 'The API does not include in-game friends; here you can compare with members of $clanName.';
  }

  @override
  String clanMateSubtitle(String tag, int th, int trophies) {
    return '$tag · TH$th · $trophies trophies';
  }

  @override
  String get versusSeparator => ' vs ';

  @override
  String get pickOpponent => 'Pick an opponent';

  @override
  String get comparePreviewSubtitle => 'TROOPS · STATISTICS · ACHIEVEMENTS';

  @override
  String get changeOpponent => 'Change opponent';

  @override
  String get currentOpponent => 'Current opponent';

  @override
  String get compareQuickSwitch => 'Rival\'s clan';

  @override
  String get statsTitle => 'STATISTICS';

  @override
  String get stats => 'Statistics';

  @override
  String get warLog => 'War Log';

  @override
  String clanMembersCount(int count) {
    return 'Clan Members ($count)';
  }

  @override
  String get levelTownHall => 'Town Hall Level';

  @override
  String get levelBuilderHall => 'Builder Hall Level';

  @override
  String get levelClanCapital => 'Clan Capital';

  @override
  String get league => 'League';

  @override
  String get contributions => 'Contributions';

  @override
  String levelLabel(int level) {
    return 'Lv. $level';
  }

  @override
  String get troopGroupElixir => 'Elixir';

  @override
  String get troopGroupDarkElixir => 'Dark Elixir';

  @override
  String get troopGroupBuilderBase => 'Builder Base';

  @override
  String get troopGroupSiege => 'Siege Machines';

  @override
  String get troopGroupPets => 'Pets';

  @override
  String get troopGroupOther => 'Other troops';

  @override
  String get spellGroupElixir => 'Elixir';

  @override
  String get spellGroupDarkElixir => 'Dark Elixir';

  @override
  String get spellGroupOther => 'Other spells';

  @override
  String get buildingGroupMain => 'Main';

  @override
  String get buildingGroupDefense => 'Defenses';

  @override
  String get buildingGroupResource => 'Resources';

  @override
  String get buildingGroupArmy => 'Army';

  @override
  String get buildingGroupTraps => 'Traps';

  @override
  String get buildingGroupBuilderBase => 'Builder Base';

  @override
  String get mainTownHall => 'Main Town Hall';

  @override
  String get builderBaseSection => 'Builder Base';

  @override
  String get clanAndDonations => 'Clan & donations';

  @override
  String get legendLeague => 'Legend League';

  @override
  String get trophies => 'Trophies';

  @override
  String get warStars => 'War stars';

  @override
  String get attackWins => 'Attack wins';

  @override
  String get defenseWins => 'Defense wins';

  @override
  String get warPreference => 'War preference';

  @override
  String get donations => 'Donations';

  @override
  String get donationsReceived => 'Received';

  @override
  String get role => 'Role';

  @override
  String get clan => 'Clan';

  @override
  String get townHall => 'Town Hall';

  @override
  String get experience => 'Experience';

  @override
  String get bestRecord => 'Best record';

  @override
  String get legendTrophies => 'Legend trophies';

  @override
  String get currentSeason => 'Current season';

  @override
  String get previousSeason => 'Previous season';

  @override
  String get bestSeason => 'Best season';

  @override
  String get playerLabels => 'Labels';

  @override
  String get equippedEquipment => 'Equipped gear';

  @override
  String get warResultWin => 'Victory';

  @override
  String get warResultLose => 'Defeat';

  @override
  String get warResultTie => 'Draw';

  @override
  String get warLogEmpty => 'No recent wars in the log.';

  @override
  String get warLogLoadError => 'Could not load the war log.';

  @override
  String get capitalRaidsEmpty => 'No recent capital raids.';

  @override
  String get capitalRaidsLoadError => 'Could not load capital raid history.';

  @override
  String get capitalRaidLoot => 'Total loot';

  @override
  String get capitalRaidRaids => 'Raids';

  @override
  String get capitalRaidAttacks => 'Attacks';

  @override
  String get capitalRaidDistricts => 'Enemy districts';

  @override
  String get achievementsHomeVillage => 'Achievements · Home';

  @override
  String get achievementsBuilderVillage => 'Achievements · Builder';

  @override
  String get noHomeAchievements => 'No home village achievements.';

  @override
  String get noBuilderAchievements => 'No builder achievements.';

  @override
  String get homeVillageAchievements => 'Home village achievements';

  @override
  String get builderVillageAchievements => 'Builder achievements';

  @override
  String get trophiesBB => 'BB Trophies';

  @override
  String get leagueBB => 'BB League';

  @override
  String get clanContribution => 'Clan contribution';

  @override
  String get donated => 'Donated';

  @override
  String get received => 'Received';

  @override
  String get clanWarLeague => 'Clan War League';

  @override
  String get totalPoints => 'Total points';

  @override
  String get location => 'Location';

  @override
  String get chatLanguage => 'Chat language';

  @override
  String get clanType => 'Type';

  @override
  String get familyFriendly => 'Family friendly';

  @override
  String get familyFriendlyYes => 'Yes';

  @override
  String get familyFriendlyNo => 'No';

  @override
  String get playerHouse => 'Player house';

  @override
  String get playerHouseEmpty => 'No house pieces configured.';

  @override
  String get houseTypeGround => 'Ground';

  @override
  String get houseTypeRoof => 'Roof';

  @override
  String get houseTypeWalls => 'Walls';

  @override
  String get houseTypeDecoration => 'Decoration';

  @override
  String get houseTypeFoot => 'Foot';

  @override
  String get houseTypeUnknown => 'Piece';

  @override
  String houseElementId(int id) {
    return 'ID $id';
  }

  @override
  String get requiredTrophies => 'Required trophies';

  @override
  String get requiredTownHall => 'Required Town Hall';

  @override
  String get wins => 'Wins';

  @override
  String get ties => 'Ties';

  @override
  String get losses => 'Losses';

  @override
  String get winStreak => 'Streak';

  @override
  String get unitCategoryTroop => 'Troop';

  @override
  String get unitCategoryHero => 'Hero';

  @override
  String get unitCategorySpell => 'Spell';

  @override
  String get unitCategoryEquipment => 'Equipment';

  @override
  String get unitCategoryBuilding => 'Building';

  @override
  String get locked => 'Locked';

  @override
  String get maxLevel => 'Max level';

  @override
  String get currentLevel => 'Current level';

  @override
  String get globalMax => 'Global max';

  @override
  String get yourTownHall => 'Your Town Hall';

  @override
  String get maxInVillage => 'Max in your village';

  @override
  String get unlockAt => 'Unlock';

  @override
  String get totalLevels => 'Total levels';

  @override
  String get level => 'Level';

  @override
  String get maximum => 'Maximum';

  @override
  String get villageLabel => 'Village';

  @override
  String get health => 'Hitpoints';

  @override
  String get housingSpace => 'Space';

  @override
  String get compareCompleted => 'Completed';

  @override
  String get starsEarned => 'Stars earned';

  @override
  String get yourProgress => 'Your progress';

  @override
  String get rival => 'Rival';

  @override
  String get you => 'You';

  @override
  String get unlocked => 'Unlocked';

  @override
  String headToHeadCount(int count) {
    return 'Head to head ($count)';
  }

  @override
  String get levelPerTroop => 'Level per troop';

  @override
  String get noSharedTroops => 'No shared troops to compare.';

  @override
  String get comparativeProfile => 'COMPARATIVE PROFILE';

  @override
  String tiesCount(int count) {
    return '$count ties';
  }

  @override
  String winsCount(int count) {
    return '$count wins';
  }

  @override
  String get whereYouLead => 'WHERE YOU LEAD';

  @override
  String get whereTheyLead => 'WHERE THEY LEAD';

  @override
  String get noClearAdvantages => 'No clear advantages in this comparison.';

  @override
  String get compareGroupTownHall => 'Town Hall';

  @override
  String get compareGroupBuilder => 'Builder';

  @override
  String get compareGroupClan => 'Clan';

  @override
  String get unitDetailStatus => 'Status';

  @override
  String get unitDetailStats => 'Statistics';

  @override
  String get unitDetailProgress => 'Progress';

  @override
  String get unitDetailHighlights => 'Highlights';

  @override
  String get unitDetailDescription => 'Description';

  @override
  String get unitDetailContext => 'Context in your village';

  @override
  String get searchClanQueryHint => 'Name or tag with # (e.g. #2GQYGPLOC)';

  @override
  String get comparePlayersPromo => 'COMPARE PLAYERS';

  @override
  String get comparePlayersSubtitle => 'Statistics, charts and achievements head to head.';

  @override
  String get warPreferenceIn => 'In war';

  @override
  String get warPreferenceOut => 'Out of war';

  @override
  String townHallBanner(int level, String suffix) {
    return 'TOWN HALL $level$suffix';
  }

  @override
  String experienceLevelLine(int level) {
    return 'Experience level $level';
  }

  @override
  String warFrequencyLabel(String frequency) {
    return 'War frequency: $frequency';
  }

  @override
  String get searchClansField => 'Search clans';

  @override
  String get searchClanNoResults => 'No clans found';

  @override
  String get rankInClan => 'CLAN RANKING';

  @override
  String clanPosition(int rank) {
    return 'Position #$rank';
  }

  @override
  String get noRankChange => 'No change';

  @override
  String get donationActivityNone => 'No donation activity this season.';

  @override
  String donationBalance(int donatePct, int receivePct) {
    return 'Balance $donatePct% donated · $receivePct% received';
  }

  @override
  String get compareStatsTitle => 'Compare statistics';

  @override
  String get compareStatsSubtitle => 'Charts, achievements and troops head to head.';

  @override
  String get donationsShort => 'Don.';

  @override
  String get receivedShort => 'Rec.';

  @override
  String get completed => 'Completed';

  @override
  String totalAvailable(int you, int them) {
    return 'Total available: $you vs $them';
  }

  @override
  String maximumVs(int you, int them) {
    return 'Maximum: $you vs $them';
  }

  @override
  String get warLogTabCapital => 'Capital';

  @override
  String get warLogPrivateHint => 'Detailed war history is private in this clan.';

  @override
  String get warLeagueLabel => 'War league';

  @override
  String get warFrequencyShort => 'Frequency';

  @override
  String get winStreakLabel => 'Win streak';

  @override
  String get totalWarsLabel => 'Total wars';

  @override
  String get winRateLabel => 'Win rate';

  @override
  String get builderPointsLabel => 'Builder points';

  @override
  String get requiredTrophiesLabel => 'Required trophies';

  @override
  String get membersLabel => 'Members';

  @override
  String get builderWarComingSoon => 'Builder base war details will be available soon.';

  @override
  String get capitalPointsLabel => 'Capital points';

  @override
  String get capitalLeagueLabel => 'Capital league';

  @override
  String get capitalHallLevelLabel => 'Capital Hall level';

  @override
  String get capitalDistrictsLabel => 'Districts';

  @override
  String get clanLevelLabel => 'Clan level';

  @override
  String get capitalRaidsComingSoon => 'Capital raid history will be available soon.';

  @override
  String get warLogPrivateFooter => 'Individual wars are not visible because the log is private.';

  @override
  String get unlockedStatus => 'Unlocked';

  @override
  String get availableInVillage => 'Available in your village';

  @override
  String get notYetAvailable => 'Not yet available';

  @override
  String levelInProfile(int current, int max) {
    return 'Level $current of $max in your profile.';
  }

  @override
  String canUpgradeToLevel(int hall, int max) {
    return 'With Town Hall $hall you can upgrade it to level $max.';
  }

  @override
  String unlocksAtTownHall(int level) {
    return 'Unlocks at Town Hall level $level.';
  }

  @override
  String categoryPrefix(String name) {
    return 'Category: $name';
  }

  @override
  String get maxLevelReachedHeadline => 'Max level reached';

  @override
  String get inProgressHeadline => 'In progress';

  @override
  String get notUnlockedHeadline => 'Not unlocked';

  @override
  String get allUpgradesCompleted => 'You have completed all upgrades available in the API.';

  @override
  String levelsToMax(int remaining, int max) {
    return '$remaining levels remaining to max ($max).';
  }

  @override
  String get researchWhenUnlocked => 'Research in the laboratory once you unlock this unit.';

  @override
  String get damagePerSec => 'Damage/s';

  @override
  String get healPerSec => 'Healing/s';

  @override
  String nextUpgradeLab(int level) {
    return 'Next upgrade requires lab level $level';
  }

  @override
  String estimatedCost(String cost) {
    return 'Estimated cost: $cost';
  }

  @override
  String resourceHighlight(String resource) {
    return 'Resource: $resource';
  }

  @override
  String levelOfMaxShort(int current, int max) {
    return 'Level $current of $max.';
  }

  @override
  String get unitNotUnlocked => 'This unit is not unlocked yet.';

  @override
  String availableAtCurrentTH(int level) {
    return 'Available with your current Town Hall (TH $level).';
  }

  @override
  String requiresTownHallLevel(int level) {
    return 'Requires Town Hall level $level.';
  }

  @override
  String levelSlashMax(int current, int max) {
    return 'Level $current / $max';
  }

  @override
  String get maxLevelReachedMessage => 'You have reached max level.';

  @override
  String levelsRemainingMessage(int count) {
    return '$count levels remaining to complete.';
  }

  @override
  String upToLevel(int level) {
    return 'Up to lv. $level';
  }

  @override
  String get available => 'Available';

  @override
  String requiresTownHallShort(int level) {
    return 'TH $level+';
  }

  @override
  String get villageHomeShort => 'Main';

  @override
  String get warLogTabHome => 'Town Hall';

  @override
  String get warLogTabBuilder => 'Builder';

  @override
  String get roleLeader => 'Leader';

  @override
  String get roleCoLeader => 'Co-Leader';

  @override
  String get roleElder => 'Elder';

  @override
  String get roleMember => 'Member';

  @override
  String get unitDetailDetails => 'DETAILS';

  @override
  String townHallShort(int level) {
    return 'TH $level';
  }
}
