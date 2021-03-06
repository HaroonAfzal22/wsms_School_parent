import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';
import 'ProfileDetails.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = '', gTitle = '',address = '', gName = '',class_name = '',section_name = '',father_number = '',rollNo = '';
  String photo =
      'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg';
  var newColor = SharedPref.getSchoolColor(),image = SharedPref.getUserAvatar(),token = SharedPref.getUserToken()
  ,tok = SharedPref.getStudentId(),role = SharedPref.getRoleId();
  late final db;
   List compare =[];
  late bool isCompared;

  @override
  initState() {
    super.initState();
    isLoading = true;
    Future(() async {
      db = await database;
      (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
        setState(() {
         compare.add(row);
        });
      });
      createProfile();
    });
  }
//no used
  getData() async {
      if (compare[1]['name']=='profile') {
        var value = await db.query('profile');
        if (value.isNotEmpty) {
          var profileData = jsonDecode(value[0]['data']);
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
        else {
          HttpRequest request = HttpRequest();
          var profileData = await request.getProfile(context, token!, tok!);

          if (profileData == 500) {
            toastShow('Server Error!!! Try Again Later...');
            setState(() {
              isLoading = false;
            });
          } else {
            await db.execute('DELETE  FROM  profile');
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
            Map<String, Object?> map = {
              'data': jsonEncode(profileData),
            };
            await db.insert('profile', map,
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      }
      else {
        createProfile();
      }

  }

  createProfile()async{
    //await db.execute ('CREATE TABLE Profile (data TEXT NON NULL)');
    HttpRequest request = HttpRequest();
    var profileData = await request.getProfile(context, token!, tok!);
    setState(() {
      if(profileData==null ||profileData.isEmpty){
        toastShow('Data record not found...');
        isLoading=false;
      }else if (profileData.toString().contains('Error')){
        toastShow('$profileData...');
        isLoading=false;
      }else{
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
        isLoading=false;
      }
    });
  /*  if (profileData == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    }
    else {
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

     *//* Map<String, Object?> map = {
        'data': jsonEncode(profileData),
      };
      await db.insert('profile', map,
          conflictAlgorithm: ConflictAlgorithm.replace);*//*
    }*/
  }

  Future<void> updateProfile() async {
    HttpRequest request = HttpRequest();
    var profileData = await request.getProfile(context, token!, tok!);
    setState(() {
      if(profileData==null ||profileData.isEmpty){
        toastShow('Data record not found...');
        isLoading=false;
      }else if (profileData.toString().contains('Error')){
        toastShow('$profileData...');
        isLoading=false;
      }else{
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
        isLoading=false;
      }
    });
   /* if (profileData == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    }
    else {
      await db.execute('DELETE  FROM  profile');

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

      Map<String, Object?> map = {
        'data': jsonEncode(profileData),
      };
      await db.insert('profile', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }*/
  }

  String imageSet() {
    if (role == 3) {
      return image!;
    } else
      return photo;
  }

  bool isLoading = false;
  Future<void> updateApp() async {
    setState(() {
      isLoading=true;
    });
    Map map = {
      'fcm_token': SharedPref.getUserFcmToken(),
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
        isLoading=false;
      });

      results['status'] == 200
          ? snackShow(context, 'Sync Successfully')
          : snackShow(context, 'Sync Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Profile'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      /*drawer: Drawers(logout:  () async {
        // on signout remove all local db and shared preferences
        Navigator.pop(context);
        setState(() {
          isLoading=true;
        });
        HttpRequest request = HttpRequest();
        var res =
        await request.postSignOut(context, token!);
        *//* await db.execute('DELETE FROM daily_diary ');
        await db.execute('DELETE FROM profile ');
        await db.execute('DELETE FROM test_marks ');
        await db.execute('DELETE FROM subjects ');
        await db.execute('DELETE FROM monthly_exam_report ');
        await db.execute('DELETE FROM time_table ');
        await db.execute('DELETE FROM attendance ');*//*
        Navigator.pushReplacementNamed(context, '/');
        setState(() {
          if (res['status'] == 200) {
            SharedPref.removeData();
            snackShow(context, 'Logout Successfully');
            isLoading=false;
          } else {
            isLoading=false;
            snackShow(context, 'Logout Failed');
          }
        });

      }, sync: () async {
        Navigator.pop(context);
        await updateApp();
        Phoenix.rebirth(context);
      },),*/
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
                      result: gName!='-'?'$class_name - $gName ( $gTitle )':'$class_name',
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
