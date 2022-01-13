import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:wsms/ClassActivity.dart';
import 'package:wsms/Community.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Dashboard.dart';
import 'package:wsms/Shared_Pref.dart';

class AppCategory extends StatefulWidget {
  @override
  _AppCategoryState createState() => _AppCategoryState();
}

class _AppCategoryState extends State<AppCategory> {
  var newColor = SharedPref.getSchoolColor(),
      br = SharedPref.getBranchName(),
      sc = SharedPref.getSchoolName();
  var r = SharedPref.getRoleId();
  var log = 'assets/background.png';
  var logos = SharedPref.getSchoolLogo();
  bool isLoading = false;
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomsKey = GlobalKey();

  final resultScreens = [
    Dashboard(),
    Community(),
    ClassActivity(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future(() async {
      await setColor();
      _checkVersion();
    });
  }

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

  _checkVersion() async {
    final newVersion = NewVersion(androidId: "com.wasisoft.wsms");
    final status = await newVersion.getVersionStatus();
    await SharedPref.setAppVersion(status!.storeVersion);

    if (!status.storeVersion.contains(status.localVersion)) {
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
                            //db.close();
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
                    //  await db.close();
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: spinkit, //declared in constants class
            ),
          )
        : Scaffold(
            backgroundColor: Color(int.parse('$newColor')),
            extendBody: true,
            bottomNavigationBar: CurvedNavigationBar(
              index: _page,
              color: Color(int.parse('$newColor')),
              backgroundColor: Colors.transparent,
              key: _bottomsKey,
              height: 50,
              items: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 30,
                    ),
                    Visibility(
                      visible: _page == 0 ? false : true,
                      child: Text(
                        'Home',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.person_3_fill,
                        color: Colors.white, size: 30),
                    Visibility(
                        visible: _page == 1 ? false : true,
                        child: Text(
                          'Community',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.person_2_fill,
                        color: Colors.white, size: 30),
                    Visibility(
                        visible: _page == 2 ? false : true,
                        child: Text(
                          'Class Activity',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
              onTap: (index) {
                setState(() {
                  _page = index;
                });
              },
            ),
            body: WillPopScope(
                onWillPop: _onWillPop,
                child: SafeArea(bottom: false, child: resultScreens[_page])),
          );
  }

  @override
  void dispose() {
    _page = 0;
    super.dispose();
  }

/*joinMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;
      print('is called');
      if (Platform.isAndroid)
        result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
      else
        result = status == "MEETING_STATUS_IDLE";

      return result;
    }
    if(mId.isNotEmpty && mPass.isNotEmpty){
      ZoomOptions zoomOptions = new ZoomOptions(
        domain: "zoom.us",
        appKey: "OwDb6fY72qHf71tEGZtlfYyxEiBCdOaXbIBy", //API KEY FROM ZOOM
        appSecret: "AFlUoisnwW1pkB2aGFMSDWudjpVlSRNIaQaj", //API SECRET FROM ZOOM
      );
      var meetingOptions = new ZoomMeetingOptions(
          userId: '$sName', //pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: '$mId', //pass meeting id for join meeting only
          meetingPassword: '$mPass', //pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          disableTitlebar: "false",
          viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false"
      );

      var zoom = ZoomView();
      zoom.initZoom(zoomOptions).then((results) {
        if(results[0] == 0) {
          zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            if (_isMeetingEnded(status[0])) {
              print("[Meeting Status] :- Ended");
              timer.cancel();
            }
          });
          print("listen on event channel");
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(new Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!)
                  .then((status) {
                print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
              });
            });
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
    }else{
      if(mId.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      }
      else if(mPass.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }

  }*/
}
