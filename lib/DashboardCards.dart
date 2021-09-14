import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';

class DashboardCards extends StatefulWidget {
  final String text;
  final images;
  final onClicks;

  DashboardCards({
    required this.text,
    required this.images,
    required this.onClicks,
  });

  @override
  _DashboardCardsState createState() => _DashboardCardsState();
}

class _DashboardCardsState extends State<DashboardCards> {
  late var newColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(()async{
      return await getSchoolInfo();
    });
    newColor = getSchoolColor();
  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onClicks,
          child: Card(
            elevation: 4.0,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(),
            child: widget.images,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.0),
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Color(int.parse('$newColor')),
            ),
          ),
        ),
      ],
    );
  }
}
