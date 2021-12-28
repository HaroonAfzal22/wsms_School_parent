import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';

class Drawers extends StatefulWidget {
  final logout,sync;
  Drawers({required this.logout,required this.sync});

  @override
  _DrawersState createState() => _DrawersState();
}

// Navigation Drawer used to set data
class _DrawersState extends State<Drawers> {
  var image = SharedPref.getUserAvatar(),
      name = SharedPref.geUserName(),
      newColor = SharedPref.getSchoolColor(),
      token = SharedPref.getUserToken(),
      fcmToken = SharedPref.getUserFcmToken();
  late final dbs;


  // to update fcm token and get new color from api

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // init local db
    Future(() async {
      dbs = await database;
    });
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
                          onPressed:widget.logout,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          //listTiles class use for design drawer items
          listTiles(
              icon: Icons.home,
              onClick: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              text: 'Dashboard'),
          listTiles(
              icon: CupertinoIcons.arrow_2_squarepath,
              onClick: widget.sync,
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
          listTiles(
              icon: Icons.android_outlined,
              onClick:  () {
              },
              text: 'Version : ${SharedPref.getAppVersion()}'),
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
