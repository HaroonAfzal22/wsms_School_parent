import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_version/new_version.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'DashboardCards.dart';
import 'NavigationDrawer.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List value;
  var token = SharedPref.getUserToken();
  var fcmToken = SharedPref.getUserFcmToken();
  var newColor = SharedPref.getSchoolColor(),
      br = SharedPref.getBranchName(),
      sc = SharedPref.getSchoolName();
  var r = SharedPref.getRoleId();
  bool isLoading = false;
  var log = 'assets/background.png';
  var logos = SharedPref.getSchoolLogo();

  Future<bool> _onWillPop() async {
    if (Platform.isIOS) {
      return await showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text('Close Application'),
                    content: Text('Do you want to exit an App?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      CupertinoDialogAction(
                        child: Text('Yes'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  )) ??
          false;
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Close Application'),
              content: Text('Do you want to exit an App?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  setLogo() {
    if (logos != null) {
      return '$logos';
    } else
      return '$log';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('dashboard.dart');

    isLoading = true;
  print('new color $newColor');
    setColor();
    _checkVersion();
    getData();
  }

  setColor() {
    if (newColor == null && logos == null && br == null && sc == null) {
      Future(() async {
        await getSchoolInfo(context);
        await getSchoolColor();
        setState(() {
          newColor = SharedPref.getSchoolColor()!;
          logos = SharedPref.getSchoolLogo();
          br = SharedPref.getBranchName();
          sc = SharedPref.getSchoolName();
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getData() async {
    HttpRequest request = HttpRequest();
    var result = await request.getChildren(
      context,
      token!,
    );
    if (result == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        value = result;
      });
    }
  }

  _checkVersion() async {
    final newVersion = NewVersion(androidId: "com.wasisoft.wsms");
    final status = await newVersion.getVersionStatus();
    if (!status!.storeVersion.contains(status.localVersion)) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available!!!',
        dialogText:
            'A new Version of WSMS is available! Version ${status.storeVersion} but your Version is  ${status.localVersion}.\n\n Would you Like to update it now?',
        updateButtonText: 'Update Now',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: SpinKitCircle(
                color: Color(int.parse('0xff15728a')),
                size: 50.0,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leadingWidth: 30.0,
              backgroundColor: Color(int.parse('$newColor')),
              title: Row(
                children: [
                  Expanded(
                    child: titleIcon(setLogo()),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      '$sc\n $br',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              actions: <Widget>[
                Container(
                  child: iconButtons(
                      icons: CupertinoIcons.bell_solid,
                      onPress: () {
                        print('notification click');
                      }),
                ),
                Visibility(
                  visible: true,
                  child: iconButtons(
                      icons: Icons.storage_rounded,
                      onPress: () {
                        _settingModalBottomSheet(context);
                      }),
                ),
              ],
            ),
            drawer: Drawers(result: (res){
              print('v $res ');
            },),
            body: SafeArea(
              child: isLoading
                  ? Center(child: spinkit)
                  : BackgroundWidget(
                      childView: WillPopScope(
                        onWillPop: _onWillPop,
                        child: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DashboardViews(
                                  title1: 'Profile',
                                  title2: 'Subjects',
                                  onPress1: () {
                                    Navigator.pushNamed(context, '/profile');
                                  },
                                  onPress2: () {
                                    Navigator.pushNamed(context, '/subjects',
                                        arguments: {
                                          'card_type': 'subject',
                                        });
                                  },
                                  url1:
                                      'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg',
                                  url2:
                                      'https://st.depositphotos.com/1741875/1237/i/950/depositphotos_12376816-stock-photo-stack-of-old-books.jpg',
                                ),
                                DashboardViews(
                                  title1: 'Results',
                                  title2: 'Daily Diary',
                                  onPress1: () {
                                    Navigator.pushNamed(
                                        context, '/result_category',
                                        arguments: {
                                          'card_type': 'result',
                                        });
                                  },
                                  onPress2: () {
                                    Navigator.pushNamed(
                                        context, '/daily_diary');
                                  },
                                  url1:
                                      'https://st2.depositphotos.com/1005979/8328/i/950/depositphotos_83286562-stock-photo-report-card-a-plus.jpg',
                                  url2:
                                      'https://static8.depositphotos.com/1323913/926/v/950/depositphotos_9261330-stock-illustration-vector-personal-organizer-features-xxl.jpg',
                                ),
                                DashboardViews(
                                  title1: 'Account Book',
                                  title2: 'Time Table',
                                  onPress1: () {
                                    Navigator.pushNamed(
                                        context, '/accounts_book');
                                  },
                                  onPress2: () {
                                    Navigator.pushNamed(
                                        context, '/time_table_category');
                                  },
                                  url1:
                                  'https://static9.depositphotos.com/1004887/1206/i/950/depositphotos_12064461-stock-photo-accounting.jpg',
                                  url2:
                                  'https://images.unsplash.com/photo-1518607692857-bff9babd9d40?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=667&q=80',
                                ),
                                DashboardViews(
                                  title1: 'Online Classes',
                                  title2: 'Attendance',
                                  onPress1: () {
                                    Navigator.pushNamed(
                                        context, '/online_class_list');
                                  },
                                  onPress2: () {
                                    Navigator.pushNamed(
                                        context, '/student_attendance');
                                  },
                                  url1:
                                  'https://media.istockphoto.com/vectors/online-education-duringquarantine-covid19-coronavirus-disease-vector-id1212946108?s=612x612',
                                  url2:
                                  'https://media.istockphoto.com/vectors/businessman-hands-holding-clipboard-checklist-with-pen-checklist-vector-id935058724?s=612x612',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ));
  }


  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Color(0xffEBF5FB),
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (BuildContext bc) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 9),
                  child: Divider(
                    thickness: 1.0,
                    height: 0.5,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  'Children',
                  style: TextStyle(
                      color: Color(
                        int.parse('$newColor'),
                      ),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 9),
                  child: Divider(
                    thickness: 1.0,
                    height: 0.5,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            shrinkWrap: true,
            itemBuilder: (context, index) => InkWell(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                color: Color(int.parse('$newColor')),
                child: ListTile(
                  leading: Card(
                    elevation: 4.0,
                    clipBehavior: Clip.antiAlias,
                    shape: CircleBorder(),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: value[index]['avatar'],
                    ),
                  ),
                  title: Text(value[index]['name'],
                      style: TextStyle(color: Colors.orange)),
                  subtitle: Text(
                    'Roll No# ${value[index]['roll_no']}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                await SharedPref.setStudentId(value[index]['id'].toString());
                Navigator.of(context).pop();
                toastShow('${value[index]['name']} selected');
              },
            ),
            itemCount: value.length,
          ),
        ],
      ),
    );
  }
}
