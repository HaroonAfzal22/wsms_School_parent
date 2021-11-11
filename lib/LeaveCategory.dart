import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/ResultDesign.dart';
import 'package:wsms/Shared_Pref.dart';

class LeaveCategory extends StatefulWidget {
  @override
  _LeaveCategoryState createState() => _LeaveCategoryState();
}

class _LeaveCategoryState extends State<LeaveCategory> {
   var newColor=SharedPref.getSchoolColor();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Category'),
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
                      Navigator.pushNamed(context, '/leave_apply');
                    },
                    titleText: 'Leave Application Apply')),
            Expanded(
              flex: 1,
              child: ResultDesign(
                  onClick: () {
                    Navigator.pushNamed(context, '/leave_apply_list');
                  },
                  titleText: 'Leave Application List'),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white60,
                child: Lottie.asset('assets/leaves.json',
                    repeat: true, reverse: true, animate: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
