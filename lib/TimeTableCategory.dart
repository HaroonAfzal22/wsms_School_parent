import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/MonthlyTestSchedule.dart';
import 'package:wsms/ResultDesign.dart';
import 'package:wsms/Shared_Pref.dart';

import 'ClassTimeTable.dart';

class TimeTableCategory extends StatefulWidget {
  @override
  _TimeTableCategoryState createState() => _TimeTableCategoryState();
}

class _TimeTableCategoryState extends State<TimeTableCategory> {
  var newColor = SharedPref.getSchoolColor();

  int _page = 0;

  GlobalKey<CurvedNavigationBarState> _bottomTableKey = GlobalKey();

  final timeTableScreens=[
  ClassTimeTable(),
  MonthlyTestSchedule(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: Color(int.parse('$newColor')),
          backgroundColor: Colors.transparent,
          key: _bottomTableKey,
          height: 50,
          items: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.square_list_fill, color: Colors.white, size: 30,),
                Visibility(
                  visible:_page==0?false:true,
                  child: Text('Class Time Table', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.calendar, color: Colors.white, size: 30),
                Visibility(visible:_page==0?true:false, child: Text('Monthly Test Schedule', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),)),
              ],
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        extendBody: true,
        body: timeTableScreens[_page],
      );
  }
  @override
  void dispose() {
    _page = 0;
    super.dispose();
  }
}
