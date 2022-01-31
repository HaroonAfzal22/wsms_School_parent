import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

import 'NavigationDrawer.dart';

class ComplaintsApply extends StatefulWidget {
  @override
  _ComplaintsApplyState createState() => _ComplaintsApplyState();
}

//for student or parent do complaints it used
class _ComplaintsApplyState extends State<ComplaintsApply> {
   var newColor = SharedPref.getSchoolColor(),
      attachments = 'Attach File';
  TextEditingController _controller = TextEditingController();
  TextEditingController _controls = TextEditingController();
  String? reasonValue, titleValue;
  bool isLoading = false;
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();

   Future<void> updateApp() async {
     setState(() {
       isLoading=true;
     });
     Map map = {
       'fcm_token': SharedPref.getUserFcmToken(),
     };
     HttpRequest request = HttpRequest();
     var results = await request.postUpdateApp(context, token!, map);
     if (results == 500) {
       toastShow('Server Error!!! Try Again Later...');
     } else {
       SharedPref.removeSchoolInfo();
       await getSchoolInfo(context);
       await getSchoolColor();
       setState(() {
         newColor = SharedPref.getSchoolColor()!;
         isLoading=false;
       });

       results['status'] == 200
           ? snackShow(context, 'Sync Successfully')
           : snackShow(context, 'Sync Failed');
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        title: Text(
          'Complaints Apply',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    /*  drawer:  Drawers(logout:  () async {
        // on signout remove all local db and shared preferences
        Navigator.pop(context);

        setState(() {
          isLoading=true;
        });
        HttpRequest request = HttpRequest();
        var res = await request.postSignOut(context, token!);
       *//* await db.execute('DELETE FROM daily_diary ');
        await db.execute('DELETE FROM profile ');
        await db.execute('DELETE FROM test_marks ');
        await db.execute('DELETE FROM subjects ');
        await db.execute('DELETE FROM monthly_exam_report ');
        await db.execute('DELETE FROM time_table ');
        await db.execute('DELETE FROM attendance ');*//*
        Navigator.pushReplacementNamed(context, '/');
        setState(() {
          if (res['status'] == 200) {
            SharedPref.removeData();
            snackShow(context, 'Logout Successfully');
            isLoading=false;
          } else {
            isLoading=false;
            snackShow(context, 'Logout Failed');
          }
        });

      },sync: () async {
        Navigator.pop(context);
        await updateApp();
        Phoenix.rebirth(context);
      },),*/
      body: SafeArea(
        child: isLoading
            ? Center(child: spinkit)
            : BackgroundWidget(
                childView: ListView(
                  children: [
                    /*   Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            constraints: kBoxConstraints,
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child: Padding(
                              padding: kAttendPadding,
                              child: Text(
                                '$format',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            child: Container(
                              child: IconButton(
                                onPressed: () => _fromDate(context),
                                icon: Icon(
                                  CupertinoIcons.calendar,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            constraints: kBoxConstraints,
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child: Padding(
                              padding: kAttendPadding,
                              child: Text(
                                '$formats',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            child: Container(
                              child: IconButton(
                                onPressed: () => _toDate(context),
                                icon: Icon(
                                  CupertinoIcons.calendar,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
                    Container(
                      margin: kMargins,
                      child: Text(
                        'Title:',
                        style: TextStyle(
                            color: Color(
                              int.parse('$newColor'),
                            ),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 100,
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(int.parse('$newColor')),
                          ),
                          maxLines: null,
                          maxLength: null,
                          decoration: kTextsFieldStyle,
                          controller: _controls,
                          onChanged: (value) {
                            titleValue = value;
                          }),
                    ),
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: double.infinity,
                                minWidth: MediaQuery.of(context).size.width),
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child: Padding(
                              padding: kAttendsPadding,
                              child: Text(
                                '$attachments',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 70,
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  print(
                                      'size ${MediaQuery.of(context).size.width}');
                                },
                                icon: Icon(
                                  CupertinoIcons.camera,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: kMargins,
                      child: Text(
                        'Reason:',
                        style: TextStyle(
                            color: Color(
                              int.parse('$newColor'),
                            ),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: TextField(
                          keyboardType: TextInputType.text,
                          style: kTStyle('$newColor'),
                          maxLines: null,
                          maxLength: null,
                          decoration: kTextsFieldStyle,
                          controller: _controller,
                          onChanged: (value) {
                            reasonValue = value;
                          }),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ElevatedButton(
                        style: kElevateStyle,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          uploadData();
                        },
                        child: Text('Upload Data'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //post data to api where sent title of complaint and reason
  void uploadData() async {
    HttpRequest request = HttpRequest();
    Map bodyMap = {
      'title': titleValue,
      'description': reasonValue,
    };
    var response = await request.postComplaintData(context, token!, sId!, bodyMap);
    setState(() {
      if(response==null ||response.isEmpty){
        toastShow('Data Upload Failed...');
        isLoading=false;
      }else if (response.toString().contains('Error')){
        toastShow('$response...');
        isLoading=false;
      }else{
        isLoading=false;
      }
    });
   }
/*
  Future<void> _fromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        // getEmployeeList(token!);
        var dateString = picked;
        format = Jiffy(dateString).format("dd-MMM-yyyy");
        fromDate = picked;
        fromDates =
            fromDate.toString().substring(0, fromDate.toString().length - 13);
        //editAttendance();
      });
  }

  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate)
      setState(() {
        // getEmployeeList(token!);
        var dateString = picked;
        formats = Jiffy(dateString).format("dd-MMM-yyyy");
        toDate = picked;
        toDates = toDate.toString().substring(0, toDate.toString().length - 13);
        //editAttendance();
      });
  }*/
}
