import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wsms/Shared_Pref.dart';

class BackgroundWidget extends StatefulWidget {
  final childView;

  BackgroundWidget({required this.childView});

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  var log = 'assets/background.png';
  var logos= SharedPref.getSchoolLogo();

  setLogo() {
    if (logos != null) {
      return NetworkImage('$logos');
    } else
      return AssetImage('$log');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment:SharedPref.getSchoolId()=='15'?Alignment.center: Alignment.bottomCenter,
          image: setLogo(),
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.8),
            child: widget.childView,
          ),
        ),
      ),
    );
  }
}
