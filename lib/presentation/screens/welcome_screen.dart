import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/screens/login_screen.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerWidget {
  static const name = 'welcome-screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/WelcomeBackground.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GlassButton(
                label: context.l10n.welcomeSignUpOrLogin,
                onPressed: () async {
                  await ref.read(hasSeenWelcomeProvider.notifier).markSeen();
                  if (!context.mounted) return;
                  context.goNamed(LoginScreen.name);
                },
                style: GlassButtonStyle.primary,
                expanded: true,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
