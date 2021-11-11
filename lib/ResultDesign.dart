import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Shared_Pref.dart';

class ResultDesign extends StatefulWidget {
  final onClick, titleText;

  ResultDesign({
    required this.onClick,
    required this.titleText,
  });

  @override
  _ResultDesignState createState() => _ResultDesignState();
}

class _ResultDesignState extends State<ResultDesign> {
   var newColor=SharedPref.getSchoolColor();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        height: 100,
        child: Card(
          color: Color(int.parse('$newColor')),
          child: Center(
            child: ListTile(
              leading: Card(
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  key: UniqueKey(),
                  imageUrl:
                      'https://media.istockphoto.com/vectors/businessman-hands-holding-clipboard-checklist-with-pen-checklist-vector-id935058724?s=612x612',
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                widget.titleText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
