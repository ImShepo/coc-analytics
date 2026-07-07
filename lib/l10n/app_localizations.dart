import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Clash Companion'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @languageEs.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @languageEn.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languagePt.
  ///
  /// In es, this message translates to:
  /// **'Português'**
  String get languagePt;

  /// No description provided for @languageFr.
  ///
  /// In es, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @languageIt.
  ///
  /// In es, this message translates to:
  /// **'Italiano'**
  String get languageIt;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navSettings;

  /// No description provided for @searchClanPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar clan'**
  String get searchClanPlaceholder;

  /// No description provided for @welcomeSignUpOrLogin.
  ///
  /// In es, this message translates to:
  /// **'Regístrate o Inicia Sesión'**
  String get welcomeSignUpOrLogin;

  /// No description provided for @welcomeGreeting.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido, '**
  String get welcomeGreeting;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Inicia Sesión'**
  String get loginTitle;

  /// No description provided for @loginNoAccountPrompt.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes una cuenta?'**
  String get loginNoAccountPrompt;

  /// No description provided for @loginCreateAccountAction.
  ///
  /// In es, this message translates to:
  /// **'¡Crea una ahora!'**
  String get loginCreateAccountAction;

  /// No description provided for @signUpTitle.
  ///
  /// In es, this message translates to:
  /// **'Regístrate'**
  String get signUpTitle;

  /// No description provided for @signUpHasAccountPrompt.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes una cuenta?'**
  String get signUpHasAccountPrompt;

  /// No description provided for @signUpLoginAction.
  ///
  /// In es, this message translates to:
  /// **'¡Ingresa ahora!'**
  String get signUpLoginAction;

  /// No description provided for @emailPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordPlaceholder;

  /// No description provided for @namePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get namePlaceholder;

  /// No description provided for @signInButton.
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get signInButton;

  /// No description provided for @termsAndConditions.
  ///
  /// In es, this message translates to:
  /// **'Términos y condiciones de uso'**
  String get termsAndConditions;

  /// No description provided for @googleSignIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión con Google'**
  String get googleSignIn;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @playerErrorForbiddenHint.
  ///
  /// In es, this message translates to:
  /// **'Si ves \"Forbidden\", actualiza COC_KEY en el archivo .env con una API key válida de developer.clashofclans.com'**
  String get playerErrorForbiddenHint;

  /// No description provided for @yourStats.
  ///
  /// In es, this message translates to:
  /// **'Tus Estadísticas'**
  String get yourStats;

  /// No description provided for @seeAll.
  ///
  /// In es, this message translates to:
  /// **'Ver Todas'**
  String get seeAll;

  /// No description provided for @compare.
  ///
  /// In es, this message translates to:
  /// **'Comparar'**
  String get compare;

  /// No description provided for @open.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get open;

  /// No description provided for @yourClan.
  ///
  /// In es, this message translates to:
  /// **'Tu Clan'**
  String get yourClan;

  /// No description provided for @seeMore.
  ///
  /// In es, this message translates to:
  /// **'Ver Más'**
  String get seeMore;

  /// No description provided for @playerNotInClan.
  ///
  /// In es, this message translates to:
  /// **'Este jugador no está en un clan.'**
  String get playerNotInClan;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @categoryTroops.
  ///
  /// In es, this message translates to:
  /// **'Tropas'**
  String get categoryTroops;

  /// No description provided for @categoryBuildings.
  ///
  /// In es, this message translates to:
  /// **'Edificios'**
  String get categoryBuildings;

  /// No description provided for @categoryHeroes.
  ///
  /// In es, this message translates to:
  /// **'Héroes'**
  String get categoryHeroes;

  /// No description provided for @categorySpells.
  ///
  /// In es, this message translates to:
  /// **'Hechizos'**
  String get categorySpells;

  /// No description provided for @categoryCollapseHint.
  ///
  /// In es, this message translates to:
  /// **'Toca un encabezado para colapsar o expandir una sección.'**
  String get categoryCollapseHint;

  /// No description provided for @noTroopsRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay tropas registradas.'**
  String get noTroopsRegistered;

  /// No description provided for @noSpellsRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay hechizos registrados.'**
  String get noSpellsRegistered;

  /// No description provided for @noBuildingsRegistered.
  ///
  /// In es, this message translates to:
  /// **'Sin edificios registrados.'**
  String get noBuildingsRegistered;

  /// No description provided for @noHeroesOrEquipmentRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay héroes ni equipamiento registrados.'**
  String get noHeroesOrEquipmentRegistered;

  /// No description provided for @equipment.
  ///
  /// In es, this message translates to:
  /// **'Equipamiento'**
  String get equipment;

  /// No description provided for @troopsInProfile.
  ///
  /// In es, this message translates to:
  /// **'tropas en tu perfil'**
  String get troopsInProfile;

  /// No description provided for @buildingsInVillage.
  ///
  /// In es, this message translates to:
  /// **'edificios en tu aldea'**
  String get buildingsInVillage;

  /// No description provided for @heroesAndEquipment.
  ///
  /// In es, this message translates to:
  /// **'héroes y equipamiento'**
  String get heroesAndEquipment;

  /// No description provided for @spellsInProfile.
  ///
  /// In es, this message translates to:
  /// **'hechizos en tu perfil'**
  String get spellsInProfile;

  /// No description provided for @troopsAndUnits.
  ///
  /// In es, this message translates to:
  /// **'Tropas y unidades'**
  String get troopsAndUnits;

  /// No description provided for @troopsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar las tropas.'**
  String get troopsLoadError;

  /// No description provided for @compareTitle.
  ///
  /// In es, this message translates to:
  /// **'COMPARAR'**
  String get compareTitle;

  /// No description provided for @compareSelfError.
  ///
  /// In es, this message translates to:
  /// **'No puedes compararte contigo mismo'**
  String get compareSelfError;

  /// No description provided for @opponentDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Rival'**
  String get opponentDefaultName;

  /// No description provided for @versus.
  ///
  /// In es, this message translates to:
  /// **'VS'**
  String get versus;

  /// No description provided for @compareTabSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get compareTabSummary;

  /// No description provided for @compareTabStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get compareTabStats;

  /// No description provided for @compareTabAchievements.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get compareTabAchievements;

  /// No description provided for @compareTabTroops.
  ///
  /// In es, this message translates to:
  /// **'Tropas'**
  String get compareTabTroops;

  /// No description provided for @opponentTagHint.
  ///
  /// In es, this message translates to:
  /// **'Tag del rival (#ABC123)'**
  String get opponentTagHint;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @compareEnterTagPrompt.
  ///
  /// In es, this message translates to:
  /// **'Escribe el tag del rival en el buscador de arriba.'**
  String get compareEnterTagPrompt;

  /// No description provided for @clanMates.
  ///
  /// In es, this message translates to:
  /// **'COMPAÑEROS DE CLAN'**
  String get clanMates;

  /// No description provided for @compareNoClanHint.
  ///
  /// In es, this message translates to:
  /// **'La API de Supercell no expone la lista de amigos del juego. Sin clan, solo puedes comparar por tag.'**
  String get compareNoClanHint;

  /// No description provided for @compareClanMatesHint.
  ///
  /// In es, this message translates to:
  /// **'La API no incluye amigos del juego; aquí puedes comparar con compañeros de {clanName}.'**
  String compareClanMatesHint(String clanName);

  /// No description provided for @clanMateSubtitle.
  ///
  /// In es, this message translates to:
  /// **'{tag} · TH{th} · {trophies} copas'**
  String clanMateSubtitle(String tag, int th, int trophies);

  /// No description provided for @versusSeparator.
  ///
  /// In es, this message translates to:
  /// **' vs '**
  String get versusSeparator;

  /// No description provided for @pickOpponent.
  ///
  /// In es, this message translates to:
  /// **'Elige un rival'**
  String get pickOpponent;

  /// No description provided for @comparePreviewSubtitle.
  ///
  /// In es, this message translates to:
  /// **'TROPAS · ESTADÍSTICAS · LOGROS'**
  String get comparePreviewSubtitle;

  /// No description provided for @changeOpponent.
  ///
  /// In es, this message translates to:
  /// **'Cambiar rival'**
  String get changeOpponent;

  /// No description provided for @currentOpponent.
  ///
  /// In es, this message translates to:
  /// **'Rival actual'**
  String get currentOpponent;

  /// No description provided for @compareQuickSwitch.
  ///
  /// In es, this message translates to:
  /// **'Clan del rival'**
  String get compareQuickSwitch;

  /// No description provided for @statsTitle.
  ///
  /// In es, this message translates to:
  /// **'ESTADÍSTICAS'**
  String get statsTitle;

  /// No description provided for @stats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get stats;

  /// No description provided for @warLog.
  ///
  /// In es, this message translates to:
  /// **'Registro De Guerra'**
  String get warLog;

  /// No description provided for @clanMembersCount.
  ///
  /// In es, this message translates to:
  /// **'Miembros Del Clan ({count})'**
  String clanMembersCount(int count);

  /// No description provided for @levelTownHall.
  ///
  /// In es, this message translates to:
  /// **'Town Hall Level'**
  String get levelTownHall;

  /// No description provided for @levelBuilderHall.
  ///
  /// In es, this message translates to:
  /// **'Builder Hall Level'**
  String get levelBuilderHall;

  /// No description provided for @levelClanCapital.
  ///
  /// In es, this message translates to:
  /// **'Clan Capital'**
  String get levelClanCapital;

  /// No description provided for @league.
  ///
  /// In es, this message translates to:
  /// **'Liga'**
  String get league;

  /// No description provided for @contributions.
  ///
  /// In es, this message translates to:
  /// **'Contribuciones'**
  String get contributions;

  /// No description provided for @levelLabel.
  ///
  /// In es, this message translates to:
  /// **'Nv. {level}'**
  String levelLabel(int level);

  /// No description provided for @troopGroupElixir.
  ///
  /// In es, this message translates to:
  /// **'Elixir'**
  String get troopGroupElixir;

  /// No description provided for @troopGroupDarkElixir.
  ///
  /// In es, this message translates to:
  /// **'Elixir oscuro'**
  String get troopGroupDarkElixir;

  /// No description provided for @troopGroupBuilderBase.
  ///
  /// In es, this message translates to:
  /// **'Base del constructor'**
  String get troopGroupBuilderBase;

  /// No description provided for @troopGroupSiege.
  ///
  /// In es, this message translates to:
  /// **'Máquinas de asedio'**
  String get troopGroupSiege;

  /// No description provided for @troopGroupPets.
  ///
  /// In es, this message translates to:
  /// **'Mascotas'**
  String get troopGroupPets;

  /// No description provided for @troopGroupOther.
  ///
  /// In es, this message translates to:
  /// **'Otras tropas'**
  String get troopGroupOther;

  /// No description provided for @spellGroupElixir.
  ///
  /// In es, this message translates to:
  /// **'Elixir'**
  String get spellGroupElixir;

  /// No description provided for @spellGroupDarkElixir.
  ///
  /// In es, this message translates to:
  /// **'Elixir oscuro'**
  String get spellGroupDarkElixir;

  /// No description provided for @spellGroupOther.
  ///
  /// In es, this message translates to:
  /// **'Otros hechizos'**
  String get spellGroupOther;

  /// No description provided for @buildingGroupMain.
  ///
  /// In es, this message translates to:
  /// **'Principales'**
  String get buildingGroupMain;

  /// No description provided for @buildingGroupDefense.
  ///
  /// In es, this message translates to:
  /// **'Defensas'**
  String get buildingGroupDefense;

  /// No description provided for @buildingGroupResource.
  ///
  /// In es, this message translates to:
  /// **'Recursos'**
  String get buildingGroupResource;

  /// No description provided for @buildingGroupArmy.
  ///
  /// In es, this message translates to:
  /// **'Ejército'**
  String get buildingGroupArmy;

  /// No description provided for @buildingGroupTraps.
  ///
  /// In es, this message translates to:
  /// **'Trampas'**
  String get buildingGroupTraps;

  /// No description provided for @buildingGroupBuilderBase.
  ///
  /// In es, this message translates to:
  /// **'Base del constructor'**
  String get buildingGroupBuilderBase;

  /// No description provided for @mainTownHall.
  ///
  /// In es, this message translates to:
  /// **'Ayuntamiento principal'**
  String get mainTownHall;

  /// No description provided for @builderBaseSection.
  ///
  /// In es, this message translates to:
  /// **'Base del constructor'**
  String get builderBaseSection;

  /// No description provided for @clanAndDonations.
  ///
  /// In es, this message translates to:
  /// **'Clan y donaciones'**
  String get clanAndDonations;

  /// No description provided for @legendLeague.
  ///
  /// In es, this message translates to:
  /// **'Liga leyenda'**
  String get legendLeague;

  /// No description provided for @trophies.
  ///
  /// In es, this message translates to:
  /// **'Trofeos'**
  String get trophies;

  /// No description provided for @warStars.
  ///
  /// In es, this message translates to:
  /// **'Estrellas de guerra'**
  String get warStars;

  /// No description provided for @attackWins.
  ///
  /// In es, this message translates to:
  /// **'Victorias ataque'**
  String get attackWins;

  /// No description provided for @defenseWins.
  ///
  /// In es, this message translates to:
  /// **'Victorias defensa'**
  String get defenseWins;

  /// No description provided for @warPreference.
  ///
  /// In es, this message translates to:
  /// **'Preferencia de guerra'**
  String get warPreference;

  /// No description provided for @donations.
  ///
  /// In es, this message translates to:
  /// **'Donaciones'**
  String get donations;

  /// No description provided for @donationsReceived.
  ///
  /// In es, this message translates to:
  /// **'Recibidas'**
  String get donationsReceived;

  /// No description provided for @role.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get role;

  /// No description provided for @clan.
  ///
  /// In es, this message translates to:
  /// **'Clan'**
  String get clan;

  /// No description provided for @townHall.
  ///
  /// In es, this message translates to:
  /// **'Ayuntamiento'**
  String get townHall;

  /// No description provided for @experience.
  ///
  /// In es, this message translates to:
  /// **'Experiencia'**
  String get experience;

  /// No description provided for @bestRecord.
  ///
  /// In es, this message translates to:
  /// **'Mejor récord'**
  String get bestRecord;

  /// No description provided for @legendTrophies.
  ///
  /// In es, this message translates to:
  /// **'Trofeos leyenda'**
  String get legendTrophies;

  /// No description provided for @currentSeason.
  ///
  /// In es, this message translates to:
  /// **'Temporada actual'**
  String get currentSeason;

  /// No description provided for @bestSeason.
  ///
  /// In es, this message translates to:
  /// **'Mejor temporada'**
  String get bestSeason;

  /// No description provided for @achievementsHomeVillage.
  ///
  /// In es, this message translates to:
  /// **'Logros · Ayuntamiento'**
  String get achievementsHomeVillage;

  /// No description provided for @achievementsBuilderVillage.
  ///
  /// In es, this message translates to:
  /// **'Logros · Constructor'**
  String get achievementsBuilderVillage;

  /// No description provided for @noHomeAchievements.
  ///
  /// In es, this message translates to:
  /// **'Sin logros del ayuntamiento.'**
  String get noHomeAchievements;

  /// No description provided for @noBuilderAchievements.
  ///
  /// In es, this message translates to:
  /// **'Sin logros del constructor.'**
  String get noBuilderAchievements;

  /// No description provided for @homeVillageAchievements.
  ///
  /// In es, this message translates to:
  /// **'Logros del ayuntamiento'**
  String get homeVillageAchievements;

  /// No description provided for @builderVillageAchievements.
  ///
  /// In es, this message translates to:
  /// **'Logros del constructor'**
  String get builderVillageAchievements;

  /// No description provided for @trophiesBB.
  ///
  /// In es, this message translates to:
  /// **'Trofeos BB'**
  String get trophiesBB;

  /// No description provided for @leagueBB.
  ///
  /// In es, this message translates to:
  /// **'Liga BB'**
  String get leagueBB;

  /// No description provided for @clanContribution.
  ///
  /// In es, this message translates to:
  /// **'Contribución al clan'**
  String get clanContribution;

  /// No description provided for @donated.
  ///
  /// In es, this message translates to:
  /// **'Donadas'**
  String get donated;

  /// No description provided for @received.
  ///
  /// In es, this message translates to:
  /// **'Recibidas'**
  String get received;

  /// No description provided for @clanWarLeague.
  ///
  /// In es, this message translates to:
  /// **'Clan War League'**
  String get clanWarLeague;

  /// No description provided for @totalPoints.
  ///
  /// In es, this message translates to:
  /// **'Puntos totales'**
  String get totalPoints;

  /// No description provided for @location.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get location;

  /// No description provided for @chatLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma del chat'**
  String get chatLanguage;

  /// No description provided for @clanType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get clanType;

  /// No description provided for @requiredTrophies.
  ///
  /// In es, this message translates to:
  /// **'Trofeos requeridos'**
  String get requiredTrophies;

  /// No description provided for @requiredTownHall.
  ///
  /// In es, this message translates to:
  /// **'Ayuntamiento requerido'**
  String get requiredTownHall;

  /// No description provided for @wins.
  ///
  /// In es, this message translates to:
  /// **'Victorias'**
  String get wins;

  /// No description provided for @ties.
  ///
  /// In es, this message translates to:
  /// **'Empates'**
  String get ties;

  /// No description provided for @losses.
  ///
  /// In es, this message translates to:
  /// **'Derrotas'**
  String get losses;

  /// No description provided for @winStreak.
  ///
  /// In es, this message translates to:
  /// **'Racha'**
  String get winStreak;

  /// No description provided for @unitCategoryTroop.
  ///
  /// In es, this message translates to:
  /// **'Tropa'**
  String get unitCategoryTroop;

  /// No description provided for @unitCategoryHero.
  ///
  /// In es, this message translates to:
  /// **'Héroe'**
  String get unitCategoryHero;

  /// No description provided for @unitCategorySpell.
  ///
  /// In es, this message translates to:
  /// **'Hechizo'**
  String get unitCategorySpell;

  /// No description provided for @unitCategoryEquipment.
  ///
  /// In es, this message translates to:
  /// **'Equipamiento'**
  String get unitCategoryEquipment;

  /// No description provided for @unitCategoryBuilding.
  ///
  /// In es, this message translates to:
  /// **'Edificio'**
  String get unitCategoryBuilding;

  /// No description provided for @locked.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado'**
  String get locked;

  /// No description provided for @maxLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel máximo'**
  String get maxLevel;

  /// No description provided for @currentLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel actual'**
  String get currentLevel;

  /// No description provided for @globalMax.
  ///
  /// In es, this message translates to:
  /// **'Máximo global'**
  String get globalMax;

  /// No description provided for @yourTownHall.
  ///
  /// In es, this message translates to:
  /// **'Tu ayuntamiento'**
  String get yourTownHall;

  /// No description provided for @maxInVillage.
  ///
  /// In es, this message translates to:
  /// **'Máx. en tu aldea'**
  String get maxInVillage;

  /// No description provided for @unlockAt.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueo'**
  String get unlockAt;

  /// No description provided for @totalLevels.
  ///
  /// In es, this message translates to:
  /// **'Niveles totales'**
  String get totalLevels;

  /// No description provided for @level.
  ///
  /// In es, this message translates to:
  /// **'Nivel'**
  String get level;

  /// No description provided for @maximum.
  ///
  /// In es, this message translates to:
  /// **'Máximo'**
  String get maximum;

  /// No description provided for @villageLabel.
  ///
  /// In es, this message translates to:
  /// **'Aldea'**
  String get villageLabel;

  /// No description provided for @health.
  ///
  /// In es, this message translates to:
  /// **'Vida'**
  String get health;

  /// No description provided for @housingSpace.
  ///
  /// In es, this message translates to:
  /// **'Espacio'**
  String get housingSpace;

  /// No description provided for @compareCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completados'**
  String get compareCompleted;

  /// No description provided for @starsEarned.
  ///
  /// In es, this message translates to:
  /// **'Estrellas ganadas'**
  String get starsEarned;

  /// No description provided for @yourProgress.
  ///
  /// In es, this message translates to:
  /// **'Tu progreso'**
  String get yourProgress;

  /// No description provided for @rival.
  ///
  /// In es, this message translates to:
  /// **'Rival'**
  String get rival;

  /// No description provided for @you.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get you;

  /// No description provided for @unlocked.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueadas'**
  String get unlocked;

  /// No description provided for @headToHeadCount.
  ///
  /// In es, this message translates to:
  /// **'Cara a cara ({count})'**
  String headToHeadCount(int count);

  /// No description provided for @levelPerTroop.
  ///
  /// In es, this message translates to:
  /// **'Nivel por tropa'**
  String get levelPerTroop;

  /// No description provided for @noSharedTroops.
  ///
  /// In es, this message translates to:
  /// **'No hay tropas en común para comparar.'**
  String get noSharedTroops;

  /// No description provided for @comparativeProfile.
  ///
  /// In es, this message translates to:
  /// **'PERFIL COMPARATIVO'**
  String get comparativeProfile;

  /// No description provided for @tiesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} empates'**
  String tiesCount(int count);

  /// No description provided for @winsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} victorias'**
  String winsCount(int count);

  /// No description provided for @whereYouLead.
  ///
  /// In es, this message translates to:
  /// **'DONDE DESTACAS'**
  String get whereYouLead;

  /// No description provided for @whereTheyLead.
  ///
  /// In es, this message translates to:
  /// **'DONDE TE SUPERA'**
  String get whereTheyLead;

  /// No description provided for @noClearAdvantages.
  ///
  /// In es, this message translates to:
  /// **'Sin ventajas claras en esta comparación.'**
  String get noClearAdvantages;

  /// No description provided for @compareGroupTownHall.
  ///
  /// In es, this message translates to:
  /// **'Ayuntamiento'**
  String get compareGroupTownHall;

  /// No description provided for @compareGroupBuilder.
  ///
  /// In es, this message translates to:
  /// **'Constructor'**
  String get compareGroupBuilder;

  /// No description provided for @compareGroupClan.
  ///
  /// In es, this message translates to:
  /// **'Clan'**
  String get compareGroupClan;

  /// No description provided for @unitDetailStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get unitDetailStatus;

  /// No description provided for @unitDetailStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get unitDetailStats;

  /// No description provided for @unitDetailProgress.
  ///
  /// In es, this message translates to:
  /// **'Progreso'**
  String get unitDetailProgress;

  /// No description provided for @unitDetailHighlights.
  ///
  /// In es, this message translates to:
  /// **'Destacados'**
  String get unitDetailHighlights;

  /// No description provided for @unitDetailDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get unitDetailDescription;

  /// No description provided for @unitDetailContext.
  ///
  /// In es, this message translates to:
  /// **'Contexto en tu aldea'**
  String get unitDetailContext;

  /// No description provided for @searchClanQueryHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre o tag del clan'**
  String get searchClanQueryHint;

  /// No description provided for @comparePlayersPromo.
  ///
  /// In es, this message translates to:
  /// **'COMPARAR JUGADORES'**
  String get comparePlayersPromo;

  /// No description provided for @comparePlayersSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas, gráficas y logros frente a frente.'**
  String get comparePlayersSubtitle;

  /// No description provided for @warPreferenceIn.
  ///
  /// In es, this message translates to:
  /// **'En guerra'**
  String get warPreferenceIn;

  /// No description provided for @warPreferenceOut.
  ///
  /// In es, this message translates to:
  /// **'Fuera de guerra'**
  String get warPreferenceOut;

  /// No description provided for @townHallBanner.
  ///
  /// In es, this message translates to:
  /// **'AYUNTAMIENTO {level}{suffix}'**
  String townHallBanner(int level, String suffix);

  /// No description provided for @experienceLevelLine.
  ///
  /// In es, this message translates to:
  /// **'Nivel de experiencia {level}'**
  String experienceLevelLine(int level);

  /// No description provided for @warFrequencyLabel.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia de guerra: {frequency}'**
  String warFrequencyLabel(String frequency);

  /// No description provided for @searchClansField.
  ///
  /// In es, this message translates to:
  /// **'Buscar clanes'**
  String get searchClansField;

  /// No description provided for @searchClanNoResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron clanes'**
  String get searchClanNoResults;

  /// No description provided for @rankInClan.
  ///
  /// In es, this message translates to:
  /// **'RANKING EN EL CLAN'**
  String get rankInClan;

  /// No description provided for @clanPosition.
  ///
  /// In es, this message translates to:
  /// **'Posición #{rank}'**
  String clanPosition(int rank);

  /// No description provided for @noRankChange.
  ///
  /// In es, this message translates to:
  /// **'Sin cambio'**
  String get noRankChange;

  /// No description provided for @donationActivityNone.
  ///
  /// In es, this message translates to:
  /// **'Sin actividad de donaciones esta temporada.'**
  String get donationActivityNone;

  /// No description provided for @donationBalance.
  ///
  /// In es, this message translates to:
  /// **'Balance {donatePct}% donaciones · {receivePct}% recibidas'**
  String donationBalance(int donatePct, int receivePct);

  /// No description provided for @compareStatsTitle.
  ///
  /// In es, this message translates to:
  /// **'Comparar estadísticas'**
  String get compareStatsTitle;

  /// No description provided for @compareStatsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gráficas, logros y tropas frente a frente.'**
  String get compareStatsSubtitle;

  /// No description provided for @donationsShort.
  ///
  /// In es, this message translates to:
  /// **'Don.'**
  String get donationsShort;

  /// No description provided for @receivedShort.
  ///
  /// In es, this message translates to:
  /// **'Rec.'**
  String get receivedShort;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get completed;

  /// No description provided for @totalAvailable.
  ///
  /// In es, this message translates to:
  /// **'Total disponible: {you} vs {them}'**
  String totalAvailable(int you, int them);

  /// No description provided for @maximumVs.
  ///
  /// In es, this message translates to:
  /// **'Máximo: {you} vs {them}'**
  String maximumVs(int you, int them);

  /// No description provided for @warLogTabCapital.
  ///
  /// In es, this message translates to:
  /// **'Capital'**
  String get warLogTabCapital;

  /// No description provided for @warLogPrivateHint.
  ///
  /// In es, this message translates to:
  /// **'El historial detallado de guerras es privado en este clan.'**
  String get warLogPrivateHint;

  /// No description provided for @warLeagueLabel.
  ///
  /// In es, this message translates to:
  /// **'Liga de guerra'**
  String get warLeagueLabel;

  /// No description provided for @warFrequencyShort.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get warFrequencyShort;

  /// No description provided for @winStreakLabel.
  ///
  /// In es, this message translates to:
  /// **'Racha de victorias'**
  String get winStreakLabel;

  /// No description provided for @totalWarsLabel.
  ///
  /// In es, this message translates to:
  /// **'Total de guerras'**
  String get totalWarsLabel;

  /// No description provided for @winRateLabel.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de victorias'**
  String get winRateLabel;

  /// No description provided for @builderPointsLabel.
  ///
  /// In es, this message translates to:
  /// **'Puntos de constructor'**
  String get builderPointsLabel;

  /// No description provided for @requiredTrophiesLabel.
  ///
  /// In es, this message translates to:
  /// **'Trofeos requeridos'**
  String get requiredTrophiesLabel;

  /// No description provided for @membersLabel.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get membersLabel;

  /// No description provided for @builderWarComingSoon.
  ///
  /// In es, this message translates to:
  /// **'El detalle de guerras de la base del constructor estará disponible próximamente.'**
  String get builderWarComingSoon;

  /// No description provided for @capitalPointsLabel.
  ///
  /// In es, this message translates to:
  /// **'Puntos de capital'**
  String get capitalPointsLabel;

  /// No description provided for @capitalLeagueLabel.
  ///
  /// In es, this message translates to:
  /// **'Liga de capital'**
  String get capitalLeagueLabel;

  /// No description provided for @clanLevelLabel.
  ///
  /// In es, this message translates to:
  /// **'Nivel del clan'**
  String get clanLevelLabel;

  /// No description provided for @capitalRaidsComingSoon.
  ///
  /// In es, this message translates to:
  /// **'El historial de asaltos al capital estará disponible próximamente.'**
  String get capitalRaidsComingSoon;

  /// No description provided for @warLogPrivateFooter.
  ///
  /// In es, this message translates to:
  /// **'Las guerras individuales no están visibles porque el registro es privado.'**
  String get warLogPrivateFooter;

  /// No description provided for @unlockedStatus.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueado'**
  String get unlockedStatus;

  /// No description provided for @availableInVillage.
  ///
  /// In es, this message translates to:
  /// **'Disponible en tu aldea'**
  String get availableInVillage;

  /// No description provided for @notYetAvailable.
  ///
  /// In es, this message translates to:
  /// **'Aún no disponible'**
  String get notYetAvailable;

  /// No description provided for @levelInProfile.
  ///
  /// In es, this message translates to:
  /// **'Nivel {current} de {max} en tu perfil.'**
  String levelInProfile(int current, int max);

  /// No description provided for @canUpgradeToLevel.
  ///
  /// In es, this message translates to:
  /// **'Con Ayuntamiento {hall} puedes subirlo hasta nivel {max}.'**
  String canUpgradeToLevel(int hall, int max);

  /// No description provided for @unlocksAtTownHall.
  ///
  /// In es, this message translates to:
  /// **'Se desbloquea con Ayuntamiento nivel {level}.'**
  String unlocksAtTownHall(int level);

  /// No description provided for @categoryPrefix.
  ///
  /// In es, this message translates to:
  /// **'Categoría: {name}'**
  String categoryPrefix(String name);

  /// No description provided for @maxLevelReachedHeadline.
  ///
  /// In es, this message translates to:
  /// **'Nivel máximo alcanzado'**
  String get maxLevelReachedHeadline;

  /// No description provided for @inProgressHeadline.
  ///
  /// In es, this message translates to:
  /// **'En progreso'**
  String get inProgressHeadline;

  /// No description provided for @notUnlockedHeadline.
  ///
  /// In es, this message translates to:
  /// **'Sin desbloquear'**
  String get notUnlockedHeadline;

  /// No description provided for @allUpgradesCompleted.
  ///
  /// In es, this message translates to:
  /// **'Has completado todas las mejoras disponibles en la API.'**
  String get allUpgradesCompleted;

  /// No description provided for @levelsToMax.
  ///
  /// In es, this message translates to:
  /// **'Te faltan {remaining} niveles para el máximo ({max}).'**
  String levelsToMax(int remaining, int max);

  /// No description provided for @researchWhenUnlocked.
  ///
  /// In es, this message translates to:
  /// **'Investiga en el laboratorio cuando desbloquees esta unidad.'**
  String get researchWhenUnlocked;

  /// No description provided for @damagePerSec.
  ///
  /// In es, this message translates to:
  /// **'Daño/s'**
  String get damagePerSec;

  /// No description provided for @healPerSec.
  ///
  /// In es, this message translates to:
  /// **'Curación/s'**
  String get healPerSec;

  /// No description provided for @nextUpgradeLab.
  ///
  /// In es, this message translates to:
  /// **'Siguiente mejora requiere laboratorio nv. {level}'**
  String nextUpgradeLab(int level);

  /// No description provided for @estimatedCost.
  ///
  /// In es, this message translates to:
  /// **'Coste estimado: {cost}'**
  String estimatedCost(String cost);

  /// No description provided for @resourceHighlight.
  ///
  /// In es, this message translates to:
  /// **'Recurso: {resource}'**
  String resourceHighlight(String resource);

  /// No description provided for @levelOfMaxShort.
  ///
  /// In es, this message translates to:
  /// **'Nivel {current} de {max}.'**
  String levelOfMaxShort(int current, int max);

  /// No description provided for @unitNotUnlocked.
  ///
  /// In es, this message translates to:
  /// **'Esta unidad aún no está desbloqueada.'**
  String get unitNotUnlocked;

  /// No description provided for @availableAtCurrentTH.
  ///
  /// In es, this message translates to:
  /// **'Disponible con tu ayuntamiento actual (TH {level}).'**
  String availableAtCurrentTH(int level);

  /// No description provided for @requiresTownHallLevel.
  ///
  /// In es, this message translates to:
  /// **'Requiere Ayuntamiento nivel {level}.'**
  String requiresTownHallLevel(int level);

  /// No description provided for @levelSlashMax.
  ///
  /// In es, this message translates to:
  /// **'Nivel {current} / {max}'**
  String levelSlashMax(int current, int max);

  /// No description provided for @maxLevelReachedMessage.
  ///
  /// In es, this message translates to:
  /// **'Has alcanzado el nivel máximo.'**
  String get maxLevelReachedMessage;

  /// No description provided for @levelsRemainingMessage.
  ///
  /// In es, this message translates to:
  /// **'Faltan {count} niveles para completar.'**
  String levelsRemainingMessage(int count);

  /// No description provided for @upToLevel.
  ///
  /// In es, this message translates to:
  /// **'Hasta nv. {level}'**
  String upToLevel(int level);

  /// No description provided for @available.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get available;

  /// No description provided for @requiresTownHallShort.
  ///
  /// In es, this message translates to:
  /// **'TH {level}+'**
  String requiresTownHallShort(int level);

  /// No description provided for @villageHomeShort.
  ///
  /// In es, this message translates to:
  /// **'Principal'**
  String get villageHomeShort;

  /// No description provided for @warLogTabHome.
  ///
  /// In es, this message translates to:
  /// **'Ayuntamiento'**
  String get warLogTabHome;

  /// No description provided for @warLogTabBuilder.
  ///
  /// In es, this message translates to:
  /// **'Constructor'**
  String get warLogTabBuilder;

  /// No description provided for @roleLeader.
  ///
  /// In es, this message translates to:
  /// **'Líder'**
  String get roleLeader;

  /// No description provided for @roleCoLeader.
  ///
  /// In es, this message translates to:
  /// **'Co-Líder'**
  String get roleCoLeader;

  /// No description provided for @roleElder.
  ///
  /// In es, this message translates to:
  /// **'Anciano'**
  String get roleElder;

  /// No description provided for @roleMember.
  ///
  /// In es, this message translates to:
  /// **'Miembro'**
  String get roleMember;

  /// No description provided for @unitDetailDetails.
  ///
  /// In es, this message translates to:
  /// **'DETALLES'**
  String get unitDetailDetails;

  /// No description provided for @townHallShort.
  ///
  /// In es, this message translates to:
  /// **'TH {level}'**
  String townHallShort(int level);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'it', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
