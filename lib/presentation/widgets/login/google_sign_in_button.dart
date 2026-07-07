import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({super.key, this.onPressed});

  static const Color _label = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: LiquidGlassSurface(
          borderRadius: BorderRadius.circular(24),
          tintColor: Colors.white,
          tintStrength: 0.6,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/google_logo.png',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.googleSignIn,
                  style: const TextStyle(
                    fontFamily: AppFonts.primary,
                    color: _label,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
