import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/ResultDesign.dart';
import 'package:wsms/Shared_Pref.dart';

class ResultCategory extends StatefulWidget {
  @override
  _ResultCategoryState createState() => _ResultCategoryState();
}

class _ResultCategoryState extends State<ResultCategory> {
   var newColor = SharedPref.getSchoolColor();
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return isLoading
        ? Center(
            child: spinkit
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Results Category'),
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
                            Navigator.pushNamed(context, '/subjects',
                                arguments: {
                                  'card_type': arg['card_type'],
                                });
                          },
                          titleText: 'SubjectWise Test Result')),
                  Expanded(
                    flex: 1,
                    child: ResultDesign(
                        onClick: () {
                          Navigator.pushNamed(context, '/monthly_exam_report');
                        },
                        titleText: 'MonthWise Test Report'),
                  ),
                  Expanded(
                    flex: 1,
                    child: ResultDesign(
                        onClick: () {
                          Navigator.pushNamed(context, '/exam_report');
                        },
                        titleText: 'Exams Result'),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white60,
                      child: Lottie.asset('assets/studying.json',
                          repeat: true, reverse: true, animate: true),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
