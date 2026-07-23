// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Clash Companion';

  @override
  String get language => 'Idioma';

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
  String get navHome => 'Inicio';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get searchClanPlaceholder => 'Buscar clan';

  @override
  String get welcomeSignUpOrLogin => 'Regístrate o Inicia Sesión';

  @override
  String get welcomeGreeting => 'Bienvenido, ';

  @override
  String get loginTitle => 'Inicia Sesión';

  @override
  String get loginNoAccountPrompt => '¿No tienes una cuenta?';

  @override
  String get loginCreateAccountAction => '¡Crea una ahora!';

  @override
  String get signUpTitle => 'Regístrate';

  @override
  String get signUpHasAccountPrompt => '¿Ya tienes una cuenta?';

  @override
  String get signUpLoginAction => '¡Ingresa ahora!';

  @override
  String get emailPlaceholder => 'Correo Electrónico';

  @override
  String get passwordPlaceholder => 'Contraseña';

  @override
  String get namePlaceholder => 'Nombre';

  @override
  String get signInButton => 'Ingresar';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get signingIn => 'Ingresando…';

  @override
  String get signingUp => 'Creando cuenta…';

  @override
  String get authFieldsRequired => 'Completa todos los campos.';

  @override
  String get signOutButton => 'Cerrar sesión';

  @override
  String get signOutConfirmMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get accountMenuTooltip => 'Cuenta';

  @override
  String get unlinkPlayerButton => 'Desvincular jugador';

  @override
  String get unlinkPlayerTitle => 'Desvincular jugador';

  @override
  String get unlinkPlayerMessage => 'Se quitará el vínculo con tu jugador de Clash of Clans. Podrás vincular otra etiqueta después.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get linkPlayerTitle => 'Vincula tu jugador';

  @override
  String get linkPlayerSubtitle => 'Introduce tu etiqueta de jugador de Clash of Clans para cargar tus estadísticas. Si no juegas, puedes continuar sin vincular.';

  @override
  String get linkPlayerAltHelp => '¿No tienes el juego instalado? Busca tu clan, elige tu nombre y verifica con el API Token. Si no juegas, puedes continuar sin vincular.';

  @override
  String get linkPlayerTagPlaceholder => 'Etiqueta del jugador (#ABC123)';

  @override
  String get linkPlayerTagRequired => 'Introduce tu etiqueta de jugador.';

  @override
  String get linkPlayerTagHelp => 'En Clash of Clans:\nAbre tu perfil (ícono de tu aldea), ve a «Mi perfil» y copia la etiqueta que aparece debajo de tu nombre.';

  @override
  String get linkPlayerTokenPlaceholder => 'API Token';

  @override
  String get linkPlayerTokenRequired => 'Introduce el API Token del juego.';

  @override
  String get linkPlayerTokenHelp => 'En Clash of Clans:\nVe a Ajustes → Más ajustes, busca la sección «API Token» y toca «SHOW» para verlo y copiarlo.';

  @override
  String get linkPlayerSeeGuide => 'Ver guía';

  @override
  String get linkPlayerTokenInvalid => 'El API Token no es válido para esta etiqueta. Genera uno nuevo en el juego e inténtalo de nuevo.';

  @override
  String get linkPlayerPickMemberFirst => 'Elige primero tu jugador en la lista.';

  @override
  String linkPlayerVerifySelected(String name, String tag) {
    return 'Verifica a $name ($tag)';
  }

  @override
  String get linkPlayerButton => 'Verificar y vincular';

  @override
  String get linkingPlayer => 'Verificando…';

  @override
  String get linkPlayerSkip => 'Continuar sin vincular';

  @override
  String get guestHomeUnlinkedTag => 'Sin vincular';

  @override
  String get guestHomeLinkCta => 'Vincular mi jugador';

  @override
  String get guestHomeStatsHint => 'Vincula tu jugador para ver tus estadísticas.';

  @override
  String get guestHomeCompareHint => 'Vincula tu jugador para comparar con otros.';

  @override
  String get guestHomeClanHint => 'Vincula tu jugador para ver tu clan.';

  @override
  String get guestHomeCategoriesHint => 'Vincula tu jugador para ver tropas, héroes y más.';

  @override
  String get linkPlayerModeTag => 'Por etiqueta';

  @override
  String get linkPlayerModeClan => 'Por clan';

  @override
  String get linkPlayerSearchClan => 'Buscar clan';

  @override
  String get linkPlayerClanQueryHint => 'Por nombre: al menos 3 letras. Por tag: incluye el # (ej. #2GQYGPLOC).';

  @override
  String get linkPlayerPickClan => 'Elige tu clan';

  @override
  String linkPlayerClanCount(int count) {
    return '$count clanes';
  }

  @override
  String linkPlayerMemberCount(int count) {
    return '$count jugadores';
  }

  @override
  String get linkPlayerPickMember => 'Elige tu jugador';

  @override
  String get linkPlayerLookupOnline => 'Buscar etiqueta en línea';

  @override
  String get browseHomeTitle => 'Explorar';

  @override
  String get browseHomeSubtitle => 'Busca clanes o consulta cualquier jugador. Vincula el tuyo cuando quieras para ver tus estadísticas.';

  @override
  String get browseLookupPlayerTitle => 'Consultar jugador';

  @override
  String get browseLookupPlayerButton => 'Ver jugador';

  @override
  String get browseLinkPlayerCta => 'Vincular mi jugador';

  @override
  String get termsAndConditions => 'Términos y condiciones de uso';

  @override
  String get googleSignIn => 'Iniciar sesión con Google';

  @override
  String get retry => 'Reintentar';

  @override
  String get dataRefreshing => 'Actualizando datos…';

  @override
  String get dataUpdatedJustNow => 'Actualizado hace un momento';

  @override
  String dataUpdatedAgo(int minutes) {
    return 'Actualizado hace $minutes min';
  }

  @override
  String get dataRefreshFailed => 'No se pudo actualizar. Mostrando datos guardados.';

  @override
  String get playerErrorForbiddenHint => 'Si ves \"Forbidden\", actualiza COC_KEY en el archivo .env con una API key válida de developer.clashofclans.com';

  @override
  String get apiErrorPlayerNotFound => 'No encontramos un jugador con ese tag. Revisa que esté bien escrito.';

  @override
  String get apiErrorBadRequest => 'La consulta no es válida. Revisa el tag e inténtalo de nuevo.';

  @override
  String get apiErrorUnauthorized => 'No autorizado. Revisa la configuración de la API.';

  @override
  String get apiErrorForbidden => 'Acceso denegado. Revisa tu API key en el archivo .env.';

  @override
  String get apiErrorRateLimited => 'Demasiadas consultas. Espera un momento e inténtalo de nuevo.';

  @override
  String get apiErrorServer => 'El servidor no responde. Inténtalo más tarde.';

  @override
  String get apiErrorNetwork => 'Error de conexión. Revisa tu internet.';

  @override
  String get apiErrorUnexpected => 'Ocurrió un error inesperado. Inténtalo de nuevo.';

  @override
  String get yourStats => 'Tus Estadísticas';

  @override
  String get seeAll => 'Ver Todas';

  @override
  String get compare => 'Comparar';

  @override
  String get open => 'Abrir';

  @override
  String get yourClan => 'Tu Clan';

  @override
  String get seeMore => 'Ver Más';

  @override
  String get playerNotInClan => 'Este jugador no está en un clan.';

  @override
  String get categories => 'Categorías';

  @override
  String get categoryTroops => 'Tropas';

  @override
  String get categoryBuildings => 'Edificios';

  @override
  String get categoryHeroes => 'Héroes';

  @override
  String get categorySpells => 'Hechizos';

  @override
  String get categoryCollapseHint => 'Toca un encabezado para colapsar o expandir una sección.';

  @override
  String get noTroopsRegistered => 'No hay tropas registradas.';

  @override
  String get noSpellsRegistered => 'No hay hechizos registrados.';

  @override
  String get noBuildingsRegistered => 'Sin edificios registrados.';

  @override
  String get noHeroesOrEquipmentRegistered => 'No hay héroes ni equipamiento registrados.';

  @override
  String get equipment => 'Equipamiento';

  @override
  String get superTroopActive => 'Súper activa';

  @override
  String get superTroopActiveBadge => 'SÚPER';

  @override
  String get levelPerUnit => 'Nivel por unidad';

  @override
  String get noUnitsToCompare => 'No hay unidades en común para comparar.';

  @override
  String get troopsInProfile => 'tropas en tu perfil';

  @override
  String get buildingsInVillage => 'edificios en tu aldea';

  @override
  String get heroesAndEquipment => 'héroes y equipamiento';

  @override
  String get spellsInProfile => 'hechizos en tu perfil';

  @override
  String get troopsAndUnits => 'Tropas y unidades';

  @override
  String get troopsLoadError => 'No se pudieron cargar las tropas.';

  @override
  String get compareTitle => 'COMPARAR';

  @override
  String get compareSelfError => 'No puedes compararte contigo mismo';

  @override
  String get compareRecentSearches => 'Búsquedas recientes';

  @override
  String get compareClearRecent => 'Borrar';

  @override
  String get compareNoRecentMatches => 'Sin coincidencias en el historial';

  @override
  String get opponentDefaultName => 'Rival';

  @override
  String get versus => 'VS';

  @override
  String get compareTabSummary => 'Resumen';

  @override
  String get compareTabStats => 'Estadísticas';

  @override
  String get compareTabAchievements => 'Logros';

  @override
  String get compareTabTroops => 'Tropas';

  @override
  String get opponentTagHint => 'Tag del rival (#ABC123)';

  @override
  String get search => 'Buscar';

  @override
  String get compareEnterTagPrompt => 'Escribe el tag del rival en el buscador de arriba.';

  @override
  String get clanMates => 'COMPAÑEROS DE CLAN';

  @override
  String get compareNoClanHint => 'La API de Supercell no expone la lista de amigos del juego. Sin clan, solo puedes comparar por tag.';

  @override
  String compareClanMatesHint(String clanName) {
    return 'La API no incluye amigos del juego; aquí puedes comparar con compañeros de $clanName.';
  }

  @override
  String clanMateSubtitle(String tag, int th, int trophies) {
    return '$tag · TH$th · $trophies copas';
  }

  @override
  String get versusSeparator => ' vs ';

  @override
  String get pickOpponent => 'Elige un rival';

  @override
  String get comparePreviewSubtitle => 'TROPAS · ESTADÍSTICAS · LOGROS';

  @override
  String get changeOpponent => 'Cambiar rival';

  @override
  String get currentOpponent => 'Rival actual';

  @override
  String get compareQuickSwitch => 'Clan del rival';

  @override
  String get statsTitle => 'ESTADÍSTICAS';

  @override
  String get stats => 'Estadísticas';

  @override
  String get warLog => 'Registro De Guerra';

  @override
  String clanMembersCount(int count) {
    return 'Miembros Del Clan ($count)';
  }

  @override
  String get levelTownHall => 'Town Hall Level';

  @override
  String get levelBuilderHall => 'Builder Hall Level';

  @override
  String get levelClanCapital => 'Clan Capital';

  @override
  String get league => 'Liga';

  @override
  String get contributions => 'Contribuciones';

  @override
  String levelLabel(int level) {
    return 'Nv. $level';
  }

  @override
  String get troopGroupElixir => 'Elixir';

  @override
  String get troopGroupDarkElixir => 'Elixir oscuro';

  @override
  String get troopGroupBuilderBase => 'Base del constructor';

  @override
  String get troopGroupSiege => 'Máquinas de asedio';

  @override
  String get troopGroupPets => 'Mascotas';

  @override
  String get troopGroupOther => 'Otras tropas';

  @override
  String get spellGroupElixir => 'Elixir';

  @override
  String get spellGroupDarkElixir => 'Elixir oscuro';

  @override
  String get spellGroupOther => 'Otros hechizos';

  @override
  String get buildingGroupMain => 'Principales';

  @override
  String get buildingGroupDefense => 'Defensas';

  @override
  String get buildingGroupResource => 'Recursos';

  @override
  String get buildingGroupArmy => 'Ejército';

  @override
  String get buildingGroupTraps => 'Trampas';

  @override
  String get buildingGroupBuilderBase => 'Base del constructor';

  @override
  String get mainTownHall => 'Ayuntamiento principal';

  @override
  String get builderBaseSection => 'Base del constructor';

  @override
  String get clanAndDonations => 'Clan y donaciones';

  @override
  String get legendLeague => 'Liga leyenda';

  @override
  String get trophies => 'Trofeos';

  @override
  String get warStars => 'Estrellas de guerra';

  @override
  String get attackWins => 'Victorias ataque';

  @override
  String get defenseWins => 'Victorias defensa';

  @override
  String get warPreference => 'Preferencia de guerra';

  @override
  String get donations => 'Donaciones';

  @override
  String get donationsReceived => 'Recibidas';

  @override
  String get role => 'Rol';

  @override
  String get clan => 'Clan';

  @override
  String get townHall => 'Ayuntamiento';

  @override
  String get experience => 'Experiencia';

  @override
  String get bestRecord => 'Mejor récord';

  @override
  String get legendTrophies => 'Trofeos leyenda';

  @override
  String get currentSeason => 'Temporada actual';

  @override
  String get previousSeason => 'Temporada anterior';

  @override
  String get bestSeason => 'Mejor temporada';

  @override
  String get playerLabels => 'Etiquetas';

  @override
  String get equippedEquipment => 'Equipamiento equipado';

  @override
  String get warResultWin => 'Victoria';

  @override
  String get warResultLose => 'Derrota';

  @override
  String get warResultTie => 'Empate';

  @override
  String get warLogEmpty => 'No hay guerras recientes en el registro.';

  @override
  String get warLogLoadError => 'No se pudo cargar el registro de guerra.';

  @override
  String get capitalRaidsEmpty => 'No hay asaltos recientes al capital.';

  @override
  String get capitalRaidsLoadError => 'No se pudo cargar el historial de asaltos.';

  @override
  String get capitalRaidLoot => 'Botín total';

  @override
  String get capitalRaidRaids => 'Asaltos';

  @override
  String get capitalRaidAttacks => 'Ataques';

  @override
  String get capitalRaidDistricts => 'Distritos enemigos';

  @override
  String get achievementsHomeVillage => 'Logros · Ayuntamiento';

  @override
  String get achievementsBuilderVillage => 'Logros · Constructor';

  @override
  String get noHomeAchievements => 'Sin logros del ayuntamiento.';

  @override
  String get noBuilderAchievements => 'Sin logros del constructor.';

  @override
  String get homeVillageAchievements => 'Logros del ayuntamiento';

  @override
  String get builderVillageAchievements => 'Logros del constructor';

  @override
  String get trophiesBB => 'Trofeos BB';

  @override
  String get leagueBB => 'Liga BB';

  @override
  String get clanContribution => 'Contribución al clan';

  @override
  String get donated => 'Donadas';

  @override
  String get received => 'Recibidas';

  @override
  String get clanWarLeague => 'Clan War League';

  @override
  String get totalPoints => 'Puntos totales';

  @override
  String get location => 'Ubicación';

  @override
  String get chatLanguage => 'Idioma del chat';

  @override
  String get clanType => 'Tipo';

  @override
  String get familyFriendly => 'Apto para familias';

  @override
  String get familyFriendlyYes => 'Sí';

  @override
  String get familyFriendlyNo => 'No';

  @override
  String get playerHouse => 'Casa del jugador';

  @override
  String get playerHouseEmpty => 'Sin piezas de casa configuradas.';

  @override
  String get houseTypeGround => 'Suelo';

  @override
  String get houseTypeRoof => 'Techo';

  @override
  String get houseTypeWalls => 'Paredes';

  @override
  String get houseTypeDecoration => 'Decoración';

  @override
  String get houseTypeFoot => 'Base';

  @override
  String get houseTypeUnknown => 'Pieza';

  @override
  String houseElementId(int id) {
    return 'ID $id';
  }

  @override
  String get requiredTrophies => 'Trofeos requeridos';

  @override
  String get requiredTownHall => 'Ayuntamiento requerido';

  @override
  String get wins => 'Victorias';

  @override
  String get ties => 'Empates';

  @override
  String get losses => 'Derrotas';

  @override
  String get winStreak => 'Racha';

  @override
  String get unitCategoryTroop => 'Tropa';

  @override
  String get unitCategoryHero => 'Héroe';

  @override
  String get unitCategorySpell => 'Hechizo';

  @override
  String get unitCategoryEquipment => 'Equipamiento';

  @override
  String get unitCategoryBuilding => 'Edificio';

  @override
  String get locked => 'Bloqueado';

  @override
  String get maxLevel => 'Nivel máximo';

  @override
  String get currentLevel => 'Nivel actual';

  @override
  String get globalMax => 'Máximo global';

  @override
  String get yourTownHall => 'Tu ayuntamiento';

  @override
  String get maxInVillage => 'Máx. en tu aldea';

  @override
  String get unlockAt => 'Desbloqueo';

  @override
  String get totalLevels => 'Niveles totales';

  @override
  String get level => 'Nivel';

  @override
  String get maximum => 'Máximo';

  @override
  String get villageLabel => 'Aldea';

  @override
  String get health => 'Vida';

  @override
  String get housingSpace => 'Espacio';

  @override
  String get compareCompleted => 'Completados';

  @override
  String get starsEarned => 'Estrellas ganadas';

  @override
  String get yourProgress => 'Tu progreso';

  @override
  String get rival => 'Rival';

  @override
  String get you => 'Tú';

  @override
  String get unlocked => 'Desbloqueadas';

  @override
  String headToHeadCount(int count) {
    return 'Cara a cara ($count)';
  }

  @override
  String get levelPerTroop => 'Nivel por tropa';

  @override
  String get noSharedTroops => 'No hay tropas en común para comparar.';

  @override
  String get comparativeProfile => 'PERFIL COMPARATIVO';

  @override
  String tiesCount(int count) {
    return '$count empates';
  }

  @override
  String winsCount(int count) {
    return '$count victorias';
  }

  @override
  String get whereYouLead => 'DONDE DESTACAS';

  @override
  String get whereTheyLead => 'DONDE TE SUPERA';

  @override
  String get noClearAdvantages => 'Sin ventajas claras en esta comparación.';

  @override
  String get compareGroupTownHall => 'Ayuntamiento';

  @override
  String get compareGroupBuilder => 'Constructor';

  @override
  String get compareGroupClan => 'Clan';

  @override
  String get unitDetailStatus => 'Estado';

  @override
  String get unitDetailStats => 'Estadísticas';

  @override
  String get unitDetailProgress => 'Progreso';

  @override
  String get unitDetailHighlights => 'Destacados';

  @override
  String get unitDetailDescription => 'Descripción';

  @override
  String get unitDetailContext => 'Contexto en tu aldea';

  @override
  String get searchClanQueryHint => 'Nombre o tag con # (ej. #2GQYGPLOC)';

  @override
  String get comparePlayersPromo => 'COMPARAR JUGADORES';

  @override
  String get comparePlayersSubtitle => 'Estadísticas, gráficas y logros frente a frente.';

  @override
  String get warPreferenceIn => 'En guerra';

  @override
  String get warPreferenceOut => 'Fuera de guerra';

  @override
  String townHallBanner(int level, String suffix) {
    return 'AYUNTAMIENTO $level$suffix';
  }

  @override
  String experienceLevelLine(int level) {
    return 'Nivel de experiencia $level';
  }

  @override
  String warFrequencyLabel(String frequency) {
    return 'Frecuencia de guerra: $frequency';
  }

  @override
  String get searchClansField => 'Buscar clanes';

  @override
  String get searchClanNoResults => 'No se encontraron clanes';

  @override
  String get rankInClan => 'RANKING EN EL CLAN';

  @override
  String clanPosition(int rank) {
    return 'Posición #$rank';
  }

  @override
  String get noRankChange => 'Sin cambio';

  @override
  String get donationActivityNone => 'Sin actividad de donaciones esta temporada.';

  @override
  String donationBalance(int donatePct, int receivePct) {
    return 'Balance $donatePct% donaciones · $receivePct% recibidas';
  }

  @override
  String get compareStatsTitle => 'Comparar estadísticas';

  @override
  String get compareStatsSubtitle => 'Gráficas, logros y tropas frente a frente.';

  @override
  String get donationsShort => 'Don.';

  @override
  String get receivedShort => 'Rec.';

  @override
  String get completed => 'Completado';

  @override
  String totalAvailable(int you, int them) {
    return 'Total disponible: $you vs $them';
  }

  @override
  String maximumVs(int you, int them) {
    return 'Máximo: $you vs $them';
  }

  @override
  String get warLogTabCapital => 'Capital';

  @override
  String get warLogPrivateHint => 'El historial detallado de guerras es privado en este clan.';

  @override
  String get warLeagueLabel => 'Liga de guerra';

  @override
  String get warFrequencyShort => 'Frecuencia';

  @override
  String get winStreakLabel => 'Racha de victorias';

  @override
  String get totalWarsLabel => 'Total de guerras';

  @override
  String get winRateLabel => 'Porcentaje de victorias';

  @override
  String get builderPointsLabel => 'Puntos de constructor';

  @override
  String get requiredTrophiesLabel => 'Trofeos requeridos';

  @override
  String get membersLabel => 'Miembros';

  @override
  String get builderWarComingSoon => 'El detalle de guerras de la base del constructor estará disponible próximamente.';

  @override
  String get capitalPointsLabel => 'Puntos de capital';

  @override
  String get capitalLeagueLabel => 'Liga de capital';

  @override
  String get capitalHallLevelLabel => 'Nivel del Capital Hall';

  @override
  String get capitalDistrictsLabel => 'Distritos';

  @override
  String get clanLevelLabel => 'Nivel del clan';

  @override
  String get capitalRaidsComingSoon => 'El historial de asaltos al capital estará disponible próximamente.';

  @override
  String get warLogPrivateFooter => 'Las guerras individuales no están visibles porque el registro es privado.';

  @override
  String get unlockedStatus => 'Desbloqueado';

  @override
  String get availableInVillage => 'Disponible en tu aldea';

  @override
  String get notYetAvailable => 'Aún no disponible';

  @override
  String levelInProfile(int current, int max) {
    return 'Nivel $current de $max en tu perfil.';
  }

  @override
  String canUpgradeToLevel(int hall, int max) {
    return 'Con Ayuntamiento $hall puedes subirlo hasta nivel $max.';
  }

  @override
  String unlocksAtTownHall(int level) {
    return 'Se desbloquea con Ayuntamiento nivel $level.';
  }

  @override
  String categoryPrefix(String name) {
    return 'Categoría: $name';
  }

  @override
  String get maxLevelReachedHeadline => 'Nivel máximo alcanzado';

  @override
  String get inProgressHeadline => 'En progreso';

  @override
  String get notUnlockedHeadline => 'Sin desbloquear';

  @override
  String get allUpgradesCompleted => 'Has completado todas las mejoras disponibles en la API.';

  @override
  String levelsToMax(int remaining, int max) {
    return 'Te faltan $remaining niveles para el máximo ($max).';
  }

  @override
  String get researchWhenUnlocked => 'Investiga en el laboratorio cuando desbloquees esta unidad.';

  @override
  String get damagePerSec => 'Daño/s';

  @override
  String get healPerSec => 'Curación/s';

  @override
  String nextUpgradeLab(int level) {
    return 'Siguiente mejora requiere laboratorio nv. $level';
  }

  @override
  String estimatedCost(String cost) {
    return 'Coste estimado: $cost';
  }

  @override
  String resourceHighlight(String resource) {
    return 'Recurso: $resource';
  }

  @override
  String levelOfMaxShort(int current, int max) {
    return 'Nivel $current de $max.';
  }

  @override
  String get unitNotUnlocked => 'Esta unidad aún no está desbloqueada.';

  @override
  String availableAtCurrentTH(int level) {
    return 'Disponible con tu ayuntamiento actual (TH $level).';
  }

  @override
  String requiresTownHallLevel(int level) {
    return 'Requiere Ayuntamiento nivel $level.';
  }

  @override
  String levelSlashMax(int current, int max) {
    return 'Nivel $current / $max';
  }

  @override
  String get maxLevelReachedMessage => 'Has alcanzado el nivel máximo.';

  @override
  String levelsRemainingMessage(int count) {
    return 'Faltan $count niveles para completar.';
  }

  @override
  String upToLevel(int level) {
    return 'Hasta nv. $level';
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
  String get warLogTabHome => 'Ayuntamiento';

  @override
  String get warLogTabBuilder => 'Constructor';

  @override
  String get roleLeader => 'Líder';

  @override
  String get roleCoLeader => 'Co-Líder';

  @override
  String get roleElder => 'Anciano';

  @override
  String get roleMember => 'Miembro';

  @override
  String get unitDetailDetails => 'DETALLES';

  @override
  String townHallShort(int level) {
    return 'TH $level';
  }
}
