import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';

class DashboardCards extends StatefulWidget {
  final String text;
  final images;
  final onClicks;

  DashboardCards({
    required this.text,
    required this.images,
    required this.onClicks,
  });

  @override
  _DashboardCardsState createState() => _DashboardCardsState();
}

class _DashboardCardsState extends State<DashboardCards> {
  late var newColor;
  late Timer _timer;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    setColor();

  }

  setColor() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      var color = await getSchoolColor();
      setState(() {
        newColor = color;
      });
    if (newColor != null) {
      setState(() {
        isLoading = false;
        _timer.cancel();
      });
    }
    });

  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Column(
            children: [
              GestureDetector(
                onTap: widget.onClicks,
                child: Card(
                  elevation: 4.0,
                  clipBehavior: Clip.antiAlias,
                  shape: CircleBorder(),
                  child: widget.images,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6.0),
                child: Text(
                  widget.text,
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
