import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/widgets/floating_language_fab.dart';
import 'package:coc/presentation/widgets/login/auto_clear_error.dart';
import 'package:coc/presentation/widgets/login/google_sign_in_button.dart';
import 'package:coc/presentation/widgets/login/labels.dart';
import 'package:coc/presentation/widgets/login/logo.dart';
import 'package:coc/presentation/widgets/login/mountain_painter.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends ConsumerStatefulWidget {
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
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with AutoClearErrorMixin {
  bool _googleLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _googleLoading = true);
    clearAuthError();
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } on AuthException catch (e) {
      showAuthError(e.message);
    } catch (e) {
      showAuthError(e.toString());
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final shortScreen = MediaQuery.sizeOf(context).height < 720;

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
                  Logo(title: widget.screenTitle, compact: shortScreen),
                  widget.form,
                  Labels(
                    route: widget.route,
                    title: widget.title,
                    actionTitle: widget.actionTitle,
                  ),
                  Column(
                    children: [
                      GoogleSignInButton(
                        onPressed: _googleLoading ? null : _signInWithGoogle,
                      ),
                      if (_googleLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      if (authError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            authError!,
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://imshepo.github.io/coc-analytics/terms.html',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(
                      l10n.termsAndConditions,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
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
