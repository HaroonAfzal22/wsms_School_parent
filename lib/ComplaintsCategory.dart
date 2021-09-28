import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/ResultDesign.dart';

class ComplaintsCategory extends StatefulWidget {
  @override
  _ComplaintsCategoryState createState() => _ComplaintsCategoryState();
}

class _ComplaintsCategoryState extends State<ComplaintsCategory> {
  var newColor = '0xff15728a';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setColor();
  }

  setColor() async {
    var color = await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: spinkit)
        : Scaffold(
            appBar: AppBar(
              title: Text('Complaints Category'),
              backgroundColor: Color(int.parse('$newColor')),
              brightness: Brightness.dark,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
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
