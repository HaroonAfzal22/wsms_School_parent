import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wsms/Shared_Pref.dart';

class BackgroundWidget extends StatelessWidget {
  final childView;
    var logo = 'assets/background.png';     /* SharedPref.getSchoolLogo();*/
  BackgroundWidget({required this.childView});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
         // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage(
            '$logo',
          ),
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.9),
            child: childView,
          ),
        ),
      ),
    );
  }
}
