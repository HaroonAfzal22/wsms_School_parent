import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

class JitsiClasses extends StatefulWidget {
  @override
  _JitsiClassesState createState() => _JitsiClassesState();
}
// for online classes use jitsi server and package to set data
class _JitsiClassesState extends State<JitsiClasses> {
  var sId = SharedPref.getStudentId();
  var token = SharedPref.getUserToken();
  var sName = SharedPref.getStudentName();
  late var mId, subjectText;
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  bool? isAudioOnly = true, isLoading = false;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));

    getData();
  }

  // to get data from api which server use jitsi or zoom
  getData() async {
    HttpRequest request = HttpRequest();
    List data = await request.getOnlineClass(context, token!, sId!);
    if (data == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      for (int i = 0; i < data.length; i++) {
        var meetingId = data[i]['meeting_id'];
        setState(() {
          mId = meetingId;
          isLoading = false;
          _joinMeeting(mId);
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      subjectText = args['subject_name'];
    });
    return Container();
  }

  // for join meeting all are built-in method is appear in package
  _joinMeeting(meetingId) async {
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    } else if (Platform.isIOS) {
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: '$meetingId')
      ..serverURL = 'https://meet.jit.si'
      ..subject = '$subjectText'
      ..userDisplayName = '$sName'
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags);
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
    Navigator.pop(context);
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
