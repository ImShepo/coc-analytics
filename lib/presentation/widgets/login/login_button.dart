import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const LoginButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      label: text,
      onPressed: onPressed,
      style: GlassButtonStyle.primary,
      expanded: true,
      height: 55,
      borderRadius: BorderRadius.circular(24),
    );
  }
}
