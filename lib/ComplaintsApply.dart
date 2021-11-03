import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

class ComplaintsApply extends StatefulWidget {

  @override
  _ComplaintsApplyState createState() => _ComplaintsApplyState();
}

class _ComplaintsApplyState extends State<ComplaintsApply> {
  late var newColor = '0xff5728a',
      format = 'From date',
      formats = 'To date',
      attachments = 'Attach File',
      fromDates,
      toDates;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  TextEditingController _controller = TextEditingController();
  TextEditingController _controls = TextEditingController();
  String? reasonValue,titleValue;
  bool isLoading = false;
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setColor();
  }

  setColor() async {
    var colors = await getSchoolColor();
    setState(() {
      newColor = colors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        title: Text(
          'Complaints Apply',
        ),
        brightness: Brightness.dark,
      ),
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
                child:
                Text('Title:',style: TextStyle(
                    color: Color(int.parse('$newColor'),),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),)
                ,),
              Container(
                height: 100,
                padding: EdgeInsets.only(top: 16.0, left: 16.0,right: 16.0),
                child: TextField(
                    keyboardType: TextInputType.text,
                    style: kTStyle,
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
                      constraints: BoxConstraints(maxWidth: double.infinity, minWidth: MediaQuery.of(context).size.width),
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
                      left: MediaQuery.of(context).size.width-70,
                      child: Container(
                        child: IconButton(
                          onPressed: () {
                            print('size ${MediaQuery.of(context).size.width}');
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
                child:
                Text('Reason:',style: TextStyle(
                  color: Color(int.parse('$newColor'),),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),)
                ,),
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                    keyboardType: TextInputType.text,
                    style: kTStyle,
                    maxLines: null,
                    maxLength: null,
                    decoration: kTextsFieldStyle,
                    controller: _controller,
                    onChanged: (value) {
                      reasonValue = value;
                    }),

              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  style: kElevateStyle,
                  onPressed: () {
                    setState(() {
                      isLoading=true;
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
  void uploadData()async{
    HttpRequest request = HttpRequest();
    Map bodyMap = {
      'title': titleValue,
      'description': reasonValue,
    };
    var response = await request.postComplaintData(context, token!, sId!, bodyMap);
   if(response!=null){
     setState(() {
      isLoading=false;
       toastShow('Complaints  Submitted..');
     });
   }else{
     setState(() {
       isLoading=false;
     });
   }
  }

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
        fromDates = fromDate
            .toString()
            .substring(0, fromDate
            .toString()
            .length - 13);
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
        toDates = toDate
            .toString()
            .substring(0, toDate
            .toString()
            .length - 13);
        //editAttendance();
      });
  }
}