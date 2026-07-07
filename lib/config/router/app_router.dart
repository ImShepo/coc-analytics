import 'package:coc/presentation/screens/signin_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:coc/presentation/screens/clan_screen.dart';
import 'package:coc/presentation/screens/player_screen.dart';
import 'package:coc/presentation/screens/login_screen.dart';
import 'package:coc/presentation/screens/welcome_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
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
      path: '/player/:playerId',
      name: PlayerScreen.name,
      builder: (context, state) {
        final playerId = state.pathParameters['playerId'] ?? 'no-playerId';
        return PlayerScreen(
          playerId: playerId,
        );
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
  // redirect: (context, state) {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final isLoggingIn = state.location == '/';

  //   if (user == null && !isLoggingIn) {
  //     return '/';
  //   }
  //   if (user != null && isLoggingIn) {
  //     return '/home';
  //   }
  //   return null;
  // },
);
