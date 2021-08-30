import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wsms/AccountBook.dart';
import 'package:wsms/Dashboard.dart';
import 'package:wsms/MonthlyExamReport.dart';
import 'package:wsms/MonthlyTestSchedule.dart';
import 'package:wsms/ResultCategory.dart';
import 'package:wsms/SubjectDetails.dart';
import 'package:wsms/SubjectResult.dart';
import 'package:wsms/Subjects.dart';
import 'package:wsms/ClassTimeTable.dart';
import 'package:wsms/TimeTableCategory.dart';
import 'package:wsms/student_attendance.dart';
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

String? fcmToken='empty';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  await Firebase.initializeApp();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
   firebaseMessaging.getToken().then((value) => {
        fcmToken=value!,
  });

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

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xff15728a),
    ),
  );
  SystemChrome.setEnabledSystemUIOverlays(
    <SystemUiOverlay>[
      SystemUiOverlay.top,
    ],
  );

  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
    setToken();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  setToken()async{
    await SharedPref.setUserFcmToken(fcmToken!);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/dashboard': (context)=>Dashboard(),
        '/profile': (context)=>Profile(),
        '/subjects': (context)=>Subjects(),
        '/subject_details': (context)=>SubjectDetails(),
        '/subject_result': (context)=>SubjectResult(),
        '/accounts_book': (context)=>AccountBook(),
        '/student_attendance': (context)=>StudentAttendance(),
        '/time_table': (context)=>ClassTimeTable(),
        '/monthly_test_schedule': (context)=>MonthlyTestSchedule(),
        '/time_table_category': (context)=>TimeTableCategory(),
        '/monthly_exam_report': (context)=>MonthlyExamReport(),
        '/result_category': (context)=>ResultCategory(),
      },
      theme: ThemeData(
        primaryColor: Color(0xff15728a),
        accentColor: Color(0xff15728a),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
