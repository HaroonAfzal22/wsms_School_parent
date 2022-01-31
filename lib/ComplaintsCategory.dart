import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wsms/ComplaintsApply.dart';
import 'package:wsms/ComplaintsList.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Shared_Pref.dart';

class ComplaintsCategory extends StatefulWidget {
  @override
  _ComplaintsCategoryState createState() => _ComplaintsCategoryState();
}

//for shown category is want to apply or check list of complaints

class _ComplaintsCategoryState extends State<ComplaintsCategory> {
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false;
  int _page=0;
  GlobalKey<CurvedNavigationBarState> bottomsKey = GlobalKey();

  final complainScreens=[
  ComplaintsApply(),
  ComplaintsList(),
];
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: spinkit)
        : Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(int.parse('$newColor')),
        backgroundColor: Colors.transparent,
        key: bottomsKey,
        height: 50,
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_rounded, color: Colors.white, size: 30,),
              Visibility(
                visible:_page==0?false:true ,
                child: Text('Apply', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list, color: Colors.white, size: 30),
              Visibility(visible:_page==0?true:false, child: Text('Apply List', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),)),
            ],
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      extendBody: true,
      body: complainScreens[_page],
    );
  }
  @override
  void dispose() {
    _page = 0;
    super.dispose();
  }
}
