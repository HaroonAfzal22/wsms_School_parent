import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:wsms/LeaveAppList.dart';
import 'package:wsms/LeaveApply.dart';
import 'package:wsms/LeaveCategory.dart';
import 'package:wsms/MonthlyExamReport.dart';
import 'package:wsms/MonthlyTestSchedule.dart';
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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  print('a bg message just show up:${notification!.body}');
}

String? fcmToken = 'empty';
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
late final database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ignore: unnecessary_statements
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  Directory doxDir = await getApplicationDocumentsDirectory();
  database = openDatabase(
    join(doxDir.path, 'wsms.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE daily_diary (data TEXT NON NULL)' );
    },
    version: 1,
  );

  //https://wsms-0.flycricket.io/privacy.html
  runApp(MyApp());
}

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
      fcmToken = value!;
      SharedPref.setUserFcmToken(value);
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
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  color: Colors.amber[600],
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => Profile(),
        '/subjects': (context) => Subjects(),
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
      home: MainScreen(),
    );
  }
}
