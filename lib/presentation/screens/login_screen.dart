import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/widgets/login/auto_clear_error.dart';
import 'package:coc/presentation/widgets/login/custom_input.dart';
import 'package:coc/presentation/widgets/login/login_button.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScreen(
      screenTitle: l10n.loginTitle,
      form: const _LoginForm(),
      route: 'signin-screen',
      actionTitle: l10n.loginCreateAccountAction,
      title: l10n.loginNoAccountPrompt,
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends ConsumerState<_LoginForm>
    with AutoClearErrorMixin {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      showAuthError(context.l10n.authFieldsRequired);
      return;
    }

    clearAuthError();
    setState(() => _loading = true);

    try {
      await ref.read(authServiceProvider).signInWithEmail(
            email: email,
            password: password,
          );
    } on AuthException catch (e) {
      showAuthError(e.message);
    } catch (e) {
      showAuthError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shortScreen = MediaQuery.sizeOf(context).height < 720;

    return Container(
      margin: EdgeInsets.only(top: shortScreen ? 8 : 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: l10n.emailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
            dense: shortScreen,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: l10n.passwordPlaceholder,
            textController: passwordCtrl,
            isPassword: true,
            dense: shortScreen,
          ),
          if (authError != null) ...[
            const SizedBox(height: 8),
            Text(
              authError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: shortScreen ? 12 : 20),
          LoginButton(
            text: _loading ? l10n.signingIn : l10n.signInButton,
            onPressed: _loading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
