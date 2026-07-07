// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Clash Companion';

  @override
  String get language => 'Lingua';

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
  String get navProfile => 'Profilo';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get searchClanPlaceholder => 'Cerca clan';

  @override
  String get welcomeSignUpOrLogin => 'Registrati o Accedi';

  @override
  String get welcomeGreeting => 'Benvenuto, ';

  @override
  String get loginTitle => 'Accedi';

  @override
  String get loginNoAccountPrompt => 'Non hai un account?';

  @override
  String get loginCreateAccountAction => 'Creane uno ora!';

  @override
  String get signUpTitle => 'Registrati';

  @override
  String get signUpHasAccountPrompt => 'Hai già un account?';

  @override
  String get signUpLoginAction => 'Accedi ora!';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get passwordPlaceholder => 'Password';

  @override
  String get namePlaceholder => 'Nome';

  @override
  String get signInButton => 'Accedi';

  @override
  String get termsAndConditions => 'Termini e condizioni d\'uso';

  @override
  String get googleSignIn => 'Accedi con Google';

  @override
  String get retry => 'Riprova';

  @override
  String get playerErrorForbiddenHint => 'Se vedi \"Forbidden\", aggiorna COC_KEY nel file .env con una chiave API valida da developer.clashofclans.com';

  @override
  String get yourStats => 'Le Tue Statistiche';

  @override
  String get seeAll => 'Vedi tutte';

  @override
  String get compare => 'Confronta';

  @override
  String get open => 'Apri';

  @override
  String get yourClan => 'Il Tuo Clan';

  @override
  String get seeMore => 'Vedi altro';

  @override
  String get playerNotInClan => 'Questo giocatore non è in un clan.';

  @override
  String get categories => 'Categorie';

  @override
  String get categoryTroops => 'Truppe';

  @override
  String get categoryBuildings => 'Edifici';

  @override
  String get categoryHeroes => 'Eroi';

  @override
  String get categorySpells => 'Incantesimi';

  @override
  String get categoryCollapseHint => 'Tocca un\'intestazione per comprimere o espandere una sezione.';

  @override
  String get noTroopsRegistered => 'Nessuna truppa registrata.';

  @override
  String get noSpellsRegistered => 'Nessun incantesimo registrato.';

  @override
  String get noBuildingsRegistered => 'Nessun edificio registrato.';

  @override
  String get noHeroesOrEquipmentRegistered => 'Nessun eroe o equipaggiamento registrato.';

  @override
  String get equipment => 'Equipaggiamento';

  @override
  String get troopsInProfile => 'truppe nel tuo profilo';

  @override
  String get buildingsInVillage => 'edifici nel tuo villaggio';

  @override
  String get heroesAndEquipment => 'eroi e equipaggiamento';

  @override
  String get spellsInProfile => 'incantesimi nel tuo profilo';

  @override
  String get troopsAndUnits => 'Truppe e unità';

  @override
  String get troopsLoadError => 'Impossibile caricare le truppe.';

  @override
  String get compareTitle => 'CONFRONTA';

  @override
  String get compareSelfError => 'Non puoi confrontarti con te stesso';

  @override
  String get opponentDefaultName => 'Rivale';

  @override
  String get versus => 'VS';

  @override
  String get compareTabSummary => 'Riepilogo';

  @override
  String get compareTabStats => 'Statistiche';

  @override
  String get compareTabAchievements => 'Traguardi';

  @override
  String get compareTabTroops => 'Truppe';

  @override
  String get opponentTagHint => 'Tag del rivale (#ABC123)';

  @override
  String get search => 'Cerca';

  @override
  String get compareEnterTagPrompt => 'Inserisci il tag del rivale nella barra di ricerca sopra.';

  @override
  String get clanMates => 'COMPAGNI DI CLAN';

  @override
  String get compareNoClanHint => 'L\'API Supercell non espone la lista amici del gioco. Senza clan, puoi confrontare solo per tag.';

  @override
  String compareClanMatesHint(String clanName) {
    return 'L\'API non include gli amici del gioco; qui puoi confrontarti con i membri di $clanName.';
  }

  @override
  String clanMateSubtitle(String tag, int th, int trophies) {
    return '$tag · TH$th · $trophies trofei';
  }

  @override
  String get versusSeparator => ' vs ';

  @override
  String get pickOpponent => 'Scegli un rivale';

  @override
  String get comparePreviewSubtitle => 'TRUPPE · STATISTICHE · TRAGUARDI';

  @override
  String get changeOpponent => 'Cambia rivale';

  @override
  String get currentOpponent => 'Rivale attuale';

  @override
  String get compareQuickSwitch => 'Clan del rivale';

  @override
  String get statsTitle => 'STATISTICHE';

  @override
  String get stats => 'Statistiche';

  @override
  String get warLog => 'Registro guerre';

  @override
  String clanMembersCount(int count) {
    return 'Membri del clan ($count)';
  }

  @override
  String get levelTownHall => 'Livello municipio';

  @override
  String get levelBuilderHall => 'Livello base costruttore';

  @override
  String get levelClanCapital => 'Capitale del clan';

  @override
  String get league => 'Lega';

  @override
  String get contributions => 'Contributi';

  @override
  String levelLabel(int level) {
    return 'Lv. $level';
  }

  @override
  String get troopGroupElixir => 'Elixir';

  @override
  String get troopGroupDarkElixir => 'Elixir nero';

  @override
  String get troopGroupBuilderBase => 'Base costruttore';

  @override
  String get troopGroupSiege => 'Macchine d\'assedio';

  @override
  String get troopGroupPets => 'Animali';

  @override
  String get troopGroupOther => 'Altre truppe';

  @override
  String get spellGroupElixir => 'Elixir';

  @override
  String get spellGroupDarkElixir => 'Elixir nero';

  @override
  String get spellGroupOther => 'Altri incantesimi';

  @override
  String get buildingGroupMain => 'Principali';

  @override
  String get buildingGroupDefense => 'Difese';

  @override
  String get buildingGroupResource => 'Risorse';

  @override
  String get buildingGroupArmy => 'Esercito';

  @override
  String get buildingGroupTraps => 'Trappole';

  @override
  String get buildingGroupBuilderBase => 'Base costruttore';

  @override
  String get mainTownHall => 'Municipio principale';

  @override
  String get builderBaseSection => 'Base costruttore';

  @override
  String get clanAndDonations => 'Clan e donazioni';

  @override
  String get legendLeague => 'Lega leggenda';

  @override
  String get trophies => 'Trofei';

  @override
  String get warStars => 'Stelle guerra';

  @override
  String get attackWins => 'Vittorie attacco';

  @override
  String get defenseWins => 'Vittorie difesa';

  @override
  String get warPreference => 'Preferenza guerra';

  @override
  String get donations => 'Donazioni';

  @override
  String get donationsReceived => 'Ricevute';

  @override
  String get role => 'Ruolo';

  @override
  String get clan => 'Clan';

  @override
  String get townHall => 'Municipio';

  @override
  String get experience => 'Esperienza';

  @override
  String get bestRecord => 'Miglior record';

  @override
  String get legendTrophies => 'Trofei leggenda';

  @override
  String get currentSeason => 'Stagione attuale';

  @override
  String get bestSeason => 'Miglior stagione';

  @override
  String get achievementsHomeVillage => 'Traguardi · Principale';

  @override
  String get achievementsBuilderVillage => 'Traguardi · Costruttore';

  @override
  String get noHomeAchievements => 'Nessun traguardo del villaggio principale.';

  @override
  String get noBuilderAchievements => 'Nessun traguardo costruttore.';

  @override
  String get homeVillageAchievements => 'Traguardi villaggio principale';

  @override
  String get builderVillageAchievements => 'Traguardi costruttore';

  @override
  String get trophiesBB => 'Trofei BC';

  @override
  String get leagueBB => 'Lega BC';

  @override
  String get clanContribution => 'Contributo al clan';

  @override
  String get donated => 'Donate';

  @override
  String get received => 'Ricevute';

  @override
  String get clanWarLeague => 'Lega guerra clan';

  @override
  String get totalPoints => 'Punti totali';

  @override
  String get location => 'Posizione';

  @override
  String get chatLanguage => 'Lingua chat';

  @override
  String get clanType => 'Tipo';

  @override
  String get requiredTrophies => 'Trofei richiesti';

  @override
  String get requiredTownHall => 'Municipio richiesto';

  @override
  String get wins => 'Vittorie';

  @override
  String get ties => 'Pareggi';

  @override
  String get losses => 'Sconfitte';

  @override
  String get winStreak => 'Serie';

  @override
  String get unitCategoryTroop => 'Truppa';

  @override
  String get unitCategoryHero => 'Eroe';

  @override
  String get unitCategorySpell => 'Incantesimo';

  @override
  String get unitCategoryEquipment => 'Equipaggiamento';

  @override
  String get unitCategoryBuilding => 'Edificio';

  @override
  String get locked => 'Bloccato';

  @override
  String get maxLevel => 'Livello max';

  @override
  String get currentLevel => 'Livello attuale';

  @override
  String get globalMax => 'Max globale';

  @override
  String get yourTownHall => 'Il tuo municipio';

  @override
  String get maxInVillage => 'Max nel tuo villaggio';

  @override
  String get unlockAt => 'Sblocco';

  @override
  String get totalLevels => 'Livelli totali';

  @override
  String get level => 'Livello';

  @override
  String get maximum => 'Massimo';

  @override
  String get villageLabel => 'Villaggio';

  @override
  String get health => 'Punti ferita';

  @override
  String get housingSpace => 'Spazio';

  @override
  String get compareCompleted => 'Completati';

  @override
  String get starsEarned => 'Stelle guadagnate';

  @override
  String get yourProgress => 'Il tuo progresso';

  @override
  String get rival => 'Rivale';

  @override
  String get you => 'Tu';

  @override
  String get unlocked => 'Sbloccate';

  @override
  String headToHeadCount(int count) {
    return 'Testa a testa ($count)';
  }

  @override
  String get levelPerTroop => 'Livello per truppa';

  @override
  String get noSharedTroops => 'Nessuna truppa in comune da confrontare.';

  @override
  String get comparativeProfile => 'PROFILO COMPARATIVO';

  @override
  String tiesCount(int count) {
    return '$count pareggi';
  }

  @override
  String winsCount(int count) {
    return '$count vittorie';
  }

  @override
  String get whereYouLead => 'DOVE SEI AVANTI';

  @override
  String get whereTheyLead => 'DOVE È AVANTI';

  @override
  String get noClearAdvantages => 'Nessun vantaggio chiaro in questo confronto.';

  @override
  String get compareGroupTownHall => 'Municipio';

  @override
  String get compareGroupBuilder => 'Costruttore';

  @override
  String get compareGroupClan => 'Clan';

  @override
  String get unitDetailStatus => 'Stato';

  @override
  String get unitDetailStats => 'Statistiche';

  @override
  String get unitDetailProgress => 'Progresso';

  @override
  String get unitDetailHighlights => 'In evidenza';

  @override
  String get unitDetailDescription => 'Descrizione';

  @override
  String get unitDetailContext => 'Contesto nel tuo villaggio';

  @override
  String get searchClanQueryHint => 'Nome o tag del clan';

  @override
  String get comparePlayersPromo => 'CONFRONTA GIOCATORI';

  @override
  String get comparePlayersSubtitle => 'Statistiche, grafici e obiettivi testa a testa.';

  @override
  String get warPreferenceIn => 'In guerra';

  @override
  String get warPreferenceOut => 'Fuori guerra';

  @override
  String townHallBanner(int level, String suffix) {
    return 'MUNICIPIO $level$suffix';
  }

  @override
  String experienceLevelLine(int level) {
    return 'Livello esperienza $level';
  }

  @override
  String warFrequencyLabel(String frequency) {
    return 'Frequenza guerra: $frequency';
  }

  @override
  String get searchClansField => 'Cerca clan';

  @override
  String get searchClanNoResults => 'Nessun clan trovato';

  @override
  String get rankInClan => 'CLASSIFICA CLAN';

  @override
  String clanPosition(int rank) {
    return 'Posizione #$rank';
  }

  @override
  String get noRankChange => 'Nessun cambiamento';

  @override
  String get donationActivityNone => 'Nessuna attività di donazioni questa stagione.';

  @override
  String donationBalance(int donatePct, int receivePct) {
    return 'Bilancio $donatePct% donazioni · $receivePct% ricevute';
  }

  @override
  String get compareStatsTitle => 'Confronta statistiche';

  @override
  String get compareStatsSubtitle => 'Grafici, obiettivi e truppe testa a testa.';

  @override
  String get donationsShort => 'Don.';

  @override
  String get receivedShort => 'Ric.';

  @override
  String get completed => 'Completato';

  @override
  String totalAvailable(int you, int them) {
    return 'Totale disponibile: $you vs $them';
  }

  @override
  String maximumVs(int you, int them) {
    return 'Massimo: $you vs $them';
  }

  @override
  String get warLogTabCapital => 'Capitale';

  @override
  String get warLogPrivateHint => 'La cronologia dettagliata delle guerre è privata in questo clan.';

  @override
  String get warLeagueLabel => 'Lega guerra';

  @override
  String get warFrequencyShort => 'Frequenza';

  @override
  String get winStreakLabel => 'Serie di vittorie';

  @override
  String get totalWarsLabel => 'Totale guerre';

  @override
  String get winRateLabel => 'Percentuale vittorie';

  @override
  String get builderPointsLabel => 'Punti costruttore';

  @override
  String get requiredTrophiesLabel => 'Trofei richiesti';

  @override
  String get membersLabel => 'Membri';

  @override
  String get builderWarComingSoon => 'Dettagli guerre base costruttore in arrivo.';

  @override
  String get capitalPointsLabel => 'Punti capitale';

  @override
  String get capitalLeagueLabel => 'Lega capitale';

  @override
  String get clanLevelLabel => 'Livello clan';

  @override
  String get capitalRaidsComingSoon => 'Cronologia assalti capitale in arrivo.';

  @override
  String get warLogPrivateFooter => 'Le guerre individuali non sono visibili perché il registro è privato.';

  @override
  String get unlockedStatus => 'Sbloccato';

  @override
  String get availableInVillage => 'Disponibile nel tuo villaggio';

  @override
  String get notYetAvailable => 'Non ancora disponibile';

  @override
  String levelInProfile(int current, int max) {
    return 'Livello $current di $max nel tuo profilo.';
  }

  @override
  String canUpgradeToLevel(int hall, int max) {
    return 'Con Municipio $hall puoi salire fino al livello $max.';
  }

  @override
  String unlocksAtTownHall(int level) {
    return 'Si sblocca con Municipio livello $level.';
  }

  @override
  String categoryPrefix(String name) {
    return 'Categoria: $name';
  }

  @override
  String get maxLevelReachedHeadline => 'Livello massimo raggiunto';

  @override
  String get inProgressHeadline => 'In corso';

  @override
  String get notUnlockedHeadline => 'Non sbloccato';

  @override
  String get allUpgradesCompleted => 'Hai completato tutti i miglioramenti disponibili nell\'API.';

  @override
  String levelsToMax(int remaining, int max) {
    return 'Mancano $remaining livelli al massimo ($max).';
  }

  @override
  String get researchWhenUnlocked => 'Ricerca nel laboratorio quando sblocchi questa unità.';

  @override
  String get damagePerSec => 'Danno/s';

  @override
  String get healPerSec => 'Cura/s';

  @override
  String nextUpgradeLab(int level) {
    return 'Prossimo miglioramento richiede laboratorio lv. $level';
  }

  @override
  String estimatedCost(String cost) {
    return 'Costo stimato: $cost';
  }

  @override
  String resourceHighlight(String resource) {
    return 'Risorsa: $resource';
  }

  @override
  String levelOfMaxShort(int current, int max) {
    return 'Livello $current di $max.';
  }

  @override
  String get unitNotUnlocked => 'Questa unità non è ancora sbloccata.';

  @override
  String availableAtCurrentTH(int level) {
    return 'Disponibile con il tuo municipio attuale (TH $level).';
  }

  @override
  String requiresTownHallLevel(int level) {
    return 'Richiede Municipio livello $level.';
  }

  @override
  String levelSlashMax(int current, int max) {
    return 'Livello $current / $max';
  }

  @override
  String get maxLevelReachedMessage => 'Hai raggiunto il livello massimo.';

  @override
  String levelsRemainingMessage(int count) {
    return 'Mancano $count livelli per completare.';
  }

  @override
  String upToLevel(int level) {
    return 'Fino a lv. $level';
  }

  @override
  String get available => 'Disponibile';

  @override
  String requiresTownHallShort(int level) {
    return 'TH $level+';
  }

  @override
  String get villageHomeShort => 'Principale';

  @override
  String get warLogTabHome => 'Municipio';

  @override
  String get warLogTabBuilder => 'Costruttore';

  @override
  String get roleLeader => 'Leader';

  @override
  String get roleCoLeader => 'Co-Leader';

  @override
  String get roleElder => 'Anziano';

  @override
  String get roleMember => 'Membro';

  @override
  String get unitDetailDetails => 'DETTAGLI';

  @override
  String townHallShort(int level) {
    return 'TH $level';
  }
}
