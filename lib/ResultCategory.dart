import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/ResultDesign.dart';

class ResultCategory extends StatefulWidget {
  @override
  _ResultCategoryState createState() => _ResultCategoryState();
}

class _ResultCategoryState extends State<ResultCategory> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text('Results Category'),
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: ResultDesign(
                    onClick: () {
                      Navigator.pushNamed(context, '/subjects',arguments: {
                        'card_type':arg['card_type'],
                      });
                    }, titleText: 'SubjectWise Test Result')),
            Expanded(
              flex: 1,
              child: ResultDesign(
                  onClick: () {
                    Navigator.pushNamed(context, '/monthly_exam_report');
                  },
                  titleText: 'MonthWise Test Result'),
            ),
            Expanded(
              flex: 4,
              child: Lottie.asset('assets/studying.json',
                  repeat: true, reverse: true, animate: true),
            ),
          ],
        ),
      ),
    );
  }
}
