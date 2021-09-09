import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:wsms/Constants.dart';
class OnlineClasses extends StatelessWidget {

 late  ZoomOptions zoomOptions;
 late  ZoomMeetingOptions meetingOptions;

  late Timer timer;

  OnlineClasses()  {
    // Setting up the Zoom credentials
    this.zoomOptions =  ZoomOptions(
      appKey: "AQHfhYRDiRQCWfZye4LWcvDUWaDrpZijc02S", // Replace with with key got from the Zoom Marketplace
      appSecret: "3sBG09YqDR0PeJcool7nx1dza9Sm9JW9XV7J", // Replace with with secret got from the Zoom Marketplace
    );

    // Setting Zoom meeting options (default to false if not set)
    this.meetingOptions = new ZoomMeetingOptions(
        userId: 'adnan', //pass username for join meeting only
        meetingId: '87966473954', //pass meeting id for join meeting only
        meetingPassword: 'b2AMup', //pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        disableTitlebar: "true", //Make it true for disabling titlebar
        viewOptions: "true", //Make it true for hiding zoom icon on meeting ui which shows meeting id and password
        noDisconnectAudio: "false"
    );
  }

  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Class '),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ZoomView(onViewCreated: (controller) {

            print("Created the view");

            controller.initZoom(this.zoomOptions).then((results) {
                print('init result is $results');
              if(results[0] == 0) {

                // Listening on the Zoom status stream (1)
                controller.zoomStatusEvents.listen((status) {

                  print("Meeting Status Stream: " + status[0] + " - " + status[1]);

                  if (_isMeetingEnded(status[0])) {
                    Navigator.pop(context);
                    timer.cancel();
                  }
                });

                print("listen on event channel");

                controller.joinMeeting(this.meetingOptions)
                    .then((joinMeetingResult) {
                  // Polling the Zoom status (2)
                  timer = Timer.periodic(new Duration(seconds: 2), (timer) {
                    controller.meetingStatus(this.meetingOptions.meetingId!)
                        .then((status) {
                          print('meeting id is ${this.meetingOptions.meetingId}');

                      print("Meeting Status Polling: " + status[0] + " - " + status[1]);
                    });
                  });
                });
              }

            }).catchError((error) {
              print('no success $error');
            });
          })
      ),
    );
  }
}