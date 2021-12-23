import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/AccountBook.dart';
import 'package:wsms/AttendanceHtml.dart';
import 'package:wsms/ComplaintsList.dart';
import 'package:wsms/DailyDiary.dart';
import 'package:wsms/Dashboard.dart';
import 'package:wsms/ExamReport.dart';
import 'package:wsms/LeaveAppList.dart';
import 'package:wsms/LeaveApply.dart';
import 'package:wsms/LeaveCategory.dart';
import 'package:wsms/LocalDb.dart';
import 'package:wsms/MonthlyExamReport.dart';
import 'package:wsms/MonthlyTestSchedule.dart';
import 'package:wsms/Notifications.dart';
import 'package:wsms/OnlineClassList.dart';
import 'package:wsms/OnlineClasses.dart';
import 'package:wsms/ResultCategory.dart';
import 'package:wsms/SubjectDetails.dart';
import 'package:wsms/SubjectResult.dart';
import 'package:wsms/Subjects.dart';
import 'package:wsms/ClassTimeTable.dart';
import 'package:wsms/TimeTableCategory.dart';
import 'package:wsms/student_attendance.dart';
import 'ComplaintsApply.dart';
import 'ComplaintsCategory.dart';
import 'JitsiClasses.dart';
import 'MainScreen.dart';
import 'Profile.dart';
import 'Shared_Pref.dart';


// for implementation of firebase notification
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  print('a bg message just show up:${message.data}');
}
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

//for local storage as sqflite
late final database;

//for notification counter
int counts=0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ignore: unnecessary_statements
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // for local storage create db, tables,
  Directory doxDir = await getApplicationDocumentsDirectory();
  database = openDatabase(
    join(doxDir.path, 'wsms.db'),
    onCreate: (dbs, version) async {
     await dbs.execute('CREATE TABLE profile (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE subjects (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE attendance (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE notification (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE test_marks (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE time_table (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE daily_diary (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE online_classes (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE account_details (data TEXT NON NULL)');
     await dbs.execute('CREATE TABLE monthly_exam_report (data TEXT NON NULL)');

    },
    version: 1,
  );

  //https://wsms-0.flycricket.io/privacy.html


  //for phoenix used for restart app
  runApp(Phoenix(child: MyApp()));
}
late final model;
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print('main.dart');
    super.initState();
    firebaseMessaging.getToken().then((value) {
      setState(() {
        SharedPref.setUserFcmToken(value!); // to save fcm token to sent server
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     /* RemoteNotification ?notification = message.notification;
      AndroidNotification ?android = message.notification?.android;

      if (notification != null && android != null) {
        Navigator.pushNamed(this.context, '/notifications');

      }*/
    });
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(// provide use for state management
      providers: [
        ChangeNotifierProvider(create: (_)=>LocalDb()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/dashboard': (context) => Dashboard(),
          '/profile': (context) => Profile(),
          '/subjects': (context) => Subjects(),
          '/notifications': (context) => Notifications(),
          '/subject_details': (context) => SubjectDetails(),
          '/subject_result': (context) => SubjectResult(),
          '/daily_diary': (context) => DailyDiary(),
          '/accounts_book': (context) => AccountBook(),
          '/student_attendance': (context) => StudentAttendance(),
          '/attendance_html': (context) => AttendanceHtml(),
          '/time_table': (context) => ClassTimeTable(),
          '/monthly_test_schedule': (context) => MonthlyTestSchedule(),
          '/time_table_category': (context) => TimeTableCategory(),
          '/monthly_exam_report': (context) => MonthlyExamReport(),
          '/exam_report': (context) => ExamReport(),
          '/result_category': (context) => ResultCategory(),
          '/online_classes': (context) => OnlineClasses(),
          '/jitsi_classes': (context) => JitsiClasses(),
          '/online_class_list': (context) => OnlineClassList(),
          '/leave_category': (context) => LeaveCategory(),
          '/leave_apply': (context) => LeaveApply(),
          '/leave_apply_list': (context) => LeaveApplyList(),
          '/complaints_category': (context) => ComplaintsCategory(),
          '/complaints_apply': (context) => ComplaintsApply(),
          '/complaints_list': (context) => ComplaintsList(),
        },
        home: MainScreen(),//login screen
      ),
    );
  }
}
