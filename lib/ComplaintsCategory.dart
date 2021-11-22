import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/ResultDesign.dart';
import 'package:wsms/Shared_Pref.dart';

class ComplaintsCategory extends StatefulWidget {
  @override
  _ComplaintsCategoryState createState() => _ComplaintsCategoryState();
}

//for shown category is want to apply or check list of complaints

class _ComplaintsCategoryState extends State<ComplaintsCategory> {
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: spinkit)
        : Scaffold(
            appBar: AppBar(
              title: Text('Complaints Category'),
              backgroundColor: Color(int.parse('$newColor')),
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      //for resultdesign class used to design this card
                      child: ResultDesign(
                          onClick: () {
                            Navigator.pushNamed(context, '/complaints_apply');
                          },
                          titleText: 'Complain Application Apply')),

                  Expanded(
                    flex: 1,
                    child: ResultDesign(
                        onClick: () {
                          Navigator.pushNamed(context, '/complaints_list');
                        },
                        titleText: 'Complain Application List'),
                  ),
                  Expanded(
                    flex: 5,
                    //for lottie animation used to set response using lottie package
                    child: Container(
                      color: Colors.white60,
                      child: Lottie.asset('assets/help.json',
                          repeat: true, reverse: true, animate: true),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
