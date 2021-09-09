import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
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
  late var newColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    newColor = getSchoolColor();

    getData();
  }

  getData() async {
    HttpRequest request = HttpRequest();
    List result = await request.getTestResult(context, sId!, subId!, token!);
    setState(() {
      result.isNotEmpty
          ? resultList = result
          : toastShow("No Data Found");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    statusColor(newColor);
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Result'),
        backgroundColor: Color(int.parse('$newColor')),
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: BackgroundWidget(
          childView: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Color(int.parse('$newColor')),
                      height: 40.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.pen,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Title',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  ' ${resultList[index]['title']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${resultList[index]['quiz_date']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xfc48d9cd),
                      height: 40.0,
                      child: Center(
                        child: Text(
                          'Syllabus',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Total Marks',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${resultList[index]['quiz_marks']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Obtain Marks',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${resultList[index]['obt']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
