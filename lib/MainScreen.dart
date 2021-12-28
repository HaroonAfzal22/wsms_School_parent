import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'Background.dart';
import 'TextFields.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var tokenName = SharedPref.getUserToken();
  TextEditingController _editingController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  List<String> categoryList = ['Parents', 'Student'];
  String selectText = 'Parents';
  late List childData;
  var isChecked;

  // select category parent or student
  List<Widget> getList() {
    List<Widget> dropDown = [];
    for (String list in categoryList) {
      selectText = list;
      var newWidget = Center(
        child: Text(
          '$selectText',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff18728a)),
          textAlign: TextAlign.center,
        ),
      );
      dropDown.add(newWidget);
    }
    return dropDown;
  }

  int? newValue;
  String? userNameValue;
  String? passwordValue;
  bool isLoading = false;

  //if already login then automatically move to dashboard otherwise on login screen
  moveNext() {
    if (mounted) {
      if (tokenName != null) {
        isLoading = true;
        Future(() {
          return Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = List<bool>.filled(categoryList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return moveNext() ??
        Scaffold(
          body: SafeArea(
            child: BackgroundWidget(
              childView: isLoading
                  ? Center(
                      child: spinkit,
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 100.0),
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 48.0),
                              child: Text(
                                'Login'.toUpperCase(),
                                style: TextStyle(
                                  color: Color(0xff18728a),
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Card(
                                margin: EdgeInsets.all(8.0),
                                elevation: 8.0,
                                clipBehavior: Clip.antiAlias,
                                shadowColor: Color(0xff18728a),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    //for select category
                                    /*  Container(
                                      margin: EdgeInsets.all(20.0),
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.white,
                                        itemExtent: 40.0,
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            newValue = value;
                                          });
                                        },
                                        children: getList(),
                                      ),
                                    )*/
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: categoryList.length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width/2,
                                              margin: EdgeInsets.only(left: 12.0),
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Checkbox(
                                                    activeColor: Color(0xff15728a),
                                                    value: isChecked[i],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if(isChecked.toString().contains('true')){
                                                          isChecked = List<bool>.filled(categoryList.length, false);
                                                          isChecked[i] = value;
                                                        }else {
                                                          isChecked[i] = value;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    '${categoryList[i]}',
                                                    style: TextStyle(
                                                        color: Color(0xff15728a),
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    TextFields(
                                      title: 'Enter username',
                                      iconValue: CupertinoIcons.envelope_fill,
                                      onChangedValue: (value) {
                                        userNameValue = value;
                                      },
                                      keyType: TextInputType.text,
                                      visibility: false,
                                      control: _editingController,
                                    ),
                                    TextFields(
                                      title: 'Enter Password',
                                      keyType: TextInputType.visiblePassword,
                                      iconValue: CupertinoIcons.eye_slash_fill,
                                      onChangedValue: (value) {
                                        passwordValue = value;
                                      },
                                      visibility: true,
                                      control: _controller,
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(12.0),
                                      width: 100.0,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          var tokenFcm = SharedPref.getUserFcmToken();
                                          if (isChecked[1] == true) {
                                            studentAttendance(tokenFcm);
                                          } else {
                                            parentAttendance(tokenFcm);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff18728a)),
                                        child: Text(
                                          'Login'.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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

// for student login details if successfully login then move to dashboard
  studentAttendance(tokenFcm) async {
    setState(() {
      if (userNameValue != null && passwordValue != null) {
        isLoading = true;
      } else {
        toastShow("Please fill required field");
        isLoading = false;
      }
    });
    HttpRequest httpReq = HttpRequest();
    var loginResult = await httpReq.postLogin(
        context, userNameValue!, passwordValue!, tokenFcm);

    if (loginResult != null) {
      var token = loginResult['token'];
      var avatar = loginResult['user']['avatar'];
      var name = loginResult['user']['name'];
      var id = loginResult['user']['id'];
      var roleId = loginResult['user']['role_id'];

      await SharedPref.setRoleId(roleId.toString());
      await SharedPref.setStudentId(id.toString());
      await SharedPref.setUserToken(token);
      await SharedPref.setUserAvatar(avatar);
      await SharedPref.setUserName(name);
      Navigator.pushReplacementNamed(context, '/dashboard');

      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: "Login Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff15728a),
            textColor: Colors.white,
            fontSize: 12.0);
      });
    } else {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff15728a),
            textColor: Colors.white,
            fontSize: 12.0);
      });
    }
  }

  //for parent login details if successfully login then move to dashboard
  parentAttendance(tokenFcm) async {
    setState(() {
      if (userNameValue != null && passwordValue != null) {
        isLoading = true;
      } else {
        toastShow("Please fill required field");
        isLoading = false;
      }
    });
    HttpRequest httpReq = HttpRequest();
    var loginResult = await httpReq.parentLogin(
        context, userNameValue!, passwordValue!, tokenFcm);
    if (loginResult != null) {
      var token = loginResult['token'];
      var name = loginResult['user']['name'];
      var schoolId = loginResult['user']['school_id'];
      var avatar = loginResult['user']['avatar'];
      var roleId = loginResult['user']['role_id'];
      await SharedPref.setSchoolId(schoolId.toString());

      await SharedPref.setRoleId(roleId.toString());
      await SharedPref.setUserToken(token);
      await SharedPref.setUserAvatar(avatar);
      await SharedPref.setUserName(name);
      List childList = loginResult['user']['children'];
      // await SharedPref.setChildren(List.castFrom(childList));
      for (int i = 0; i < childList.length; i++) {
        var id = childList[i]['id'];
        var sName = childList[i]['name'];
        await SharedPref.setStudentId(id.toString());
        await SharedPref.setStudentName(sName.toString());
      }
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: "Login Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(int.parse('0xff15728a')),
            textColor: Colors.white,
            fontSize: 12.0);
      });
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: 'Login Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(int.parse('0xff15728a')),
            textColor: Colors.white,
            fontSize: 12.0);
      });
    }
  }
}
