import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';
import 'NavigationDrawer.dart';
import 'ProfileDetails.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = '', gTitle = '';
  var address = '', gName = '';
  var class_name = '';
  var section_name = '';
  var father_number = '';
  var rollNo = '';
  String photo =
      'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg';
  var newColor = SharedPref.getSchoolColor();
  var image = SharedPref.getUserAvatar();
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  var role = SharedPref.getRoleId();
  late final db;

  @override
  initState() {
    super.initState();
    isLoading = true;
    Future(() async {
      db = await database;
      getData();
    });
  }

  getData() async {
    var value = await db.query('profile');
    if (value.isNotEmpty) {
      setState(() {
        var profileData = jsonDecode(value[0]['data']);
        name = profileData['name'].toString();
        gName = profileData['group_name'].toString();
        gTitle = profileData['sub_group_title'].toString();
        var add = profileData['address'];
        add != null ? address = add : address = 'No Address Given';
        var pic = profileData['avatar'];
        print('pic $pic');
        pic != null
            ? photo = pic
            : photo =
                'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg';
        var num = profileData['roll_no'];
        num != null ? rollNo = num : rollNo = 'No Roll Number';
        class_name = profileData['class_name'].toString();
        section_name = profileData['section_name'].toString();
        father_number = profileData['father_phone'].toString();
        isLoading = false;
      });
    } else {
      HttpRequest request = HttpRequest();
      var profileData = await request.getProfile(context, token!, tok!);
      await db.execute('DELETE  FROM  profile');

      if (profileData == 500) {
        toastShow('Server Error!!! Try Again Later...');
        setState(() {
          isLoading = false;
        });
      } else {
        Map<String, Object?> map = {
          'data': jsonEncode(profileData),
        };
        await db.insert('profile', map,
            conflictAlgorithm: ConflictAlgorithm.replace);
        setState(() {
          name = profileData['name'].toString();
          gName = profileData['group_name'].toString();
          gTitle = profileData['sub_group_title'].toString();
          var add = profileData['address'];
          add != null ? address = add : address = 'No Address Given';
          var pic = profileData['avatar'];
          pic != null
              ? photo = pic
              : photo =
                  'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg';
          var num = profileData['roll_no'];
          num != null ? rollNo = num : rollNo = 'No Roll Number';
          class_name = profileData['class_name'].toString();
          section_name = profileData['section_name'].toString();
          father_number = profileData['father_phone'].toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    HttpRequest request = HttpRequest();
    var profileData = await request.getProfile(context, token!, tok!);
    await db.execute('DELETE  FROM  profile');

    if (profileData == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      Map<String, Object?> map = {
        'data': jsonEncode(profileData),
      };
      await db.insert('profile', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      setState(() {
        name = profileData['name'].toString();
        gName = profileData['group_name'].toString();
        gTitle = profileData['sub_group_title'].toString();
        var add = profileData['address'];
        add != null ? address = add : address = 'No Address Given';
        var pic = profileData['avatar'];
        pic != null
            ? photo = pic
            : photo =
                'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg';
        var num = profileData['roll_no'];
        num != null ? rollNo = num : rollNo = 'No Roll Number';
        class_name = profileData['class_name'].toString();
        section_name = profileData['section_name'].toString();
        father_number = profileData['father_phone'].toString();
        isLoading = false;
      });
    }
  }

  String imageSet() {
    if (role == 3) {
      return image!;
    } else
      return photo;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Profile'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer: Drawers(),
      body: isLoading
          ? Center(
              child: spinkit,
            )
          : BackgroundWidget(
              childView: RefreshIndicator(
                onRefresh:updateProfile,
                child: ListView(
                  children: [
                    Container(
                      color: Color(int.parse('$newColor')),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 12.0),
                            child: CachedNetworkImage(
                              key: UniqueKey(),
                              imageUrl: imageSet(),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12.0, bottom: 6.0),
                            child: Text(
                              '$name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: texts(title: 'Roll Number:'),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(bottom: 10.0, left: 10.0),
                                child: texts(title: '$rollNo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ProfileDetails(
                      result: '$class_name - $gName ( $gTitle )',
                      title: 'Class:',
                    ),
                    ProfileDetails(
                      result: '$section_name',
                      title: 'Section:',
                    ),
                    ProfileDetails(
                      result: '$father_number',
                      title: 'Contact Num:',
                    ),
                    ProfileDetails(
                      result: '$father_number',
                      title: 'Parent Contact Num:',
                    ),
                    ProfileDetails(
                      result: '$address',
                      title: 'Present Address:',
                    ),
                    ProfileDetails(
                      result: '$address',
                      title: 'Permanent Address:',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
