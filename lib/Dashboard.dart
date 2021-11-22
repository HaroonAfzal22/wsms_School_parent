import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_version/new_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/LocalDb.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';
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
  late final db;
  String u1 =
          'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg',
      u2 =
          'https://st.depositphotos.com/1741875/1237/i/950/depositphotos_12376816-stock-photo-stack-of-old-books.jpg',
      u3 =
          'https://st2.depositphotos.com/1005979/8328/i/950/depositphotos_83286562-stock-photo-report-card-a-plus.jpg',
      u4 =
          'https://static8.depositphotos.com/1323913/926/v/950/depositphotos_9261330-stock-illustration-vector-personal-organizer-features-xxl.jpg',
      u5 =
          'https://static9.depositphotos.com/1004887/1206/i/950/depositphotos_12064461-stock-photo-accounting.jpg',
      u6 =
          'https://images.unsplash.com/photo-1518607692857-bff9babd9d40?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=667&q=80',
      u7 =
          'https://media.istockphoto.com/vectors/online-education-duringquarantine-covid19-coronavirus-disease-vector-id1212946108?s=612x612',
      u8 =
          'https://media.istockphoto.com/vectors/businessman-hands-holding-clipboard-checklist-with-pen-checklist-vector-id935058724?s=612x612';

  // for backpress click to show dialog
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
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            db.close();
                          }),
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
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await db.close();
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  // set logo in toolbar
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
    print('dashboard.dart $newColors');
    isLoading = true;
    Future(() async {
      db = await database;
      await setColor();
      _checkVersion();
      getData();
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  color: Colors.amber[600],
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
      print('message is ${message.data}');
      if (mounted) {
        setState(() {
          counts++;
        });
      }
    });
  }

  // set color of dynamically in app where constants class implemented
  Future setColor() async {
    if (newColor == null && logos == null && br == null && sc == null) {
      await getSchoolInfo(context);
      await getSchoolColor();
      setState(() {
        newColor = SharedPref.getSchoolColor()!;
        logos = SharedPref.getSchoolLogo();
        br = SharedPref.getBranchName();
        sc = SharedPref.getSchoolName();
      });
      if (newColor != null) {
        isLoading = false;
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  //if parent login then their children get it
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
      if(mounted) {
        setState(() {
          value = result;
        });
      }
    }
  }

  //for check the verison of app is it update available?
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
              child: spinkit,//declared in constants class
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leadingWidth: 30.0,
              backgroundColor: Color(int.parse('$newColor')),
              title: Row(
                children: [
                  Expanded(
                    child: titleIcon(setLogo()),//set logo in constant class
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
                  child: counts > 0
                      ? Badge( // to set count of notification if not click on icon
                          animationType: BadgeAnimationType.fade,
                          position: BadgePosition.topEnd(top: 6, end: 0),
                          badgeContent: Text(
                            '$counts',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          child: iconButtons(
                              icons: CupertinoIcons.bell_solid,
                              onPress: () {
                                Navigator.pushNamed(context, '/notifications');
                                setState(() {
                                  counts = 0;
                                });
                              }),
                        )
                      : iconButtons(
                          icons: CupertinoIcons.bell_solid,
                          onPress: () {
                            Navigator.pushNamed(context, '/notifications');
                          }),
                ),
                Visibility(
                  visible: true,
                  child: iconButtons(
                      icons: CupertinoIcons.square_grid_2x2_fill,
                      onPress: () {
                        _settingModalBottomSheet(context);
                      }),
                ),
              ],
            ),
            drawer: Drawers(),// navigation drawer declared in separate class and implement it
            body: SafeArea(
              child: isLoading
                  ? Center(child: spinkit)
                  : BackgroundWidget(
                // background class use for background logo of any class
                      childView: WillPopScope(
                        onWillPop: _onWillPop,
                        child: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DashboardViews(// separate class dashboard view to set dynamically
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
                                  url1: u1,
                                  url2: u2,
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
                                  url1: u3,
                                  url2: u4,
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
                                  url1: u5,
                                  url2: u6,
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
                                  url1: u7,
                                  url2: u8,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          );
  }

  //for modal bottom sheet to show children
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Color(0xffD7CCC8),
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
