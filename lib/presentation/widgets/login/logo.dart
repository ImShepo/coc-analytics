import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;
  final bool compact;

  const Logo({
    super.key,
    required this.title,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.only(top: compact ? 24 : 50),
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/images/coc-background.png'),
              fit: BoxFit.cover,
            ),
            SizedBox(height: compact ? 2 : 5),
            Text(
              title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
