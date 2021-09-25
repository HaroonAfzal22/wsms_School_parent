import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';

class ProfileDetails extends StatefulWidget {
 late final String title;
 late final String result;


 ProfileDetails({required this.title,required this.result});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late var newColor='0xffffffff';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setColor();
  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:EdgeInsets.only(top: 10.0,left: 12.0),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Color(int.parse('$newColor')),
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            margin:EdgeInsets.only(top: 10.0,left: 12.0,bottom: 10.0),
            child: Padding(
              padding:  EdgeInsets.only(left: 50.0),
              child: Text(
                widget.result,
                style: TextStyle(
                  fontSize: 14.0,
                ),

              ),
            ),
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 16,
            endIndent: 40,
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
