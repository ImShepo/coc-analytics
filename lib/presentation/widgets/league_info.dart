import 'package:flutter/material.dart';

class LeagueInfo extends StatelessWidget {
  const LeagueInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
            child: Text(
              'League',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE5AB2D),
                fontWeight: FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 70,
                height: 60,
                decoration: const BoxDecoration(),
                alignment: const AlignmentDirectional(0, 0),
                child: const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'Titan League I',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/Titan_League.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
