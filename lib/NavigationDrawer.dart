import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Shared_Pref.dart';

class Drawers extends StatefulWidget {
  final dashboards, aboutUs, complaint, PTM, Leave;
  final onPress;
  Drawers({required this.dashboards,
    required this.aboutUs,
    required this.complaint,
    required this.PTM,
    required this.onPress,
    required this.Leave});

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {

  var image =SharedPref.getUserAvatar();
  var name =SharedPref.geUserName();
  late var newColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  newColor=getSchoolColor();
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
                          imageUrl:image !=null ? image!:'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg',
                          imageBuilder: (context, imageProvider) => CircleAvatar(
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
                            onPressed: widget.onPress,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          listTiles(
              icon: Icons.home, onClick: widget.dashboards, text: 'Dashboard'),
          listTiles(
              icon: CupertinoIcons.book_fill,
              onClick: () {
                print('about us click');
              },
              text: 'About Us'),
          listTiles(
              icon: Icons.assignment_rounded,
              onClick: () {
                print('complaints click');
              },
              text: 'Complaints'),
          listTiles(
              icon: Icons.meeting_room,
              onClick: () {
                print('ptm click');
              },
              text: 'Parent Teacher Meeting'),
          listTiles(
              icon: Icons.touch_app_sharp,
              onClick: () {
                print('leave  click');
              },
              text: 'Leave Application Apply'),
        ],
      ),
    );
  }
}
Column listTiles({required IconData icon, required String text, required var onClick}) {
  return Column(
    children: [
      ListTile(
        leading: Icon(
          icon,
          color: Color(int.parse('${getSchoolColor()}')),
        ),
        title: Text(text),
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
