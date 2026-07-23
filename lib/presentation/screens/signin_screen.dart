import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/widgets/login/auto_clear_error.dart';
import 'package:coc/presentation/widgets/login/custom_input.dart';
import 'package:coc/presentation/widgets/login/login_button.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_screen.dart';

class SigninScreen extends StatelessWidget {
  static const name = 'signin-screen';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScreen(
      screenTitle: l10n.signUpTitle,
      form: const _SigninForm(),
      route: 'login-screen',
      actionTitle: l10n.signUpLoginAction,
      title: l10n.signUpHasAccountPrompt,
    );
  }
}

class _SigninForm extends ConsumerStatefulWidget {
  const _SigninForm();

  @override
  ConsumerState<_SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends ConsumerState<_SigninForm>
    with AutoClearErrorMixin {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showAuthError(context.l10n.authFieldsRequired);
      return;
    }

    clearAuthError();
    setState(() => _loading = true);

    try {
      await ref.read(authServiceProvider).registerWithEmail(
            name: name,
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
            icon: Icons.perm_identity,
            placeholder: l10n.namePlaceholder,
            keyboardType: TextInputType.text,
            textController: nameCtrl,
            dense: shortScreen,
          ),
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
            text: _loading ? l10n.signingUp : l10n.createAccountButton,
            onPressed: _loading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
