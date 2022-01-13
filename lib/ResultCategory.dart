import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/ExamReport.dart';
import 'package:wsms/MonthlyExamReport.dart';
import 'package:wsms/ResultDesign.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/SubjectsBottom.dart';

class ResultCategory extends StatefulWidget {
  @override
  _ResultCategoryState createState() => _ResultCategoryState();
}

class _ResultCategoryState extends State<ResultCategory> {
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false;

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomResultKey = GlobalKey();

  final resultScreens=[
    SubjectsBottom(),
    MonthlyExamReport(),
    ExamReport(),
  ];
 

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: spinkit)
        :
        WillPopScope(
          onWillPop:_onPopScope,
          child: Scaffold(
            backgroundColor: Color(int.parse('$newColor')),

            bottomNavigationBar: CurvedNavigationBar(
                color: Color(int.parse('$newColor')),
                backgroundColor: Colors.transparent,
                key: _bottomResultKey,
                height: 50,
                items: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.book_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                      Visibility(
                        visible: _page == 0 ? false : true,
                        child: Text(
                          'SubjectWise Result',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.calendar, color: Colors.white, size: 30),
                      Visibility(
                          visible: _page == 1 ? false : true,
                          child: Text(
                            'MonthWise Result',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.square_list_fill, color: Colors.white, size: 30),
                      Visibility(
                          visible: _page == 2 ? false : true,
                          child: Text(
                            'Exams Report',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          )),
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
              body: resultScreens[_page],
            ),
        );
  }
  @override
  void dispose() {
    _page = 0;
    super.dispose();
  }
}
