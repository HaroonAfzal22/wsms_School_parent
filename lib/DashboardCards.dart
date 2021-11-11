import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Shared_Pref.dart';

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
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
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

class DashboardViews extends StatefulWidget {
  final url1, url2, title1, title2, onPress1, onPress2;

  const DashboardViews(
      {Key? key,
      required this.url1,
      required this.url2,
      required this.title1,
      required this.title2,
      required this.onPress1,
      required this.onPress2})
      : super(key: key);

  @override
  State<DashboardViews> createState() => _DashboardViewsState();
}

class _DashboardViewsState extends State<DashboardViews> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DashboardCards(
              images: CachedNetworkImage(
                key: UniqueKey(),
                imageUrl: widget.url1,
                width: 100,
                height: 100,
                fit: BoxFit.fill,

              ),
              text: widget.title1,
              onClicks: widget.onPress1),
          DashboardCards(
            images: CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: widget.url2,
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
            text: widget.title2,
            onClicks: widget.onPress2,
          ),
        ],
      ),
    );
  }
}
