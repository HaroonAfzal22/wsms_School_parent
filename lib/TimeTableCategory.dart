import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/ResultDesign.dart';
import 'package:wsms/Shared_Pref.dart';

class TimeTableCategory extends StatefulWidget {
  @override
  _TimeTableCategoryState createState() => _TimeTableCategoryState();
}

class _TimeTableCategoryState extends State<TimeTableCategory> {
   var newColor= SharedPref.getSchoolColor();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Table Category'),
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: ResultDesign(
                    onClick: () {
                      Navigator.pushNamed(context, '/time_table');
                    },
                    titleText: 'Class Time Table')),
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
