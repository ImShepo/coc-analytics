import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Labels extends StatelessWidget {
  final String route;
  final String title;
  final String actionTitle;

  const Labels(
      {super.key,
      required this.route,
      required this.title,
      required this.actionTitle});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: () => context.goNamed(route),
          child: Text(
            actionTitle,
            style: TextStyle(
              color: primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
