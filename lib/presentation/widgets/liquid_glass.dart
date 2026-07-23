import 'dart:ui';

import 'package:coc/config/theme/app_fonts.dart';
import 'package:flutter/material.dart';

/// Visual styles for [GlassButton] and [GlassTextButton].
enum GlassButtonStyle {
  /// Green-tinted glass, white label (main CTAs).
  primary,

  /// Frosted white glass, dark label (secondary / Google).
  light,

  /// Frosted glass on dark headers, white label.
  ghostOnDark,

  /// Light glass pill, green label (links, search).
  accent,
}

/// Frosted liquid-glass surface shared by buttons and controls.
class LiquidGlassSurface extends StatelessWidget {
  final Widget? child;
  final BorderRadius? borderRadius;
  final bool circular;
  final EdgeInsetsGeometry padding;
  final Color? tintColor;
  final double tintStrength;
  final bool enableBlur;

  const LiquidGlassSurface({
    super.key,
    required this.child,
    this.borderRadius,
    this.circular = false,
    this.padding = EdgeInsets.zero,
    this.tintColor,
    this.tintStrength = 0.72,
    this.enableBlur = true,
  });

  List<Color> get _gradientColors {
    if (tintColor == null) {
      return [
        Colors.white.withValues(alpha: 0.34),
        Colors.white.withValues(alpha: 0.14),
      ];
    }
    final t = tintStrength.clamp(0.0, 1.0);
    return [
      Color.alphaBlend(Colors.white.withValues(alpha: 0.28), tintColor!),
      Color.alphaBlend(Colors.white.withValues(alpha: 0.1), tintColor!),
    ].map((c) => Color.lerp(c, tintColor, t * 0.35) ?? c).toList();
  }

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: circular ? null : (borderRadius ?? BorderRadius.circular(28)),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
        border: Border.all(
          color: tintColor != null
              ? Colors.white.withValues(alpha: 0.42)
              : Colors.white.withValues(alpha: 0.48),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (tintColor ?? Colors.black).withValues(alpha: tintColor != null ? 0.18 : 0.14),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final decorated = DecoratedBox(
      decoration: _decoration,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    final content = enableBlur
        ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: decorated,
          )
        : decorated;

    if (circular) {
      return ClipOval(child: content);
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(28),
      child: content,
    );
  }
}

/// Primary / secondary pill button with liquid-glass finish.
class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GlassButtonStyle style;
  final bool expanded;
  final double height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool selected;
  final bool enableBlur;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = GlassButtonStyle.primary,
    this.expanded = false,
    this.height = 48,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.selected = false,
    this.enableBlur = true,
  });

  const GlassButton.compact({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = GlassButtonStyle.primary,
    this.selected = false,
  })  : expanded = false,
        height = 38,
        borderRadius = const BorderRadius.all(Radius.circular(14)),
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        enableBlur = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveStyle = selected ? GlassButtonStyle.primary : style;
    final colors = _resolveColors(colorScheme, effectiveStyle);
    final enabled = onPressed != null;

    final content = LiquidGlassSurface(
      borderRadius: borderRadius,
      tintColor: colors.tint,
      tintStrength: colors.tintStrength,
      padding: padding,
      enableBlur: enableBlur,
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: colors.foreground.withValues(alpha: enabled ? 1 : 0.5)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: colors.foreground.withValues(alpha: enabled ? 1 : 0.5),
                fontSize: style == GlassButtonStyle.ghostOnDark ? 11 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: expanded
            ? SizedBox(width: double.infinity, height: height, child: content)
            : SizedBox(height: height, child: content),
      ),
    );

    return Opacity(opacity: enabled ? 1 : 0.55, child: button);
  }
}

/// Compact text/icon control (app bar actions, section links, search).
class GlassTextButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GlassButtonStyle style;

  const GlassTextButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = GlassButtonStyle.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = _resolveColors(colorScheme, style);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: LiquidGlassSurface(
          borderRadius: BorderRadius.circular(20),
          tintColor: colors.tint,
          tintStrength: colors.tintStrength * 0.65,
          padding: EdgeInsets.symmetric(
            horizontal: icon != null ? 10 : 12,
            vertical: icon != null ? 6 : 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: colors.foreground),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: colors.foreground,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggle chip for category / war tabs.
class GlassChipButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onPressed;

  const GlassChipButton({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      selected: selected,
      style: selected ? GlassButtonStyle.primary : GlassButtonStyle.light,
      height: 34,
      borderRadius: BorderRadius.circular(18),
      enableBlur: false,
      padding: EdgeInsets.symmetric(
        horizontal: icon != null ? 12 : 14,
        vertical: 6,
      ),
    );
  }
}

class _GlassColors {
  final Color? tint;
  final double tintStrength;
  final Color foreground;

  const _GlassColors({
    required this.tint,
    required this.tintStrength,
    required this.foreground,
  });
}

_GlassColors _resolveColors(ColorScheme scheme, GlassButtonStyle style) {
  return switch (style) {
    GlassButtonStyle.primary => _GlassColors(
        tint: scheme.primary,
        tintStrength: 0.82,
        foreground: Colors.white,
      ),
    GlassButtonStyle.light => const _GlassColors(
        tint: Colors.white,
        tintStrength: 0.55,
        foreground: Color(0xFF3B3B3B),
      ),
    GlassButtonStyle.ghostOnDark => _GlassColors(
        tint: null,
        tintStrength: 0,
        foreground: Colors.white.withValues(alpha: 0.95),
      ),
    GlassButtonStyle.accent => _GlassColors(
        tint: scheme.secondary,
        tintStrength: 0.35,
        foreground: scheme.primary,
      ),
  };
}

/// Circular icon control with liquid-glass finish.
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final GlassButtonStyle style;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 32,
    this.iconSize = 18,
    this.style = GlassButtonStyle.light,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = _resolveColors(colorScheme, style);

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: SizedBox(
          width: size,
          height: size,
          child: LiquidGlassSurface(
            circular: true,
            tintColor: colors.tint,
            tintStrength: colors.tintStrength * 0.7,
            child: Center(
              child: Icon(
                icon,
                size: iconSize,
                color: colors.foreground,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) return button;

    return Tooltip(message: tooltip!, child: button);
  }
}

/// Circular liquid-glass back button for app bars and overlays.
class GlassBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final EdgeInsetsGeometry margin;

  const GlassBackButton({
    super.key,
    this.onPressed,
    this.size = 30,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final action = onPressed ?? () => Navigator.of(context).maybePop();

    return Padding(
      padding: margin,
      child: Semantics(
        button: true,
        label: MaterialLocalizations.of(context).backButtonTooltip,
        child: GestureDetector(
          onTap: action,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: size,
            height: size,
            child: LiquidGlassSurface(
              circular: true,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(1, 0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard app-bar leading slot for [GlassBackButton].
class GlassBackLeading extends StatelessWidget {
  final VoidCallback? onPressed;

  const GlassBackLeading({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Align(
        alignment: Alignment.center,
        child: GlassBackButton(onPressed: onPressed),
      ),
    );
  }
}
