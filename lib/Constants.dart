import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

var _newColor, newString,newColors=SharedPref.getSchoolColor();

Future getSchoolInfo(context) async {
  var token = SharedPref.getUserToken();
  HttpRequest request = HttpRequest();
  var result = await request.getLogoColor(context, token!);

  await SharedPref.setSchoolLogo(result['logo']);
  await SharedPref.setSchoolName(result['school_name']);
  await SharedPref.setBranchName(result['branch_name']);
  var colors = result['accent'];
  newString = colors!.substring(colors.length - 6);
}

Future getSchoolColor() async {
  if (newString == null) {
    _newColor = '0xff15728a';
    await SharedPref.setSchoolColor(_newColor);
  } else {
    _newColor = '0xff$newString';
    await SharedPref.setSchoolColor(_newColor);
  }

}

var kTableStyle = TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontWeight: FontWeight.bold);

var kExpandStyle =
    TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

var kCalendarStyle = CalendarHeaderStyle(
  textAlign: TextAlign.center,
  backgroundColor: Color(int.parse('$newColors')),
  textStyle: TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.normal,
      letterSpacing: 3,
      color: Color(0xFFff5eaea),
      fontWeight: FontWeight.w500),
);

var kCalMonthSetting = MonthViewSettings(
    appointmentDisplayCount: 1,
    showTrailingAndLeadingDates: false,
    dayFormat: 'EEE',
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment);

toastShow(text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(int.parse('$newColors')),
      textColor: Colors.white,
      fontSize: 12.0);
}

snackShow(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.orangeAccent,
      duration: const Duration(milliseconds: 3000), // default 4s
      content: Text(
        '$text',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
    ),
  );
}

var spinkit = SpinKitCircle(
  color: Color(int.parse('$newColors')),
  size: 50.0,
);

statusColor(newColor) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(int.parse('$newColor')),
    ),
  );
}

var kBoxDecorateStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(4.0),
  border: Border.all(
    color: Color(int.parse('$newColors')),
  ),
);

var kBoxConstraints = BoxConstraints(maxWidth: double.infinity, minWidth: 150);
var kBoxesConstraints =
    BoxConstraints(maxWidth: double.infinity, minWidth: 360);

var kMargin = EdgeInsets.symmetric(horizontal: 16.0);
var kMargins = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
var kAttendPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0);
var kAttendsPadding = EdgeInsets.symmetric(horizontal: 128.0, vertical: 16.0);
var kTextStyle = TextStyle(
  color: Color(int.parse('$newColors')),
  fontWeight: FontWeight.bold,
);
var kElevateStyle = ElevatedButton.styleFrom(
  primary: Color(int.parse('$newColors')),
);
var kButtonStyle = ElevatedButton.styleFrom(
  primary: Color(int.parse('$newColors')),
  fixedSize: Size.fromHeight(50.0),
);
var kTextsFieldStyle = InputDecoration(
  hintText: 'Enter your complaints here...',
  hintStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(width: 1.0),
  ),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(int.parse('$newColors'))),
  ),
);

var kTextFieldStyle = InputDecoration(
  hintText: 'Enter your leave reason here...',
  hintStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(width: 1.0),
  ),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(int.parse('$newColors'))),
  ),
);

kTStyle(String colors) {
  TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Color(int.parse('$colors')),
  );
}

var roundBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(25)));

IconButton iconButtons({required IconData icons, required final onPress}) {
  return IconButton(
    icon: Icon(
      icons,
      color: Colors.white,
      size: 20.0,
    ),
    onPressed: onPress,
  );
}

Container titleIcon(final setLogo) {
  return Container(
    child: CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: setLogo,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: 20,
        backgroundImage: imageProvider,
      ),
    ),
  );
}

Text texts({required String title}) {
  return Text(
    '$title',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
  );
}

SfRadialGauge sfRadialGauges(String index) {
  return SfRadialGauge(axes: <RadialAxis>[
    RadialAxis(
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        startAngle: 270,
        endAngle: 270,
        radiusFactor: 0.8,
        axisLineStyle: AxisLineStyle(
          thickness: 1,
          color: Colors.orange,
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
            value: double.parse(' $index'),
            width: 0.15,
            enableAnimation: true,
            animationDuration: 700,
            color: Colors.white,
            pointerOffset: 0.1,
            cornerStyle: CornerStyle.bothCurve,
            animationType: AnimationType.linear,
            sizeUnit: GaugeSizeUnit.factor,
          )
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            positionFactor: 0.5,
            widget: Text(
              '${double.parse(index).toInt()}%',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
  ]);
}

Padding resultTitles(
    {required String title,
    required IconData icons,
    required String index,
    required Color colors}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(
          icons,
          size: 20.0,
          color: colors,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            '$title',
            style: TextStyle(
              fontSize: 18.0,
              color: colors,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              ' $index',
              style: TextStyle(
                color: colors,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Text textData({
  required String index,
  required TextAlign txtAlign,
  required Color colors,
  required double fSize,
  required FontWeight fWeight,
}) {
  return Text(
    '$index',
    textAlign: txtAlign,
    style: TextStyle(
      color: colors,
      fontSize: fSize,
      fontWeight: fWeight,
    ),
  );
}
