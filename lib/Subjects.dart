import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/SubjectDetails.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  var token = SharedPref.getUserToken();
  var tok =SharedPref.getStudentId();

  List listSubject = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getData();
  }

  getData() async {
    HttpRequest request = HttpRequest();
    List list = await request.getSubjectsList(context,token!,tok!);
    setState(() {
      listSubject = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text('Subjects List'),

        ),
        drawer: SafeArea(
          child: Drawers(
            complaint: null,
            aboutUs: null,
            PTM: null,
            dashboards: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            Leave: null,
            onPress: () {
              setState(() {
                SharedPref.removeData();
                Navigator.pushReplacementNamed(context, '/');
                Fluttertoast.showToast(
                    msg: "Logout Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xff18726a),
                    textColor: Colors.white,
                    fontSize: 12.0
                );
              });
            },
          ),
        ),
        body: BackgroundWidget(
          childView: Container(
            child: isLoading
                ? Center(
                    child: SpinKitCircle(
                      color: Color(0xff18728a),
                      size: 50.0,
                    ),
                  )
                : ListView.builder(
              itemExtent: 70.0,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color(0xff18728a),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        elevation: 4.0,
                        child: InkWell(
                          child: ListTile(
                            title: Center(
                              child: Text(
                                '${listSubject[index]['subject_name']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          onTap: ()async {
                            setState(() {
                              isLoading = false;
                            });
                           Navigator.pushNamed(context,'/subject_details');
                            var subId= '${listSubject[index]['id']}';
                            await SharedPref.setSubjectId(subId);
                          },
                        ),
                      );
                    },
                    itemCount: listSubject.length,
                  ),
          ),
        ),

    );
  }
}
