import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final onChangedValue;
  final String title;
  final IconData? iconValue;
  final TextInputType keyType;
  final bool visibility;
  final TextEditingController control;
  TextFields(
      {required this.onChangedValue,
      required this.title,
        required this.visibility,
        required this.keyType,
       this.iconValue,
      required this.control,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: TextField(
        obscureText:visibility,
        keyboardType: keyType,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Color(0xff18728a),
        ),
        decoration: InputDecoration(
            suffixIcon: Icon(
              iconValue,
              color: Color(0xff18728a),
            ),
            hintText: title,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.grey.shade600)),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff18728a)),
          ),
        ),
        onChanged: onChangedValue,
        controller:  control,
      ),
    );
  }
}
