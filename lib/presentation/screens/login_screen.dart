import 'package:coc/l10n/locale_extensions.dart';
import 'package:flutter/material.dart';
import 'package:coc/presentation/widgets/login/custom_input.dart';
import 'package:coc/presentation/widgets/login/login_button.dart';
import 'package:go_router/go_router.dart';
import 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScreen(
      screenTitle: l10n.loginTitle,
      form: _LoginForm(),
      route: 'signin-screen',
      actionTitle: l10n.loginCreateAccountAction,
      title: l10n.loginNoAccountPrompt,
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
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
          LoginButton(
            text: l10n.signInButton,
            onPressed: () {
              // context.push('/player/${player.id}');
              context.push('/player/8PLJULOVC');
            },
          ),
        ],
      ),
    );
  }
}
