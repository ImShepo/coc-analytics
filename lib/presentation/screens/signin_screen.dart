import 'package:coc/l10n/locale_extensions.dart';
import 'package:flutter/material.dart';
import 'package:coc/presentation/widgets/login/custom_input.dart';
import 'package:coc/presentation/widgets/login/login_button.dart';
import 'auth_screen.dart';

class SigninScreen extends StatelessWidget {
  static const name = 'signin-screen';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScreen(
      screenTitle: l10n.signUpTitle,
      form: _SigninForm(),
      route: 'login-screen',
      actionTitle: l10n.signUpLoginAction,
      title: l10n.signUpHasAccountPrompt,
    );
  }
}

class _SigninForm extends StatefulWidget {
  @override
  State<_SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<_SigninForm> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: l10n.namePlaceholder,
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: l10n.emailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: l10n.passwordPlaceholder,
            textController: passwordCtrl,
            isPassword: true,
          ),
          const SizedBox(
            height: 20,
          ),
          LoginButton(text: l10n.signInButton, onPressed: () {})
        ],
      ),
    );
  }
}
