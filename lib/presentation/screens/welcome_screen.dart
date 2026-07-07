import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/screens/login_screen.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const name = 'welcome-screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
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
