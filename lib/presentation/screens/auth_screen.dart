import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/floating_language_fab.dart';
import 'package:flutter/material.dart';
import 'package:coc/presentation/widgets/login/mountain_painter.dart';
import 'package:coc/presentation/widgets/login/logo.dart';
import 'package:coc/presentation/widgets/login/labels.dart';
import 'package:coc/presentation/widgets/login/google_sign_in_button.dart';
import 'package:coc/services/google_signin_service.dart';

class AuthScreen extends StatelessWidget {
  final String screenTitle;
  final Widget form;
  final String route;
  final String title;
  final String actionTitle;

  const AuthScreen({
    required this.screenTitle,
    required this.form,
    required this.route,
    required this.title,
    required this.actionTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: MountainPainter(color: colorScheme.secondary),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Logo(title: screenTitle),
                  form,
                  Labels(
                    route: route,
                    title: title,
                    actionTitle: actionTitle,
                  ),
                  GoogleSignInButton(
                    onPressed: GoogleSigninService.signInWithGoogle,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          text: context.l10n.termsAndConditions,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          children: [
                            TextSpan(
                              text: '\u200B',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: colorScheme.primary,
                                decorationThickness: 2,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          const FloatingLanguageFab.topTrailing(),
        ],
      ),
    );
  }
}
