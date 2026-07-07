import 'package:flutter/material.dart';

/// Smooth shimmer + resource-dot animation while network images load.
class CocImageLoadingPlaceholder extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final bool animated;

  const CocImageLoadingPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.animated = true,
  });

  bool get _isCompact {
    final w = width;
    final h = height;
    if (w != null && w <= 36) return true;
    if (h != null && h <= 36) return true;
    return false;
  }

  @override
  State<CocImageLoadingPlaceholder> createState() =>
      _CocImageLoadingPlaceholderState();
}

class _StaticLoadingPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _StaticLoadingPlaceholder({
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE9F2E8),
              colorScheme.secondary.withValues(alpha: 0.55),
              const Color(0xFFF8F0E6),
            ],
          ),
        ),
      ),
    );
  }
}

class _CocImageLoadingPlaceholderState extends State<CocImageLoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (!widget.animated) return;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animated) {
      return _StaticLoadingPlaceholder(
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        final shimmer = _controller!.value;

        return ClipRRect(
          borderRadius: widget.borderRadius,
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(
                begin: Alignment(-1.2 + shimmer * 2.4, -0.4),
                end: Alignment(-0.2 + shimmer * 2.4, 0.4),
                colors: [
                  const Color(0xFFE9F2E8),
                  colorScheme.secondary.withValues(alpha: 0.55),
                  const Color(0xFFF8F0E6),
                  const Color(0xFFE9F2E8),
                ],
                stops: const [0.0, 0.42, 0.58, 1.0],
              ),
            ),
            alignment: Alignment.center,
            child: widget._isCompact
                ? null
                : _ResourceDotsLoader(
                    progress: _controller!.value,
                    maxHeight: widget.height,
                  ),
          ),
        );
      },
    );
  }
}

class _ResourceDotsLoader extends StatelessWidget {
  final double progress;
  final double? maxHeight;

  const _ResourceDotsLoader({
    required this.progress,
    this.maxHeight,
  });

  static const _colors = [
    Color(0xFFF5C842),
    Color(0xFF6BBF59),
    Color(0xFFB565D8),
  ];

  @override
  Widget build(BuildContext context) {
    final dotSize = (maxHeight != null && maxHeight! <= 20) ? 5.0 : 7.0;
    final bounceScale = (maxHeight != null && maxHeight! <= 20) ? 0.35 : 0.55;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_colors.length, (index) {
          final phase = (progress + index * 0.22) % 1.0;
          final bounce = (1 - (phase * 2 - 1).abs()) * bounceScale;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Transform.translate(
              offset: Offset(0, -bounce * dotSize * 0.9),
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colors[index].withValues(alpha: 0.88),
                  boxShadow: [
                    BoxShadow(
                      color: _colors[index].withValues(alpha: 0.35),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Network image with animated placeholder and soft fade-in when ready.
class CocNetworkImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final int? cacheWidth;
  final int? cacheHeight;
  final FilterQuality filterQuality;
  final Widget? errorWidget;
  final VoidCallback? onImageError;
  final bool animatedPlaceholder;
  final bool fadeIn;

  const CocNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.cacheWidth,
    this.cacheHeight,
    this.filterQuality = FilterQuality.medium,
    this.errorWidget,
    this.onImageError,
    this.animatedPlaceholder = true,
    this.fadeIn = true,
  });

  @override
  State<CocNetworkImage> createState() => _CocNetworkImageState();
}

class _CocNetworkImageState extends State<CocNetworkImage> {
  bool _revealed = false;
  int _loadGeneration = 0;

  @override
  void didUpdateWidget(covariant CocNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadGeneration++;
      _revealed = false;
    }
  }

  Widget _placeholder() {
    return CocImageLoadingPlaceholder(
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      animated: widget.animatedPlaceholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final generation = _loadGeneration;

    final image = Image.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      filterQuality: widget.filterQuality,
      gaplessPlayback: true,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          if (!widget.fadeIn) return child;

          if (!_revealed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && generation == _loadGeneration) {
                setState(() => _revealed = true);
              }
            });
          }
          return AnimatedOpacity(
            opacity: _revealed ? 1 : 0,
            duration: const Duration(milliseconds: 340),
            curve: Curves.easeOutCubic,
            child: child,
          );
        }

        if (widget.fadeIn && _revealed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && generation == _loadGeneration) {
              setState(() => _revealed = false);
            }
          });
        }

        return _placeholder();
      },
      errorBuilder: (context, error, stackTrace) {
        widget.onImageError?.call();
        return widget.errorWidget ??
            _NetworkImageErrorFallback(
              width: widget.width,
              height: widget.height,
              borderRadius: widget.borderRadius,
            );
      },
    );

    if (widget.borderRadius == BorderRadius.zero) return image;

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: image,
    );
  }
}

/// Circular network avatar with the same loading treatment.
class CocNetworkAvatar extends StatelessWidget {
  final String url;
  final double radius;
  final Color? backgroundColor;
  final int? cacheWidth;

  const CocNetworkAvatar({
    super.key,
    required this.url,
    required this.radius,
    this.backgroundColor,
    this.cacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    return ClipOval(
      child: CocNetworkImage(
        url: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: cacheWidth,
        errorWidget: Container(
          width: size,
          height: size,
          color: backgroundColor ?? Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(
            Icons.shield_rounded,
            size: radius * 0.85,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}

class _NetworkImageErrorFallback extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _NetworkImageErrorFallback({
    this.width,
    this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: colorScheme.secondary.withValues(alpha: 0.25),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: _iconSize,
        color: colorScheme.primary.withValues(alpha: 0.4),
      ),
    );
  }

  double get _iconSize {
    final base = height ?? width ?? 32;
    return base.clamp(12.0, 28.0) * 0.55;
  }
}
