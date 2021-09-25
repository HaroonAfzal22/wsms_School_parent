import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/Subjects.dart';

class SubjectDetails extends StatefulWidget {
  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
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
    setColor();
    getData();
  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
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

  bool value() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    newColor = getSchoolColor();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(int.parse('$newColor')),
        indicatorColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 4,
        child: isLoading
            ? Container(
                color: Colors.white,
                child: Center(child: spinkit),
              )
            : BackgroundWidget(
                childView: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Color(int.parse('$newColor')),
                    title: Text('Subject Details'),
                    bottom: TabBar(
                      isScrollable: value(),
                      tabs: [
                        Tab(
                          icon: Icon(CupertinoIcons.calendar),
                          text: 'Test Results',
                        ),
                        Tab(
                          icon: Icon(CupertinoIcons.pen),
                          text: 'Homework',
                        ),
                        Tab(
                          icon: Icon(CupertinoIcons.checkmark_square_fill),
                          text: 'Results',
                        ),
                        Tab(
                          icon: Icon(CupertinoIcons.video_camera_solid),
                          text: 'Video Lectures',
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            elevation: 4.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
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
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
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
                                              style: TextStyle(
                                                  color: Colors.black),
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
                      Icon(Icons.directions_transit),
                      Icon(Icons.email),
                      Icon(Icons.directions_bike),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
