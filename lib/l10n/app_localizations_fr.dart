// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Clash Companion';

  @override
  String get language => 'Langue';

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
  String get navHome => 'Accueil';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get searchClanPlaceholder => 'Rechercher un clan';

  @override
  String get welcomeSignUpOrLogin => 'S\'inscrire ou Se connecter';

  @override
  String get welcomeGreeting => 'Bienvenue, ';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginNoAccountPrompt => 'Vous n\'avez pas de compte ?';

  @override
  String get loginCreateAccountAction => 'Créez-en un maintenant !';

  @override
  String get signUpTitle => 'Inscription';

  @override
  String get signUpHasAccountPrompt => 'Vous avez déjà un compte ?';

  @override
  String get signUpLoginAction => 'Connectez-vous !';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get passwordPlaceholder => 'Mot de passe';

  @override
  String get namePlaceholder => 'Nom';

  @override
  String get signInButton => 'Se connecter';

  @override
  String get termsAndConditions => 'Conditions générales d\'utilisation';

  @override
  String get googleSignIn => 'Se connecter avec Google';

  @override
  String get retry => 'Réessayer';

  @override
  String get playerErrorForbiddenHint => 'Si vous voyez \"Forbidden\", mettez à jour COC_KEY dans le fichier .env avec une clé API valide de developer.clashofclans.com';

  @override
  String get yourStats => 'Vos Statistiques';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get compare => 'Comparer';

  @override
  String get open => 'Ouvrir';

  @override
  String get yourClan => 'Votre Clan';

  @override
  String get seeMore => 'Voir plus';

  @override
  String get playerNotInClan => 'Ce joueur n\'est pas dans un clan.';

  @override
  String get categories => 'Catégories';

  @override
  String get categoryTroops => 'Troupes';

  @override
  String get categoryBuildings => 'Bâtiments';

  @override
  String get categoryHeroes => 'Héros';

  @override
  String get categorySpells => 'Sorts';

  @override
  String get categoryCollapseHint => 'Appuyez sur un en-tête pour réduire ou développer une section.';

  @override
  String get noTroopsRegistered => 'Aucune troupe enregistrée.';

  @override
  String get noSpellsRegistered => 'Aucun sort enregistré.';

  @override
  String get noBuildingsRegistered => 'Aucun bâtiment enregistré.';

  @override
  String get noHeroesOrEquipmentRegistered => 'Aucun héros ni équipement enregistré.';

  @override
  String get equipment => 'Équipement';

  @override
  String get troopsInProfile => 'troupes dans votre profil';

  @override
  String get buildingsInVillage => 'bâtiments dans votre village';

  @override
  String get heroesAndEquipment => 'héros et équipement';

  @override
  String get spellsInProfile => 'sorts dans votre profil';

  @override
  String get troopsAndUnits => 'Troupes et unités';

  @override
  String get troopsLoadError => 'Impossible de charger les troupes.';

  @override
  String get compareTitle => 'COMPARER';

  @override
  String get compareSelfError => 'Vous ne pouvez pas vous comparer à vous-même';

  @override
  String get opponentDefaultName => 'Rival';

  @override
  String get versus => 'VS';

  @override
  String get compareTabSummary => 'Résumé';

  @override
  String get compareTabStats => 'Statistiques';

  @override
  String get compareTabAchievements => 'Succès';

  @override
  String get compareTabTroops => 'Troupes';

  @override
  String get opponentTagHint => 'Tag du rival (#ABC123)';

  @override
  String get search => 'Rechercher';

  @override
  String get compareEnterTagPrompt => 'Saisissez le tag du rival dans la barre de recherche ci-dessus.';

  @override
  String get clanMates => 'CAMARADES DE CLAN';

  @override
  String get compareNoClanHint => 'L\'API Supercell n\'expose pas la liste d\'amis du jeu. Sans clan, vous ne pouvez comparer que par tag.';

  @override
  String compareClanMatesHint(String clanName) {
    return 'L\'API n\'inclut pas les amis du jeu ; ici vous pouvez comparer avec les membres de $clanName.';
  }

  @override
  String clanMateSubtitle(String tag, int th, int trophies) {
    return '$tag · TH$th · $trophies trophées';
  }

  @override
  String get versusSeparator => ' vs ';

  @override
  String get pickOpponent => 'Choisissez un rival';

  @override
  String get comparePreviewSubtitle => 'TROUPES · STATISTIQUES · SUCCÈS';

  @override
  String get changeOpponent => 'Changer de rival';

  @override
  String get currentOpponent => 'Rival actuel';

  @override
  String get compareQuickSwitch => 'Clan du rival';

  @override
  String get statsTitle => 'STATISTIQUES';

  @override
  String get stats => 'Statistiques';

  @override
  String get warLog => 'Journal de guerre';

  @override
  String clanMembersCount(int count) {
    return 'Membres du clan ($count)';
  }

  @override
  String get levelTownHall => 'Niveau de l\'hôtel de ville';

  @override
  String get levelBuilderHall => 'Niveau de la base ouvrier';

  @override
  String get levelClanCapital => 'Capitale du clan';

  @override
  String get league => 'Ligue';

  @override
  String get contributions => 'Contributions';

  @override
  String levelLabel(int level) {
    return 'Nv. $level';
  }

  @override
  String get troopGroupElixir => 'Élixir';

  @override
  String get troopGroupDarkElixir => 'Élixir noir';

  @override
  String get troopGroupBuilderBase => 'Base ouvrier';

  @override
  String get troopGroupSiege => 'Machines de siège';

  @override
  String get troopGroupPets => 'Animaux';

  @override
  String get troopGroupOther => 'Autres troupes';

  @override
  String get spellGroupElixir => 'Élixir';

  @override
  String get spellGroupDarkElixir => 'Élixir noir';

  @override
  String get spellGroupOther => 'Autres sorts';

  @override
  String get buildingGroupMain => 'Principaux';

  @override
  String get buildingGroupDefense => 'Défenses';

  @override
  String get buildingGroupResource => 'Ressources';

  @override
  String get buildingGroupArmy => 'Armée';

  @override
  String get buildingGroupTraps => 'Pièges';

  @override
  String get buildingGroupBuilderBase => 'Base ouvrier';

  @override
  String get mainTownHall => 'Hôtel de ville principal';

  @override
  String get builderBaseSection => 'Base ouvrier';

  @override
  String get clanAndDonations => 'Clan et dons';

  @override
  String get legendLeague => 'Ligue légende';

  @override
  String get trophies => 'Trophées';

  @override
  String get warStars => 'Étoiles de guerre';

  @override
  String get attackWins => 'Victoires d\'attaque';

  @override
  String get defenseWins => 'Victoires de défense';

  @override
  String get warPreference => 'Préférence de guerre';

  @override
  String get donations => 'Dons';

  @override
  String get donationsReceived => 'Reçus';

  @override
  String get role => 'Rôle';

  @override
  String get clan => 'Clan';

  @override
  String get townHall => 'Hôtel de ville';

  @override
  String get experience => 'Expérience';

  @override
  String get bestRecord => 'Meilleur record';

  @override
  String get legendTrophies => 'Trophées légende';

  @override
  String get currentSeason => 'Saison actuelle';

  @override
  String get bestSeason => 'Meilleure saison';

  @override
  String get achievementsHomeVillage => 'Succès · Village';

  @override
  String get achievementsBuilderVillage => 'Succès · Ouvrier';

  @override
  String get noHomeAchievements => 'Aucun succès du village principal.';

  @override
  String get noBuilderAchievements => 'Aucun succès ouvrier.';

  @override
  String get homeVillageAchievements => 'Succès du village principal';

  @override
  String get builderVillageAchievements => 'Succès ouvrier';

  @override
  String get trophiesBB => 'Trophées BO';

  @override
  String get leagueBB => 'Ligue BO';

  @override
  String get clanContribution => 'Contribution au clan';

  @override
  String get donated => 'Donnés';

  @override
  String get received => 'Reçus';

  @override
  String get clanWarLeague => 'Ligue de guerre de clans';

  @override
  String get totalPoints => 'Points totaux';

  @override
  String get location => 'Emplacement';

  @override
  String get chatLanguage => 'Langue du chat';

  @override
  String get clanType => 'Type';

  @override
  String get requiredTrophies => 'Trophées requis';

  @override
  String get requiredTownHall => 'HDV requis';

  @override
  String get wins => 'Victoires';

  @override
  String get ties => 'Égalités';

  @override
  String get losses => 'Défaites';

  @override
  String get winStreak => 'Série';

  @override
  String get unitCategoryTroop => 'Troupe';

  @override
  String get unitCategoryHero => 'Héros';

  @override
  String get unitCategorySpell => 'Sort';

  @override
  String get unitCategoryEquipment => 'Équipement';

  @override
  String get unitCategoryBuilding => 'Bâtiment';

  @override
  String get locked => 'Verrouillé';

  @override
  String get maxLevel => 'Niveau max';

  @override
  String get currentLevel => 'Niveau actuel';

  @override
  String get globalMax => 'Max global';

  @override
  String get yourTownHall => 'Votre HDV';

  @override
  String get maxInVillage => 'Max dans votre village';

  @override
  String get unlockAt => 'Déblocage';

  @override
  String get totalLevels => 'Niveaux totaux';

  @override
  String get level => 'Niveau';

  @override
  String get maximum => 'Maximum';

  @override
  String get villageLabel => 'Village';

  @override
  String get health => 'Points de vie';

  @override
  String get housingSpace => 'Espace';

  @override
  String get compareCompleted => 'Terminés';

  @override
  String get starsEarned => 'Étoiles gagnées';

  @override
  String get yourProgress => 'Votre progrès';

  @override
  String get rival => 'Rival';

  @override
  String get you => 'Vous';

  @override
  String get unlocked => 'Débloquées';

  @override
  String headToHeadCount(int count) {
    return 'Face à face ($count)';
  }

  @override
  String get levelPerTroop => 'Niveau par troupe';

  @override
  String get noSharedTroops => 'Aucune troupe commune à comparer.';

  @override
  String get comparativeProfile => 'PROFIL COMPARATIF';

  @override
  String tiesCount(int count) {
    return '$count égalités';
  }

  @override
  String winsCount(int count) {
    return '$count victoires';
  }

  @override
  String get whereYouLead => 'OÙ VOUS MENEZ';

  @override
  String get whereTheyLead => 'OÙ IL MÈNE';

  @override
  String get noClearAdvantages => 'Pas d\'avantage clair dans cette comparaison.';

  @override
  String get compareGroupTownHall => 'HDV';

  @override
  String get compareGroupBuilder => 'Ouvrier';

  @override
  String get compareGroupClan => 'Clan';

  @override
  String get unitDetailStatus => 'Statut';

  @override
  String get unitDetailStats => 'Statistiques';

  @override
  String get unitDetailProgress => 'Progrès';

  @override
  String get unitDetailHighlights => 'Points clés';

  @override
  String get unitDetailDescription => 'Description';

  @override
  String get unitDetailContext => 'Contexte dans votre village';

  @override
  String get searchClanQueryHint => 'Nom ou tag du clan';

  @override
  String get comparePlayersPromo => 'COMPARER LES JOUEURS';

  @override
  String get comparePlayersSubtitle => 'Statistiques, graphiques et succès face à face.';

  @override
  String get warPreferenceIn => 'En guerre';

  @override
  String get warPreferenceOut => 'Hors guerre';

  @override
  String townHallBanner(int level, String suffix) {
    return 'HDV $level$suffix';
  }

  @override
  String experienceLevelLine(int level) {
    return 'Niveau d\'expérience $level';
  }

  @override
  String warFrequencyLabel(String frequency) {
    return 'Fréquence de guerre : $frequency';
  }

  @override
  String get searchClansField => 'Rechercher des clans';

  @override
  String get searchClanNoResults => 'Aucun clan trouvé';

  @override
  String get rankInClan => 'CLASSEMENT DU CLAN';

  @override
  String clanPosition(int rank) {
    return 'Position #$rank';
  }

  @override
  String get noRankChange => 'Aucun changement';

  @override
  String get donationActivityNone => 'Aucune activité de dons cette saison.';

  @override
  String donationBalance(int donatePct, int receivePct) {
    return 'Solde $donatePct% dons · $receivePct% reçus';
  }

  @override
  String get compareStatsTitle => 'Comparer les statistiques';

  @override
  String get compareStatsSubtitle => 'Graphiques, succès et troupes face à face.';

  @override
  String get donationsShort => 'Don.';

  @override
  String get receivedShort => 'Reç.';

  @override
  String get completed => 'Terminé';

  @override
  String totalAvailable(int you, int them) {
    return 'Total disponible : $you vs $them';
  }

  @override
  String maximumVs(int you, int them) {
    return 'Maximum : $you vs $them';
  }

  @override
  String get warLogTabCapital => 'Capitale';

  @override
  String get warLogPrivateHint => 'L\'historique détaillé des guerres est privé dans ce clan.';

  @override
  String get warLeagueLabel => 'Ligue de guerre';

  @override
  String get warFrequencyShort => 'Fréquence';

  @override
  String get winStreakLabel => 'Série de victoires';

  @override
  String get totalWarsLabel => 'Total de guerres';

  @override
  String get winRateLabel => 'Taux de victoire';

  @override
  String get builderPointsLabel => 'Points ouvrier';

  @override
  String get requiredTrophiesLabel => 'Trophées requis';

  @override
  String get membersLabel => 'Membres';

  @override
  String get builderWarComingSoon => 'Détails des guerres ouvrier bientôt disponibles.';

  @override
  String get capitalPointsLabel => 'Points capitale';

  @override
  String get capitalLeagueLabel => 'Ligue capitale';

  @override
  String get clanLevelLabel => 'Niveau du clan';

  @override
  String get capitalRaidsComingSoon => 'Historique des raids capitale bientôt disponible.';

  @override
  String get warLogPrivateFooter => 'Les guerres individuelles ne sont pas visibles car le journal est privé.';

  @override
  String get unlockedStatus => 'Débloqué';

  @override
  String get availableInVillage => 'Disponible dans votre village';

  @override
  String get notYetAvailable => 'Pas encore disponible';

  @override
  String levelInProfile(int current, int max) {
    return 'Niveau $current sur $max dans votre profil.';
  }

  @override
  String canUpgradeToLevel(int hall, int max) {
    return 'Avec HDV $hall vous pouvez monter jusqu\'au niveau $max.';
  }

  @override
  String unlocksAtTownHall(int level) {
    return 'Se débloque avec HDV niveau $level.';
  }

  @override
  String categoryPrefix(String name) {
    return 'Catégorie : $name';
  }

  @override
  String get maxLevelReachedHeadline => 'Niveau maximum atteint';

  @override
  String get inProgressHeadline => 'En cours';

  @override
  String get notUnlockedHeadline => 'Non débloqué';

  @override
  String get allUpgradesCompleted => 'Vous avez terminé toutes les améliorations disponibles dans l\'API.';

  @override
  String levelsToMax(int remaining, int max) {
    return 'Il reste $remaining niveaux pour le maximum ($max).';
  }

  @override
  String get researchWhenUnlocked => 'Recherchez au laboratoire une fois cette unité débloquée.';

  @override
  String get damagePerSec => 'Dégâts/s';

  @override
  String get healPerSec => 'Soins/s';

  @override
  String nextUpgradeLab(int level) {
    return 'Prochaine amélioration : laboratoire nv. $level';
  }

  @override
  String estimatedCost(String cost) {
    return 'Coût estimé : $cost';
  }

  @override
  String resourceHighlight(String resource) {
    return 'Ressource : $resource';
  }

  @override
  String levelOfMaxShort(int current, int max) {
    return 'Niveau $current sur $max.';
  }

  @override
  String get unitNotUnlocked => 'Cette unité n\'est pas encore débloquée.';

  @override
  String availableAtCurrentTH(int level) {
    return 'Disponible avec votre HDV actuel (TH $level).';
  }

  @override
  String requiresTownHallLevel(int level) {
    return 'Requiert HDV niveau $level.';
  }

  @override
  String levelSlashMax(int current, int max) {
    return 'Niveau $current / $max';
  }

  @override
  String get maxLevelReachedMessage => 'Vous avez atteint le niveau maximum.';

  @override
  String levelsRemainingMessage(int count) {
    return 'Il reste $count niveaux à compléter.';
  }

  @override
  String upToLevel(int level) {
    return 'Jusqu\'au nv. $level';
  }

  @override
  String get available => 'Disponible';

  @override
  String requiresTownHallShort(int level) {
    return 'TH $level+';
  }

  @override
  String get villageHomeShort => 'Principal';

  @override
  String get warLogTabHome => 'HDV';

  @override
  String get warLogTabBuilder => 'Ouvrier';

  @override
  String get roleLeader => 'Chef';

  @override
  String get roleCoLeader => 'Co-chef';

  @override
  String get roleElder => 'Aîné';

  @override
  String get roleMember => 'Membre';

  @override
  String get unitDetailDetails => 'DÉTAILS';

  @override
  String townHallShort(int level) {
    return 'TH $level';
  }
}
