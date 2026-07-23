// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get navHome => 'Início';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get searchClanPlaceholder => 'Buscar clã';

  @override
  String get welcomeSignUpOrLogin => 'Cadastre-se ou Entre';

  @override
  String get welcomeGreeting => 'Bem-vindo, ';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginNoAccountPrompt => 'Não tem uma conta?';

  @override
  String get loginCreateAccountAction => 'Crie uma agora!';

  @override
  String get signUpTitle => 'Cadastre-se';

  @override
  String get signUpHasAccountPrompt => 'Já tem uma conta?';

  @override
  String get signUpLoginAction => 'Entre agora!';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get passwordPlaceholder => 'Senha';

  @override
  String get namePlaceholder => 'Nome';

  @override
  String get signInButton => 'Entrar';

  @override
  String get createAccountButton => 'Criar conta';

  @override
  String get signingIn => 'Entrando…';

  @override
  String get signingUp => 'Criando conta…';

  @override
  String get authFieldsRequired => 'Preencha todos os campos.';

  @override
  String get signOutButton => 'Sair';

  @override
  String get signOutConfirmMessage => 'Tem certeza de que deseja sair?';

  @override
  String get accountMenuTooltip => 'Conta';

  @override
  String get unlinkPlayerButton => 'Desvincular jogador';

  @override
  String get unlinkPlayerTitle => 'Desvincular jogador';

  @override
  String get unlinkPlayerMessage => 'Isso removerá o vínculo com seu jogador do Clash of Clans. Depois você poderá vincular outra tag.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get linkPlayerTitle => 'Vincule seu jogador';

  @override
  String get linkPlayerSubtitle => 'Digite sua tag de jogador do Clash of Clans para carregar suas estatísticas. Se não joga, pode continuar sem vincular.';

  @override
  String get linkPlayerAltHelp => 'Não tem o jogo instalado? Busque seu clã, escolha seu nome e verifique com o API Token. Se não joga, pode continuar sem vincular.';

  @override
  String get linkPlayerTagPlaceholder => 'Tag do jogador (#ABC123)';

  @override
  String get linkPlayerTagRequired => 'Digite sua tag de jogador.';

  @override
  String get linkPlayerTagHelp => 'No Clash of Clans:\nAbra seu perfil (ícone da vila), vá em «Meu perfil» e copie a tag abaixo do seu nome.';

  @override
  String get linkPlayerTokenPlaceholder => 'API Token';

  @override
  String get linkPlayerTokenRequired => 'Digite o API Token do jogo.';

  @override
  String get linkPlayerTokenHelp => 'No Clash of Clans:\nVá em Ajustes → Mais ajustes, encontre a seção «API Token» e toque em «SHOW» para ver e copiar.';

  @override
  String get linkPlayerSeeGuide => 'Ver guia';

  @override
  String get linkPlayerTokenInvalid => 'Esse API Token não é válido para esta tag. Gere um novo no jogo e tente de novo.';

  @override
  String get linkPlayerPickMemberFirst => 'Escolha primeiro seu jogador na lista.';

  @override
  String linkPlayerVerifySelected(String name, String tag) {
    return 'Verificar $name ($tag)';
  }

  @override
  String get linkPlayerButton => 'Verificar e vincular';

  @override
  String get linkingPlayer => 'Verificando…';

  @override
  String get linkPlayerSkip => 'Continuar sem vincular';

  @override
  String get guestHomeUnlinkedTag => 'Sem vínculo';

  @override
  String get guestHomeLinkCta => 'Vincular meu jogador';

  @override
  String get guestHomeStatsHint => 'Vincule seu jogador para ver suas estatísticas.';

  @override
  String get guestHomeCompareHint => 'Vincule seu jogador para comparar com outros.';

  @override
  String get guestHomeClanHint => 'Vincule seu jogador para ver seu clã.';

  @override
  String get guestHomeCategoriesHint => 'Vincule seu jogador para ver tropas, heróis e mais.';

  @override
  String get linkPlayerModeTag => 'Por tag';

  @override
  String get linkPlayerModeClan => 'Por clã';

  @override
  String get linkPlayerSearchClan => 'Buscar clã';

  @override
  String get linkPlayerClanQueryHint => 'Por nome: pelo menos 3 letras. Por tag: inclua # (ex. #2GQYGPLOC).';

  @override
  String get linkPlayerPickClan => 'Escolha seu clã';

  @override
  String linkPlayerClanCount(int count) {
    return '$count clãs';
  }

  @override
  String linkPlayerMemberCount(int count) {
    return '$count jogadores';
  }

  @override
  String get linkPlayerPickMember => 'Escolha seu jogador';

  @override
  String get linkPlayerLookupOnline => 'Buscar tag online';

  @override
  String get browseHomeTitle => 'Explorar';

  @override
  String get browseHomeSubtitle => 'Busque clãs ou consulte qualquer jogador. Vincule o seu quando quiser ver suas estatísticas.';

  @override
  String get browseLookupPlayerTitle => 'Consultar jogador';

  @override
  String get browseLookupPlayerButton => 'Ver jogador';

  @override
  String get browseLinkPlayerCta => 'Vincular meu jogador';

  @override
  String get termsAndConditions => 'Termos e condições de uso';

  @override
  String get googleSignIn => 'Entrar com Google';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get dataRefreshing => 'Atualizando dados…';

  @override
  String get dataUpdatedJustNow => 'Atualizado agora';

  @override
  String dataUpdatedAgo(int minutes) {
    return 'Atualizado há $minutes min';
  }

  @override
  String get dataRefreshFailed => 'Não foi possível atualizar. Mostrando dados salvos.';

  @override
  String get playerErrorForbiddenHint => 'Se você vir \"Forbidden\", atualize COC_KEY no arquivo .env com uma chave de API válida de developer.clashofclans.com';

  @override
  String get apiErrorPlayerNotFound => 'Não encontramos um jogador com essa tag. Confira se está escrita corretamente.';

  @override
  String get apiErrorBadRequest => 'Consulta inválida. Verifique a tag e tente de novo.';

  @override
  String get apiErrorUnauthorized => 'Não autorizado. Verifique a configuração da API.';

  @override
  String get apiErrorForbidden => 'Acesso negado. Verifique sua chave de API no arquivo .env.';

  @override
  String get apiErrorRateLimited => 'Muitas consultas. Aguarde um momento e tente de novo.';

  @override
  String get apiErrorServer => 'O servidor não está disponível. Tente mais tarde.';

  @override
  String get apiErrorNetwork => 'Erro de conexão. Verifique sua internet.';

  @override
  String get apiErrorUnexpected => 'Ocorreu um erro inesperado. Tente de novo.';

  @override
  String get yourStats => 'Suas Estatísticas';

  @override
  String get seeAll => 'Ver Todas';

  @override
  String get compare => 'Comparar';

  @override
  String get open => 'Abrir';

  @override
  String get yourClan => 'Seu Clã';

  @override
  String get seeMore => 'Ver Mais';

  @override
  String get playerNotInClan => 'Este jogador não está em um clã.';

  @override
  String get categories => 'Categorias';

  @override
  String get categoryTroops => 'Tropas';

  @override
  String get categoryBuildings => 'Edifícios';

  @override
  String get categoryHeroes => 'Heróis';

  @override
  String get categorySpells => 'Feitiços';

  @override
  String get categoryCollapseHint => 'Toque em um cabeçalho para recolher ou expandir uma seção.';

  @override
  String get noTroopsRegistered => 'Nenhuma tropa registrada.';

  @override
  String get noSpellsRegistered => 'Nenhum feitiço registrado.';

  @override
  String get noBuildingsRegistered => 'Nenhum edifício registrado.';

  @override
  String get noHeroesOrEquipmentRegistered => 'Nenhum herói ou equipamento registrado.';

  @override
  String get equipment => 'Equipamento';

  @override
  String get superTroopActive => 'Super ativa';

  @override
  String get superTroopActiveBadge => 'SUPER';

  @override
  String get levelPerUnit => 'Nível por unidade';

  @override
  String get noUnitsToCompare => 'Não há unidades em comum para comparar.';

  @override
  String get troopsInProfile => 'tropas no seu perfil';

  @override
  String get buildingsInVillage => 'edifícios na sua vila';

  @override
  String get heroesAndEquipment => 'heróis e equipamento';

  @override
  String get spellsInProfile => 'feitiços no seu perfil';

  @override
  String get troopsAndUnits => 'Tropas e unidades';

  @override
  String get troopsLoadError => 'Não foi possível carregar as tropas.';

  @override
  String get compareTitle => 'COMPARAR';

  @override
  String get compareSelfError => 'Você não pode se comparar consigo mesmo';

  @override
  String get compareRecentSearches => 'Pesquisas recentes';

  @override
  String get compareClearRecent => 'Limpar';

  @override
  String get compareNoRecentMatches => 'Sem coincidências no histórico';

  @override
  String get opponentDefaultName => 'Rival';

  @override
  String get versus => 'VS';

  @override
  String get compareTabSummary => 'Resumo';

  @override
  String get compareTabStats => 'Estatísticas';

  @override
  String get compareTabAchievements => 'Conquistas';

  @override
  String get compareTabTroops => 'Tropas';

  @override
  String get opponentTagHint => 'Tag do rival (#ABC123)';

  @override
  String get search => 'Buscar';

  @override
  String get compareEnterTagPrompt => 'Digite a tag do rival na barra de busca acima.';

  @override
  String get clanMates => 'COMPANHEIROS DE CLÃ';

  @override
  String get compareNoClanHint => 'A API da Supercell não expõe a lista de amigos do jogo. Sem clã, você só pode comparar por tag.';

  @override
  String compareClanMatesHint(String clanName) {
    return 'A API não inclui amigos do jogo; aqui você pode comparar com membros de $clanName.';
  }

  @override
  String clanMateSubtitle(String tag, int th, int trophies) {
    return '$tag · TH$th · $trophies troféus';
  }

  @override
  String get versusSeparator => ' vs ';

  @override
  String get pickOpponent => 'Escolha um rival';

  @override
  String get comparePreviewSubtitle => 'TROPAS · ESTATÍSTICAS · CONQUISTAS';

  @override
  String get changeOpponent => 'Mudar rival';

  @override
  String get currentOpponent => 'Rival atual';

  @override
  String get compareQuickSwitch => 'Clã do rival';

  @override
  String get statsTitle => 'ESTATÍSTICAS';

  @override
  String get stats => 'Estatísticas';

  @override
  String get warLog => 'Registro de Guerra';

  @override
  String clanMembersCount(int count) {
    return 'Membros do Clã ($count)';
  }

  @override
  String get levelTownHall => 'Nível do Centro de Vila';

  @override
  String get levelBuilderHall => 'Nível do Centro de Construtor';

  @override
  String get levelClanCapital => 'Capital do Clã';

  @override
  String get league => 'Liga';

  @override
  String get contributions => 'Contribuições';

  @override
  String levelLabel(int level) {
    return 'Nv. $level';
  }

  @override
  String get troopGroupElixir => 'Elixir';

  @override
  String get troopGroupDarkElixir => 'Elixir negro';

  @override
  String get troopGroupBuilderBase => 'Base do construtor';

  @override
  String get troopGroupSiege => 'Máquinas de cerco';

  @override
  String get troopGroupPets => 'Mascotes';

  @override
  String get troopGroupOther => 'Outras tropas';

  @override
  String get spellGroupElixir => 'Elixir';

  @override
  String get spellGroupDarkElixir => 'Elixir negro';

  @override
  String get spellGroupOther => 'Outros feitiços';

  @override
  String get buildingGroupMain => 'Principais';

  @override
  String get buildingGroupDefense => 'Defesas';

  @override
  String get buildingGroupResource => 'Recursos';

  @override
  String get buildingGroupArmy => 'Exército';

  @override
  String get buildingGroupTraps => 'Armadilhas';

  @override
  String get buildingGroupBuilderBase => 'Base do construtor';

  @override
  String get mainTownHall => 'Prefeitura principal';

  @override
  String get builderBaseSection => 'Base do construtor';

  @override
  String get clanAndDonations => 'Clã e doações';

  @override
  String get legendLeague => 'Liga lenda';

  @override
  String get trophies => 'Troféus';

  @override
  String get warStars => 'Estrelas de guerra';

  @override
  String get attackWins => 'Vitórias de ataque';

  @override
  String get defenseWins => 'Vitórias de defesa';

  @override
  String get warPreference => 'Preferência de guerra';

  @override
  String get donations => 'Doações';

  @override
  String get donationsReceived => 'Recebidas';

  @override
  String get role => 'Função';

  @override
  String get clan => 'Clã';

  @override
  String get townHall => 'Prefeitura';

  @override
  String get experience => 'Experiência';

  @override
  String get bestRecord => 'Melhor recorde';

  @override
  String get legendTrophies => 'Troféus lenda';

  @override
  String get currentSeason => 'Temporada atual';

  @override
  String get previousSeason => 'Temporada anterior';

  @override
  String get bestSeason => 'Melhor temporada';

  @override
  String get playerLabels => 'Etiquetas';

  @override
  String get equippedEquipment => 'Equipamento equipado';

  @override
  String get warResultWin => 'Vitória';

  @override
  String get warResultLose => 'Derrota';

  @override
  String get warResultTie => 'Empate';

  @override
  String get warLogEmpty => 'Não há guerras recentes no registro.';

  @override
  String get warLogLoadError => 'Não foi possível carregar o registro de guerra.';

  @override
  String get capitalRaidsEmpty => 'Não há assaltos recentes ao capital.';

  @override
  String get capitalRaidsLoadError => 'Não foi possível carregar o histórico de assaltos.';

  @override
  String get capitalRaidLoot => 'Saque total';

  @override
  String get capitalRaidRaids => 'Assaltos';

  @override
  String get capitalRaidAttacks => 'Ataques';

  @override
  String get capitalRaidDistricts => 'Distritos inimigos';

  @override
  String get achievementsHomeVillage => 'Conquistas · Principal';

  @override
  String get achievementsBuilderVillage => 'Conquistas · Construtor';

  @override
  String get noHomeAchievements => 'Sem conquistas da vila principal.';

  @override
  String get noBuilderAchievements => 'Sem conquistas do construtor.';

  @override
  String get homeVillageAchievements => 'Conquistas da vila principal';

  @override
  String get builderVillageAchievements => 'Conquistas do construtor';

  @override
  String get trophiesBB => 'Troféus BC';

  @override
  String get leagueBB => 'Liga BC';

  @override
  String get clanContribution => 'Contribuição ao clã';

  @override
  String get donated => 'Doadas';

  @override
  String get received => 'Recebidas';

  @override
  String get clanWarLeague => 'Liga de Guerra de Clãs';

  @override
  String get totalPoints => 'Pontos totais';

  @override
  String get location => 'Localização';

  @override
  String get chatLanguage => 'Idioma do chat';

  @override
  String get clanType => 'Tipo';

  @override
  String get familyFriendly => 'Adequado para famílias';

  @override
  String get familyFriendlyYes => 'Sim';

  @override
  String get familyFriendlyNo => 'Não';

  @override
  String get playerHouse => 'Casa do jogador';

  @override
  String get playerHouseEmpty => 'Nenhuma peça da casa configurada.';

  @override
  String get houseTypeGround => 'Chão';

  @override
  String get houseTypeRoof => 'Telhado';

  @override
  String get houseTypeWalls => 'Paredes';

  @override
  String get houseTypeDecoration => 'Decoração';

  @override
  String get houseTypeFoot => 'Base';

  @override
  String get houseTypeUnknown => 'Peça';

  @override
  String houseElementId(int id) {
    return 'ID $id';
  }

  @override
  String get requiredTrophies => 'Troféus exigidos';

  @override
  String get requiredTownHall => 'Prefeitura exigida';

  @override
  String get wins => 'Vitórias';

  @override
  String get ties => 'Empates';

  @override
  String get losses => 'Derrotas';

  @override
  String get winStreak => 'Sequência';

  @override
  String get unitCategoryTroop => 'Tropa';

  @override
  String get unitCategoryHero => 'Herói';

  @override
  String get unitCategorySpell => 'Feitiço';

  @override
  String get unitCategoryEquipment => 'Equipamento';

  @override
  String get unitCategoryBuilding => 'Edifício';

  @override
  String get locked => 'Bloqueado';

  @override
  String get maxLevel => 'Nível máximo';

  @override
  String get currentLevel => 'Nível atual';

  @override
  String get globalMax => 'Máximo global';

  @override
  String get yourTownHall => 'Sua prefeitura';

  @override
  String get maxInVillage => 'Máx. na sua vila';

  @override
  String get unlockAt => 'Desbloqueio';

  @override
  String get totalLevels => 'Níveis totais';

  @override
  String get level => 'Nível';

  @override
  String get maximum => 'Máximo';

  @override
  String get villageLabel => 'Vila';

  @override
  String get health => 'Vida';

  @override
  String get housingSpace => 'Espaço';

  @override
  String get compareCompleted => 'Completados';

  @override
  String get starsEarned => 'Estrelas ganhas';

  @override
  String get yourProgress => 'Seu progresso';

  @override
  String get rival => 'Rival';

  @override
  String get you => 'Você';

  @override
  String get unlocked => 'Desbloqueadas';

  @override
  String headToHeadCount(int count) {
    return 'Cara a cara ($count)';
  }

  @override
  String get levelPerTroop => 'Nível por tropa';

  @override
  String get noSharedTroops => 'Não há tropas em comum para comparar.';

  @override
  String get comparativeProfile => 'PERFIL COMPARATIVO';

  @override
  String tiesCount(int count) {
    return '$count empates';
  }

  @override
  String winsCount(int count) {
    return '$count vitórias';
  }

  @override
  String get whereYouLead => 'ONDE VOCÊ DESTACA';

  @override
  String get whereTheyLead => 'ONDE ELE DESTACA';

  @override
  String get noClearAdvantages => 'Sem vantagens claras nesta comparação.';

  @override
  String get compareGroupTownHall => 'Prefeitura';

  @override
  String get compareGroupBuilder => 'Construtor';

  @override
  String get compareGroupClan => 'Clã';

  @override
  String get unitDetailStatus => 'Estado';

  @override
  String get unitDetailStats => 'Estatísticas';

  @override
  String get unitDetailProgress => 'Progresso';

  @override
  String get unitDetailHighlights => 'Destaques';

  @override
  String get unitDetailDescription => 'Descrição';

  @override
  String get unitDetailContext => 'Contexto na sua vila';

  @override
  String get searchClanQueryHint => 'Nome ou tag com # (ex. #2GQYGPLOC)';

  @override
  String get comparePlayersPromo => 'COMPARAR JOGADORES';

  @override
  String get comparePlayersSubtitle => 'Estatísticas, gráficos e conquistas frente a frente.';

  @override
  String get warPreferenceIn => 'Em guerra';

  @override
  String get warPreferenceOut => 'Fora de guerra';

  @override
  String townHallBanner(int level, String suffix) {
    return 'PREFEITURA $level$suffix';
  }

  @override
  String experienceLevelLine(int level) {
    return 'Nível de experiência $level';
  }

  @override
  String warFrequencyLabel(String frequency) {
    return 'Frequência de guerra: $frequency';
  }

  @override
  String get searchClansField => 'Buscar clãs';

  @override
  String get searchClanNoResults => 'Nenhum clã encontrado';

  @override
  String get rankInClan => 'RANKING NO CLÃ';

  @override
  String clanPosition(int rank) {
    return 'Posição #$rank';
  }

  @override
  String get noRankChange => 'Sem alteração';

  @override
  String get donationActivityNone => 'Sem atividade de doações nesta temporada.';

  @override
  String donationBalance(int donatePct, int receivePct) {
    return 'Saldo $donatePct% doações · $receivePct% recebidas';
  }

  @override
  String get compareStatsTitle => 'Comparar estatísticas';

  @override
  String get compareStatsSubtitle => 'Gráficos, conquistas e tropas frente a frente.';

  @override
  String get donationsShort => 'Doa.';

  @override
  String get receivedShort => 'Rec.';

  @override
  String get completed => 'Concluído';

  @override
  String totalAvailable(int you, int them) {
    return 'Total disponível: $you vs $them';
  }

  @override
  String maximumVs(int you, int them) {
    return 'Máximo: $you vs $them';
  }

  @override
  String get warLogTabCapital => 'Capital';

  @override
  String get warLogPrivateHint => 'O histórico detalhado de guerras é privado neste clã.';

  @override
  String get warLeagueLabel => 'Liga de guerra';

  @override
  String get warFrequencyShort => 'Frequência';

  @override
  String get winStreakLabel => 'Sequência de vitórias';

  @override
  String get totalWarsLabel => 'Total de guerras';

  @override
  String get winRateLabel => 'Taxa de vitórias';

  @override
  String get builderPointsLabel => 'Pontos do construtor';

  @override
  String get requiredTrophiesLabel => 'Troféus necessários';

  @override
  String get membersLabel => 'Membros';

  @override
  String get builderWarComingSoon => 'Detalhes de guerras da base do construtor em breve.';

  @override
  String get capitalPointsLabel => 'Pontos de capital';

  @override
  String get capitalLeagueLabel => 'Liga de capital';

  @override
  String get capitalHallLevelLabel => 'Nível do Capital Hall';

  @override
  String get capitalDistrictsLabel => 'Distritos';

  @override
  String get clanLevelLabel => 'Nível do clã';

  @override
  String get capitalRaidsComingSoon => 'Histórico de assaltos ao capital em breve.';

  @override
  String get warLogPrivateFooter => 'Guerras individuais não visíveis porque o registro é privado.';

  @override
  String get unlockedStatus => 'Desbloqueado';

  @override
  String get availableInVillage => 'Disponível na sua vila';

  @override
  String get notYetAvailable => 'Ainda não disponível';

  @override
  String levelInProfile(int current, int max) {
    return 'Nível $current de $max no seu perfil.';
  }

  @override
  String canUpgradeToLevel(int hall, int max) {
    return 'Com Prefeitura $hall pode subir até nível $max.';
  }

  @override
  String unlocksAtTownHall(int level) {
    return 'Desbloqueia com Prefeitura nível $level.';
  }

  @override
  String categoryPrefix(String name) {
    return 'Categoria: $name';
  }

  @override
  String get maxLevelReachedHeadline => 'Nível máximo alcançado';

  @override
  String get inProgressHeadline => 'Em progresso';

  @override
  String get notUnlockedHeadline => 'Não desbloqueado';

  @override
  String get allUpgradesCompleted => 'Completou todas as melhorias disponíveis na API.';

  @override
  String levelsToMax(int remaining, int max) {
    return 'Faltam $remaining níveis para o máximo ($max).';
  }

  @override
  String get researchWhenUnlocked => 'Pesquise no laboratório quando desbloquear esta unidade.';

  @override
  String get damagePerSec => 'Dano/s';

  @override
  String get healPerSec => 'Cura/s';

  @override
  String nextUpgradeLab(int level) {
    return 'Próxima melhoria requer laboratório nv. $level';
  }

  @override
  String estimatedCost(String cost) {
    return 'Custo estimado: $cost';
  }

  @override
  String resourceHighlight(String resource) {
    return 'Recurso: $resource';
  }

  @override
  String levelOfMaxShort(int current, int max) {
    return 'Nível $current de $max.';
  }

  @override
  String get unitNotUnlocked => 'Esta unidade ainda não está desbloqueada.';

  @override
  String availableAtCurrentTH(int level) {
    return 'Disponível com sua prefeitura atual (TH $level).';
  }

  @override
  String requiresTownHallLevel(int level) {
    return 'Requer Prefeitura nível $level.';
  }

  @override
  String levelSlashMax(int current, int max) {
    return 'Nível $current / $max';
  }

  @override
  String get maxLevelReachedMessage => 'Alcançou o nível máximo.';

  @override
  String levelsRemainingMessage(int count) {
    return 'Faltam $count níveis para completar.';
  }

  @override
  String upToLevel(int level) {
    return 'Até nv. $level';
  }

  @override
  String get available => 'Disponível';

  @override
  String requiresTownHallShort(int level) {
    return 'TH $level+';
  }

  @override
  String get villageHomeShort => 'Principal';

  @override
  String get warLogTabHome => 'Prefeitura';

  @override
  String get warLogTabBuilder => 'Construtor';

  @override
  String get roleLeader => 'Líder';

  @override
  String get roleCoLeader => 'Co-Líder';

  @override
  String get roleElder => 'Ancião';

  @override
  String get roleMember => 'Membro';

  @override
  String get unitDetailDetails => 'DETALHES';

  @override
  String townHallShort(int level) {
    return 'TH $level';
  }
}
