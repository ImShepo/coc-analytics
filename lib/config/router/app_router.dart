import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/screens/clan_screen.dart';
import 'package:coc/presentation/screens/link_player_screen.dart';
import 'package:coc/presentation/screens/login_screen.dart';
import 'package:coc/presentation/screens/player_screen.dart';
import 'package:coc/presentation/screens/signin_screen.dart';
import 'package:coc/presentation/screens/welcome_screen.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(authRouterRefreshProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final tagAsync = ref.read(linkedPlayerTagProvider);
      final deferredAsync = ref.read(linkDeferredProvider);
      final welcomeAsync = ref.read(hasSeenWelcomeProvider);
      final loc = state.matchedLocation;

      final authGate = loc == '/' || loc == '/login' || loc == '/register';
      final loggingIn = authGate || loc == '/link-player';

      if (auth.isLoading || welcomeAsync.isLoading) {
        return null;
      }

      // Profile fetch should not freeze navigation. If it errored, treat as empty.
      if ((tagAsync.isLoading && !tagAsync.hasError) ||
          (deferredAsync.isLoading && !deferredAsync.hasError)) {
        return null;
      }

      final user = auth.valueOrNull;
      final tag = tagAsync.asData?.value;
      final deferred = deferredAsync.asData?.value ?? false;
      final hasSeenWelcome = welcomeAsync.valueOrNull ?? false;
      final isLoggedIn = user != null;
      final hasTag = tag != null && tag.isNotEmpty;

      if (!isLoggedIn) {
        if (!hasSeenWelcome) {
          // First launch after install → welcome only.
          if (loc == '/') return null;
          return '/';
        }
        // Returning user signed out → login (welcome never again).
        if (loc == '/login' || loc == '/register') return null;
        return '/login';
      }

      if (hasTag) {
        final routeTag = AuthService.playerTagForRoute(tag);
        if (loggingIn || loc == '/' || loc == '/home') {
          return '/player/$routeTag';
        }
        return null;
      }

      // Logged in, no linked player → Inicio (guest home).
      if (deferred) {
        if (authGate || loc == '/') return '/home';
        return null;
      }

      if (loc == '/link-player') return null;
      return '/link-player';
    },
    routes: [
      GoRoute(
        path: '/',
        name: WelcomeScreen.name,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: SigninScreen.name,
        builder: (context, state) => const SigninScreen(),
      ),
      GoRoute(
        path: '/link-player',
        name: LinkPlayerScreen.name,
        builder: (context, state) => const LinkPlayerScreen(),
      ),
      GoRoute(
        path: '/home',
        name: PlayerScreen.name,
        builder: (context, state) => const PlayerScreen(playerId: null),
      ),
      GoRoute(
        path: '/player/:playerId',
        name: '${PlayerScreen.name}-tagged',
        builder: (context, state) {
          final playerId = state.pathParameters['playerId'] ?? 'no-playerId';
          return PlayerScreen(playerId: playerId);
        },
      ),
      GoRoute(
        path: '/clan/:clanId',
        name: ClanScreen.name,
        builder: (context, state) {
          final clanId = state.pathParameters['clanId'] ?? 'no-clanId';
          return ClanScreen(clanId: clanId);
        },
      ),
    ],
  );
});
