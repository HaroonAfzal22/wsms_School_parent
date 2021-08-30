import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/ResultDesign.dart';

class TimeTableCategory extends StatefulWidget {
  @override
  _TimeTableCategoryState createState() => _TimeTableCategoryState();
}

class _TimeTableCategoryState extends State<TimeTableCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Table Category'),
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: ResultDesign(
                    onClick: () {
                      Navigator.pushNamed(context, '/time_table');
                    }, titleText: 'Class Time Table')),
            Expanded(
              flex: 1,
              child: ResultDesign(
                  onClick: () {
                    Navigator.pushNamed(context, '/monthly_test_schedule');
                  },
                  titleText: 'MonthWise Test Schedule'),
            ),
            Expanded(
              flex: 4,
              child: Lottie.asset('assets/time_table.json',
                  repeat: true, reverse: true, animate: true),
            ),
          ],
        ),
      ),
    );
  }
}

