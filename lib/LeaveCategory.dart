import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wsms/LeaveAppList.dart';
import 'package:wsms/LeaveApply.dart';
import 'package:wsms/Shared_Pref.dart';

class LeaveCategory extends StatefulWidget {
  @override
  _LeaveCategoryState createState() => _LeaveCategoryState();
}

// for set leave category
class _LeaveCategoryState extends State<LeaveCategory> {
   var newColor=SharedPref.getSchoolColor();
   var token = SharedPref.getUserToken();
   bool isLoading=false;

   int  _page=0;
   GlobalKey<CurvedNavigationBarState> _bottomLeaveKey =GlobalKey();
final leaveScreens =[
  LeaveApply(),
  LeaveApplyList(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(int.parse('$newColor')),
        backgroundColor: Colors.transparent,
        key: _bottomLeaveKey,
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
      body: leaveScreens[_page],
    );
  }
   @override
   void dispose() {
     _page = 0;
     super.dispose();
   }
}
