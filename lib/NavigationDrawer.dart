import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

class Drawers extends StatefulWidget {
 late final   result;
  Drawers({required this.result});

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  var image = SharedPref.getUserAvatar();
  var name = SharedPref.geUserName();
  var newColor = SharedPref.getSchoolColor();
  var token = SharedPref.getUserToken();
  var fcmToken = SharedPref.getUserFcmToken();

  void updateApp() async {
    Map map = {
      'fcm_token': fcmToken,
    };
    HttpRequest request = HttpRequest();
    var result = await request.postUpdateApp(context, token!, map);
    if (result == 500) {
      toastShow('Server Error!!! Try Again Later...');
    } else {
        SharedPref.removeSchoolInfo();
        print('result $newColor');
        await getSchoolInfo(context);
        await getSchoolColor();
        setState(() {
          newColor = SharedPref.getSchoolColor()!;
        });

      result['status'] == 200
          ? snackShow(context, 'Sync Successfully')
          : snackShow(context, 'Sync Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Color(int.parse('$newColor')),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl: image!.endsWith('.png')
                              ? image!
                              : 'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 40,
                            backgroundImage: imageProvider,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12.0),
                        child: Text(
                          '$name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 12.0),
                        child: TextButton(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          onPressed: () async {
                            HttpRequest request = HttpRequest();
                            var res =
                                await request.postSignOut(context, token!);
                            setState(() {
                              if (res['status'] == 200) {
                                SharedPref.removeData();
                                Navigator.pushReplacementNamed(context, '/');
                                snackShow(context, 'Logout Successfully');
                              } else {
                                snackShow(context, 'Logout Failed');
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
          listTiles(
              icon: Icons.home,
              onClick: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              text: 'Dashboard'),
          listTiles(
              icon: CupertinoIcons.arrow_2_squarepath,
              onClick: () {
                updateApp();
                Navigator.pop(context);
                widget.result='clicked';
              },
              text: 'Sync Now'),
          listTiles(
              icon: Icons.assignment_rounded,
              onClick: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/complaints_category');
              },
              text: 'Complaints'),
          listTiles(
              icon: Icons.meeting_room,
              onClick: () {
                print('ptm click');
                // Navigator.pushNamed(context, '/leave_category');
              },
              text: 'Parent Teacher Meeting'),
          listTiles(
              icon: Icons.touch_app_sharp,
              onClick: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/leave_category');
              },
              text: 'Leave Application Apply'),
        ],
      ),
    );
  }
}

Column listTiles(
    {required IconData icon, required String text, required var onClick}) {
  return Column(
    children: [
      ListTile(
        leading: Icon(
          icon,
          color: Color(
              int.parse('${SharedPref.getSchoolColor() ?? '0xff15728a'}')),
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        onTap: onClick,
      ),
      Divider(
        thickness: 0.5,
        height: 0.5,
        indent: 18,
        endIndent: 20,
        color: Colors.grey.shade300,
      ),
    ],
  );
}
