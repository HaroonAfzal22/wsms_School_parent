import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'NavigationDrawer.dart';
import 'ProfileDetails.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = '';
  var address = '';
  var class_name = '';
  var section_name = '';
  var father_number = '';
  var rollNo = '';
  late var photo;
  var image = SharedPref.getUserAvatar();
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  var role = SharedPref.getRoleId();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getData();
  }

  getData() async {
    HttpRequest request = HttpRequest();
    var profileData = await request.getProfile(context, token!, tok!);
    setState(() {
      name = profileData['name'].toString();
      var add = profileData['address'];
      add != null ? address = add : address = 'No Address Given';
      var pic = profileData['avatar'];
      pic != null ? photo = pic : photo = 'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg';
      var num = profileData['roll_no'];
      num != null ? rollNo = num : rollNo = 'No Roll Number';
      class_name = profileData['class_name'].toString();
      section_name = profileData['section_name'].toString();
      father_number = profileData['father_phone'].toString();
      isLoading = false;
    });
  }

  String imageSet() {
    if (role == 3) {
      return image!;
    } else
      return photo!;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff18728a),
        title: Text('Profile'),
        brightness: Brightness.dark,
      ),
      drawer: Drawers(
        complaint: null,
        aboutUs: null,
        PTM: null,
        dashboards: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
        Leave: null,
        onPress: () {
          setState(() {
            SharedPref.removeData();
            Navigator.pushReplacementNamed(context, '/');
            Fluttertoast.showToast(
                msg: "Logout Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xff18726a),
                textColor: Colors.white,
                fontSize: 12.0);
          });
        },
      ),
      body: isLoading
          ? Center(
              child: spinkit,
            )
          : BackgroundWidget(
              childView: ListView(
                children: [
                  Container(
                    color: Color(0xff18728a),
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
                              child: Text(
                                'Roll Number:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
                              child: Text(
                                '$rollNo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ProfileDetails(
                    result: '$class_name',
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
    );
  }
}
