import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';

class DashboardCards extends StatelessWidget {
  final String text;
  final images;
  final onClicks;
  late var newColor;

  DashboardCards({
    required this.text,
    required this.images,
    required this.onClicks,
  });

  @override
  Widget build(BuildContext context) {
    newColor = getSchoolColor();
    return Column(
      children: [
        GestureDetector(
          onTap: onClicks,
          child: Card(
            elevation: 4.0,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(),
            child: images,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Color(int.parse('$newColor')),
            ),
          ),
        ),
      ],
    );
  }
}
