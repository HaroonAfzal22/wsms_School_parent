import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

import 'NavigationDrawer.dart';

class ComplaintsApply extends StatefulWidget {
  @override
  _ComplaintsApplyState createState() => _ComplaintsApplyState();
}

//for student or parent do complaints it used
class _ComplaintsApplyState extends State<ComplaintsApply> {
   var newColor = SharedPref.getSchoolColor(),
      attachments = 'Attach File',
      attachment = 'Record Audio';
  TextEditingController _controller = TextEditingController();
  TextEditingController _controls = TextEditingController();
  String? reasonValue, titleValue;
  bool isLoading = false,isClick=false;
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
   File? imageFile;
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
        title: Text(
          'Complaints Apply',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: spinkit)
            : BackgroundWidget(
                childView: ListView(
                  children: [
                    /*   Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            constraints: kBoxConstraints,
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child: Padding(
                              padding: kAttendPadding,
                              child: Text(
                                '$format',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            child: Container(
                              child: IconButton(
                                onPressed: () => _fromDate(context),
                                icon: Icon(
                                  CupertinoIcons.calendar,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            constraints: kBoxConstraints,
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child: Padding(
                              padding: kAttendPadding,
                              child: Text(
                                '$formats',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            child: Container(
                              child: IconButton(
                                onPressed: () => _toDate(context),
                                icon: Icon(
                                  CupertinoIcons.calendar,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
                    Container(
                      margin: kMargins,
                      child: Text(
                        'Title:',
                        style: TextStyle(
                            color: Color(
                              int.parse('$newColor'),
                            ),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 100,
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(int.parse('$newColor')),
                          ),
                          maxLines: null,
                          maxLength: null,
                          decoration: kTextsFieldStyle,
                          controller: _controls,
                          onChanged: (value) {
                            titleValue = value;
                          }),
                    ),
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: double.infinity,
                                minWidth: MediaQuery.of(context).size.width),
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child: Padding(
                              padding: kAttendsPadding,
                              child: Text(
                                '$attachments',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 60,
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  _showChoiceDialog(context,newColor);
                                },
                                icon: Icon(
                                  CupertinoIcons.camera_fill,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: double.infinity,
                                minWidth: MediaQuery.of(context).size.width),
                            decoration: kBoxDecorateStyle,
                            margin: kMargin,
                            child:isClick? TweenAnimationBuilder<Duration>(
                                duration: Duration(seconds: 30),
                                tween:
                                Tween(begin: Duration(seconds: 30), end: Duration.zero),
                                onEnd: () async{
                                  await Record().stop();
                                  setState(() {
                                    isClick=false;
                                    attachment='audio.3gp';
                                  });
                                  print('Timer ended');
                                },
                                builder:
                                    (BuildContext context, Duration value, Widget? child) {
                                  final minutes = value.inMinutes;
                                  final seconds = value.inSeconds % 60;
                                  return Padding(
                                      padding: kAttendsPadding,
                                      child: Text('$minutes:$seconds',
                                          textAlign: TextAlign.start,
                                          style: kTextStyle));
                                }):Padding(
                              padding: kAttendsPadding,
                              child: Text(
                                '$attachment',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width - 60,
                            child: Container(
                              child: IconButton(
                                onPressed: ()async {
                                  bool _permit = await Record().hasPermission();
                                  Directory? dir = await getExternalStorageDirectory();
                                        if(_permit) {
                                          setState(() {
                                            if(isClick){
                                              isClick=false;
                                              attachment='audio.3gp';

                                            }else{
                                              isClick=true;
                                            }
                                          });
                                          if (isClick) {
                                            await Record().start(
                                              path: '${dir!.path}/myFile.3GP',
                                              // required
                                              encoder: AudioEncoder.AMR_WB,
                                              // by default
                                              bitRate: 128000,
                                              // by default
                                              samplingRate: 44100, // by default
                                            );
                                          } else {
                                            await Record().stop();
                                          }
                                        }else{
                                          await Permission.microphone.request();
                                          await Permission.storage.request();
                                          await Permission.manageExternalStorage.request();
                                        }
                                },
                                icon: Icon(isClick?CupertinoIcons.pause_fill:CupertinoIcons.play_arrow_solid,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: kMargins,
                      child: Text(
                        'Reason:',
                        style: TextStyle(
                            color: Color(
                              int.parse('$newColor'),
                            ),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: TextField(
                          keyboardType: TextInputType.text,
                          style: kTStyle('$newColor'),
                          maxLines: null,
                          maxLength: null,
                          decoration: kTextsFieldStyle,
                          controller: _controller,
                          onChanged: (value) {
                            reasonValue = value;
                          }),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ElevatedButton(
                        style: kElevateStyle,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          uploadData();
                        },
                        child: Text('Upload Data'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //post data to api where sent title of complaint and reason
  void uploadData() async {
    HttpRequest request = HttpRequest();
    Map bodyMap = {
      'title': titleValue,
      'description': reasonValue,
    };
    var response = await request.postComplaintData(context, token!, sId!, bodyMap);
    setState(() {
      if(response==null ||response.isEmpty){
        toastShow('Data Upload Failed...');
        isLoading=false;
      }else if (response.toString().contains('Error')){
        toastShow('$response...');
        isLoading=false;
      }else{
        toastShow('Data Upload Successfully...');
        isLoading=false;
      }
    });
   }


   Future<void>_showChoiceDialog(BuildContext context,newColor) {
     return showDialog(context: context,builder: (BuildContext context){
       return AlertDialog(
         title: Text("Choose option",style: TextStyle(color:Color(int.parse('$newColor'))),),
         content: SingleChildScrollView(
           child: ListBody(
             children: [
               ListTile(
                 onTap: (){
                   _openGallery(context);
                 },
                 title: Text("Gallery"),
                 leading: Icon(Icons.account_box,color: Color(int.parse('$newColor')),),
               ),

               Divider(height: 1,color:Color(int.parse('$newColor'))),
               ListTile(
                 onTap: (){
                   _openCamera(context);
                 },
                 title: Text("Camera"),
                 leading: Icon(Icons.camera,color:Color(int.parse('$newColor'))),
               ),
             ],
           ),
         ),);
     });
   }
   void _openGallery(BuildContext context) async{
     Navigator.pop(context);
     final pickedFile = await ImagePicker().pickImage(
       source: ImageSource.gallery ,
     );
     setState(() {
       imageFile = File(pickedFile!.path);
       attachments='picture.jpg';
     });
     print('image at file $imageFile');

   }

   void _openCamera(BuildContext context)  async{
     Navigator.pop(context);

     final pickedFile = await ImagePicker().pickImage(
       source: ImageSource.camera ,
     );
     setState(() {
       imageFile = File(pickedFile!.path);
       attachments='picture.jpg';
     });
     print('image file $imageFile');
   }


}
