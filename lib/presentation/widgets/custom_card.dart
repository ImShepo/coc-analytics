import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String backgroundImage;
  final double opacity;
  final double height;
  final Widget content;

  const CustomCard({
    Key? key,
    required this.backgroundImage,
    this.opacity = 0.5,
    this.height = 200,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Opacity(
              opacity: opacity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  backgroundImage,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.8),
                  filterQuality: FilterQuality.low,
                  cacheWidth: 800,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
