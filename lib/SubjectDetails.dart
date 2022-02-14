import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

class SubjectDetails extends StatefulWidget {
  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  var subId = SharedPref.getSubjectId();
  List resultList = [];
  bool isLoading = false,isListEmpty=false;
  var newColor = SharedPref.getSchoolColor();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getData();
  }

  // get test result
  getData() async {
    HttpRequest request = HttpRequest();
    var result = await request.getTestResult(context, sId!, subId!, token!);
    setState(() {
      if(result==null ||result.isEmpty){
        toastShow('Data record not found...');
        isLoading=false;
        isListEmpty=true;
      }else if (result.toString().contains('Error')){
        toastShow('$result...');
        isLoading=false;
      }else{
        resultList=result;
        isLoading=false;
      }
    });
    /*if (result == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        result.isNotEmpty ? resultList = result : toastShow("No Data Found");
        result.isNotEmpty ? isListEmpty = false :isListEmpty=true;
        isLoading = false;
      });
    }*/
  }

  bool value() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(int.parse('$newColor')),
        indicatorColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 4,
        child: BackgroundWidget(
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
            body: isLoading
                ? Container(
                    color: Colors.white,
                    child: Center(child: spinkit),
                  )
                : isListEmpty
                ? Container(
              color: Colors.transparent,
              child: Lottie.asset('assets/no_data.json',
                  repeat: true, reverse: true, animate: true),
            )
                :TabBarView(
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
                      Container(
                        color: Colors.transparent,
                        child: Lottie.asset('assets/construction.json',
                            repeat: true,  animate: true),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Lottie.asset('assets/construction.json',
                            repeat: true,  animate: true),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Lottie.asset('assets/construction.json',
                            repeat: true,  animate: true),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
