import 'package:flutter/material.dart';

/// Soft static placeholder while network images load.
class CocImageLoadingPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final bool animated;

  const CocImageLoadingPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    // Kept for call-site compatibility; animation removed on purpose.
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: ColoredBox(
        color: colorScheme.secondary.withValues(alpha: 0.28),
        child: SizedBox(width: width, height: height),
      ),
    );
  }
}

/// Network image that avoids load flicker:
/// - memory-cached images paint immediately (no placeholder flash)
/// - first load shows a static fill until the first frame, then stays
/// - no fade / pulse / loadingBuilder swaps
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
    this.animatedPlaceholder = false,
    this.fadeIn = false,
  });

  @override
  State<CocNetworkImage> createState() => _CocNetworkImageState();
}

class _CocNetworkImageState extends State<CocNetworkImage> {
  /// Once any frame has painted for the current URL, prefer keeping [child]
  /// (gaplessPlayback) over flashing the placeholder on rebuilds.
  bool _hasFrame = false;

  @override
  void didUpdateWidget(covariant CocNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _hasFrame = false;
    }
  }

  Widget _placeholder() {
    return CocImageLoadingPlaceholder(
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      animated: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return widget.errorWidget ?? _placeholder();
    }

    final image = Image.network(
      // Remount when the URL changes so a failed provider does not stick
      // after the parent advances to a fallback candidate.
      key: ValueKey(widget.url),
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      filterQuality: widget.filterQuality,
      gaplessPlayback: true,
      // Prefer frameBuilder over loadingBuilder: loadingBuilder often
      // flashes the placeholder even when the image is already cached.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          _hasFrame = true;
          return child;
        }
        // Keep the previous/gapless child instead of swapping to a
        // placeholder mid-load (this is what looked like a "blink").
        if (_hasFrame) return child;
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
      clipBehavior: Clip.hardEdge,
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
        cacheWidth: cacheWidth ?? (size * 2).round().clamp(48, 256),
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
