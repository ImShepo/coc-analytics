import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? borderRadius;
  final double? opacity;

  const BackgroundImage({
    Key? key,
    required this.imagePath,
    this.height = 200.0,
    this.borderRadius = 30.0,
    this.opacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: Opacity(
        opacity: opacity!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius!),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.8),
          ),
        ),
      ),
    );
  }
}
