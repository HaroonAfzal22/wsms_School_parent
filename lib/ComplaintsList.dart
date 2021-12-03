import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class ComplaintsList extends StatefulWidget {
  @override
  _ComplaintsListState createState() => _ComplaintsListState();
}

//here all complaints are shown from past and present dates

class _ComplaintsListState extends State<ComplaintsList> {
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false;
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late List listValue;
  bool isListEmpty = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getData();
  }

  // to show all complaints list from api
  getData() async {
    HttpRequest request = HttpRequest();
    var result = await request.getComplaintsData(context, token!, sId!);
    if (result == 500) {
      toastShow('Server Error!!! Try Again Later ...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        listValue = result;
        listValue.isNotEmpty ? isListEmpty = false : isListEmpty = true;
        isLoading = false;
      });
    }
  }
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
          'Complaints Application List',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer:  Drawers(logout:  () async {
        // on signout remove all local db and shared preferences
        Navigator.pop(context);

        setState(() {
          isLoading=true;
        });
        HttpRequest request = HttpRequest();
        var res =
        await request.postSignOut(context, token!);
       /* await db.execute('DELETE FROM daily_diary ');
        await db.execute('DELETE FROM profile ');
        await db.execute('DELETE FROM test_marks ');
        await db.execute('DELETE FROM subjects ');
        await db.execute('DELETE FROM monthly_exam_report ');
        await db.execute('DELETE FROM time_table ');
        await db.execute('DELETE FROM attendance ');*/
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
      },),
      body: SafeArea(
        child: isLoading
            ? Center(child: spinkit)
            : BackgroundWidget(
                childView: isListEmpty
                    ? Container(
                        color: Colors.transparent,
                        child: Lottie.asset('assets/no_data.json',
                            repeat: true, reverse: true, animate: true),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(int.parse('$newColor')),
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 12.0),
                            elevation: 4.0,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 8.0, left: 20.0),
                                      child: Text(
                                        '${listValue[index]['title']} ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _settingModalBottomSheet(
                                            context, index);
                                      },
                                      child: Icon(
                                        Icons.arrow_right_alt_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /* subtitle: Container(
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'From Date: ${setFormat(index, 'leave_from')}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            'To Date: ${setFormat(index, 'leave_to')}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Application Status: ',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        TextSpan(
                                          text: '${leaveStatus(index)}',
                                          style: TextStyle(
                                            color: colorStatus(index),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),*/
                            ),
                          );
                        },
                        itemCount: listValue.length,
                      ),
              ),
      ),
    );
  }

 /* // to check response which came in int form then set according to it
  leaveStatus(index) {
    if (listValue[index]['leave_status'] == 0) {
      return 'Pending';
    } else if (listValue[index]['leave_status'] == 1) {
      return 'Approved';
    } else {
      return 'Rejected';
    }
  }

  // to check response and show
  colorStatus(index) {
    if (listValue[index]['leave_status'] == 0) {
      return Colors.amber;
    } else if (listValue[index]['leave_status'] == 1) {
      return Color(0xff459d76);
    } else {
      return Colors.red;
    }
  }

  setFormat(index, leave) {
    var format = Jiffy(listValue[index]['$leave']).format("dd-MMM-yyyy");
    return format;
  }*/

// to show bottom sheet about details of complaint
  void _settingModalBottomSheet(context, index) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: roundBorder,
      builder: (BuildContext bc) => Container(
        height: MediaQuery.of(context).copyWith().size.height,
        child: Card(
          shape: roundBorder,
          child: ListTile(
            title: Container(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: textData(
                        index: 'Details About Complaints',
                        txtAlign: TextAlign.center,
                        colors: Color(
                          int.parse('$newColor'),
                        ),
                        fSize: 16.0,
                        fWeight: FontWeight.bold),
                  ),
                  /*  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 40, top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              'From Date: ${setFormat(index, 'leave_from')}',
                              style: TextStyle(
                                color: Color(int.parse('$newColor')),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 12.0),
                              child: Text(
                                'To Date: ${setFormat(index, 'leave_to')}',
                                style: TextStyle(
                                  color: Color(int.parse('$newColor')),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Application Status: ',
                                style: TextStyle(
                                  color: Color(int.parse('$newColor')),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                )),
                            TextSpan(
                              text: '${leaveStatus(index)}',
                              style: TextStyle(
                                color: colorStatus(index),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  Divider(
                    thickness: 0.5,
                    height: 0.5,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            subtitle: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: textData(
                          index: '${listValue[index]['title']} ',
                          txtAlign: TextAlign.center,
                          colors: Colors.orange,
                          fWeight: FontWeight.w500,
                          fSize: 20.0),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: textData(
                      index: '${listValue[index]['description']}',
                      fSize: 12.0,
                      fWeight: FontWeight.w500,
                      colors: Color(int.parse('$newColor')),
                      txtAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
