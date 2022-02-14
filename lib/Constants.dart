import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

var _newColor, newString, newColors = SharedPref.getSchoolColor();

// to get school info i.e school name, branch name, logo, color etc... which call after login on dahsboard class
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

// to set color in shared pref then it call this method in dashboard class with getschoolinfo function
Future getSchoolColor() async {
  if (newString == null) {
    _newColor = '0xff15728a';
    await SharedPref.setSchoolColor(_newColor);
  } else {
    _newColor = '0xff$newString';
    await SharedPref.setSchoolColor(_newColor);
  }
}

//for style use account book class
var kTableStyle = TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontWeight: FontWeight.bold);

// for style use account book class
var kExpandStyle = TextStyle(
    fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, fontSize: 12.0);

kStatusStyle(Color colors) {
  return TextStyle(
      color: colors,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 13.0);
}

// for style use in student attendance chart
var kCalendarStyle = TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.normal,
    letterSpacing: 3,
    color: Color(0xFFff5eaea),
    fontWeight: FontWeight.w500);

// for style use in student attendance chart
var kCalMonthSetting = MonthViewSettings(
    appointmentDisplayCount: 1,
    showTrailingAndLeadingDates: false,
    dayFormat: 'EEE',
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment);

// for styling the toast which use multiple places
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

// for styling snackbar make in constant class to use different places
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

// for progress bar use in it
var spinkit = SpinKitSpinningLines(
  color: Color(int.parse('0xff795548')),
  size: 40.0,
);

//for design use in leaveApply and complaintApply class
var kBoxDecorateStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(4.0),
  border: Border.all(
    color: Color(int.parse('$newColors')),
  ),
);
kBoxDecorate(_newColor) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(4.0),
    border: Border.all(
      color: Color(int.parse('$_newColor')),
    ),
    color: Color(int.parse('$_newColor')),
  );
}
var kTestStyle = TextStyle(fontSize: 18.0, color: Colors.white);
var kMargin = EdgeInsets.symmetric(horizontal: 16.0);
var kMargins = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
var kAttendPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0);
var kAttendsPadding = EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0);
var kTextStyle = TextStyle(
    color: Color(int.parse('$newColors')), fontWeight: FontWeight.bold);
var kElevateStyle = ElevatedButton.styleFrom(
  primary: Color(int.parse('$newColors')),
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
    borderSide: BorderSide(color: Color(int.parse('0xff795548'))),
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
    borderSide: BorderSide(color: Color(int.parse('0xff795548'))),
  ),
);
var kTestMargin = EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0);
var kTestPadding = EdgeInsets.symmetric(horizontal: 12.0);
kTStyle(String colors) {
  TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Color(int.parse('$colors')),
  );
}
// for style use in complaint List class

var roundBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(25)));

// for style use in dashboard class

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

Container titleIcon(final setLogo, double d) {
  return Container(
    child: CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: setLogo,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: d,
        backgroundImage: imageProvider,
      ),
    ),
  );
}

// for style use in profile class

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

// for style use in subject class

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

// for style use in subject results
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

//for style use in complaint list
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
Container dropDownWidget(
    String textId, List<DropdownMenuItem<String>> items, onChange, color) {
  return Container(
    decoration: kBoxDecorate(color),
    margin: kTestMargin,
    child: DropdownButtonHideUnderline(
      child: Padding(
        padding: kTestPadding,
        child: DropdownButton<String>(
          value: '$textId',
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.white,
          ),
          items: items,
          dropdownColor: Color(int.parse('$color')),
          onChanged: onChange,
        ),
      ),
    ),
  );
}

kValueStyle(_newColor) {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Color(int.parse('$_newColor')),
  );
}

InputDecoration kInputDecorate(String hintText, _newColor) {
  return InputDecoration(
    hintText: '$hintText',
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
      borderSide: BorderSide(
        color: Color(int.parse('$_newColor')),
      ),
    ),
  );
}

List<DropdownMenuItem<String>> getDropDownListItem(List items, String value) {
  List<DropdownMenuItem<String>> dropDown = [];
  for (int i = 0; i < items.length; i++) {
    var id = items[i]['id'];
    var text = items[i]['$value'];

    var newWidget = DropdownMenuItem(
      child: Text(
        '$text',
        style: kTestStyle,
      ),
      value: '$id',
    );
    dropDown.add(newWidget);
  }
  return dropDown;
}

Container onlineClassTextField(String value, onChange, color,bool isReadable) {
  return Container(
    margin: kMargin,
    child: TextField(
        minLines: null,
        maxLines: null,
        readOnly: isReadable,
        style: kValueStyle(color),
        decoration: kInputDecorate('$value', color),
        onChanged: onChange),
  );
}

String serverResponses(value){
  if(value==400){
    return "$value Error: Invalid Request";
  }else if(value==404){
    return "$value Error: Resource Not Found ";
  }else if(value==408){
    return "$value Error: Request Timeout";
  }else if(value==409){
    return "$value Error: Conflict Issue ";
  }else if(value==401){
    return "$value Error: UnAuthorized Access";
  }else if(value==500){
    return "$value Error: Internal Server Error";
  }else if(value==502){
    return "$value Error: Invalid Response ";
  }else if(value==504){
    return "$value Error: Server Timeout ";
  }else
    return '$value Unknown Error:';

}
