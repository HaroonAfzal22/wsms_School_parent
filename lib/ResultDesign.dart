import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ResultDesign extends StatelessWidget {
  final onClick, titleText;

  ResultDesign(
      {required this.onClick,
        required this.titleText,
        });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),

        height:100,
        child: Card(
          color: Color(0xff15728a),
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
                titleText,
                style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),
              ),

            ),
          ),
        ),
      ),
    );
  }
}
