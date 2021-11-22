import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';

class Drawers extends StatefulWidget {
  Drawers();

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
  Future<void> updateApp() async {
    Map map = {
      'fcm_token': fcmToken,
    };
    HttpRequest request = HttpRequest();
    var results = await request.postUpdateApp(context, token!, map);
    if (results == 500) {
      toastShow('Server Error!!! Try Again Later...');
    } else {
      SharedPref.removeSchoolInfo();
      await getSchoolInfo(context);
      await getSchoolColor();
      setState(() {
        newColor = SharedPref.getSchoolColor()!;
      });

      results['status'] == 200
          ? snackShow(context, 'Sync Successfully')
          : snackShow(context, 'Sync Failed');
    }
  }

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
                          onPressed: () async {
                            // on signout remove all local db and shared preferences
                            HttpRequest request = HttpRequest();
                            var res =
                                await request.postSignOut(context, token!);
                            await dbs.execute('DELETE FROM daily_diary ');
                            await dbs.execute('DELETE FROM profile ');
                            await dbs.execute('DELETE FROM test_marks ');
                            await dbs.execute('DELETE FROM subjects ');
                            await dbs
                                .execute('DELETE FROM monthly_exam_report ');
                            await dbs.execute('DELETE FROM time_table ');
                            await dbs.execute('DELETE FROM attendance ');
                            Navigator.pushReplacementNamed(context, '/');
                            setState(() {
                              if (res['status'] == 200) {
                                SharedPref.removeData();
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
              onClick: () async {
                await updateApp();
                Phoenix.rebirth(context);
                Navigator.pop(context);
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
