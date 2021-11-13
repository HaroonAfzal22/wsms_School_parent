import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class SubjectResult extends StatefulWidget {
  const SubjectResult({Key? key}) : super(key: key);

  @override
  _SubjectResultState createState() => _SubjectResultState();
}

class _SubjectResultState extends State<SubjectResult> {
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  var subId = SharedPref.getSubjectId();
  List resultList = [];
  bool isLoading = false;
  var newColor = SharedPref.getSchoolColor();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getData();
  }

  getData() async {
    HttpRequest request = HttpRequest();
    var result = await request.getTestResult(context, sId!, subId!, token!);

    if (result == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        result.isNotEmpty ? resultList = result : toastShow("No Data Found");
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Result'),
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer:  Drawers(),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: spinkit,
              )
            : BackgroundWidget(
                childView: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      elevation: 4.0,
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: Color(int.parse('$newColor')),
                            height: 40.0,
                            child: resultTitles(
                              index: '${resultList[index]['title']}',
                              icons: CupertinoIcons.pen,
                              title: 'Title',
                              colors: Colors.white,
                            ),
                          ),
                          Container(
                            height: 40.0,
                            child: resultTitles(
                              title: 'Date',
                              icons: CupertinoIcons.calendar,
                              index: '${resultList[index]['quiz_date']}',
                              colors: Colors.black,
                            ),
                          ),
                          Container(
                            color: Color(0xfc48d9cd),
                            height: 40.0,
                            child: Center(
                              child: Text(
                                'Syllabus',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                '${resultList[index]['syllabus']}',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Color(0xfc48d9cd),
                            height: 40.0,
                            child: resultTitles(
                                title: 'Total Marks',
                                icons: CupertinoIcons.book,
                                index: '${resultList[index]['quiz_marks']}',
                                colors: Colors.black),
                          ),
                          Container(
                            height: 40.0,
                            child: resultTitles(
                                title: 'Obtain Marks',
                                icons: CupertinoIcons.book,
                                index: '${resultList[index]['obt']}',
                                colors: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: resultList.length,
                ),
              ),
      ),
    );
  }
}