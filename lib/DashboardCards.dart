import 'package:flutter/material.dart';


class DashboardCards extends StatelessWidget {

  final String text;
  final images;
  final onClicks;

  DashboardCards(
      {required this.text, required this.images, required this.onClicks});

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xff18728a),
            ),
          ),
        ),
      ],
    );
  }
}
