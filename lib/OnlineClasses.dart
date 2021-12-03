import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

class OnlineClasses extends StatefulWidget {
  @override
  _OnlineClassesState createState() => _OnlineClassesState();
}

class _OnlineClassesState extends State<OnlineClasses> {
  late Timer timer;
  var sId = SharedPref.getStudentId();
  var token = SharedPref.getUserToken();
  var sName = SharedPref.getStudentName();
  late var mId, mPass, newColor = SharedPref.getSchoolColor();
  late ZoomOptions zoomOptions;
  late ZoomMeetingOptions meetingOptions;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        onlineClass(mId, mPass);
        isLoading=false;
      });
    });
   // getData();
  }

  getData() async {
    HttpRequest request = HttpRequest();
    List data = await request.getOnlineClass(context, token!, sId!);
    print('data is $data');
    for (int i = 0; i < data.length; i++) {
      var meetingId = data[i]['meeting_id'];
      var meetingPassword = data[i]['password'];
      setState(() {
        mId = meetingId;
        mPass = meetingPassword;
        isLoading = false;
      });
    }
  }

  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";

    return result;
  }

  onlineClass(meetingId, meetingPassword) async {
    // Setting up the Zoom credentials

    this.zoomOptions = ZoomOptions(
      domain: "zoom.us",
      appKey: "AQHfhYRDiRQCWfZye4LWcvDUWaDrpZijc02S",
      // Replace with with key got from the Zoom Marketplace
      appSecret:
          "3sBG09YqDR0PeJcool7nx1dza9Sm9JW9XV7J", // Replace with with secret got from the Zoom Marketplace
    );

    // Setting Zoom meeting options (default to false if not set)
    this.meetingOptions = new ZoomMeetingOptions(
        userId: '$sName',
        //pass username for join meeting only
        meetingId: '$meetingId',
        //pass meeting id for join meeting only
        meetingPassword: '$meetingPassword',
        //pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        disableTitlebar: "false",
        //Make it true for disabling titlebar
        viewOptions: "true",
        //Make it true for hiding zoom icon on meeting ui which shows meeting id and password
        noDisconnectAudio: "false");
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      mPass = args['password'];
      mId = args['meeting_id'];
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Class'),
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: isLoading
          ? Center(
              child: spinkit,
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: ZoomView(onViewCreated: (controller) async {
               // toastShow('Joining class...');
                controller.initZoom(this.zoomOptions).then((results) {
                  if (results[0] == 0) {

                    // Listening on the Zoom status stream (1)
                    controller.zoomStatusEvents.listen((status) {
                      if (_isMeetingEnded(status[0])) {
                        Navigator.pop(context);
                        timer.cancel();
                      }
                    });
                    controller.joinMeeting(this.meetingOptions).then((joinMeetingResult) {
                      // Polling the Zoom status (2)
                      timer = Timer.periodic(new Duration(seconds: 2), (timer) {
                        controller
                            .meetingStatus(this.meetingOptions.meetingId!)
                            .then((status) {
                         /* if (status[0] == 'MEETING_STATUS_IDLE') {
                            timer.cancel();

                          }*/
                        });
                      });
                    });
                  }
                }).catchError((error) {
                  print('no success $error');
                });
              })),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //timer.cancel();
  }
}
