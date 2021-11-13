import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/image_render.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class AttendanceHtml extends StatefulWidget {
  const AttendanceHtml({Key? key}) : super(key: key);

  @override
  _AttendanceHtmlState createState() => _AttendanceHtmlState();
}

class _AttendanceHtmlState extends State<AttendanceHtml> {
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  var textId,
      sectId,
      format = 'select date';
  late var result = 'waiting...',
      newColor= SharedPref.getSchoolColor();
  List classValue = [],
      sectionValue = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    monthReport();
  }

  monthReport() async {
    HttpRequest req = HttpRequest();
    var html =
    await req.studentAttendance(context, token!, sId.toString());
    if (html == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        if (html != null) {
          result = html.toString();
          isLoading = false;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        var dateString = picked;
        format = Jiffy(dateString).format("dd-MMM-yyyy");
        selectedDate = picked;
      });
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      statusColor(newColor);
    });
    return WillPopScope(
      onWillPop: _onPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Attendance'),
          backgroundColor: Color(int.parse('$newColor')),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer:  Drawers(),
        body: isLoading
            ? Center(
          child: spinkit,
        )
            : SafeArea(
          child: Html(
            data: result,
            style: {
              "table": Style(
                  backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  width: double.minPositive),
              "tr": Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              "th": Style(
                color: Colors.white,
                alignment: Alignment.center,
                textAlign: TextAlign.center,
                padding: EdgeInsets.all(6),
                backgroundColor: Color(int.parse('$newColor')),
              ),
              "td": Style(
                color: Color(int.parse('$newColor')),
                alignment: Alignment.center,
                textAlign: TextAlign.center,
                padding: EdgeInsets.all(6),
              ),
            },
            customRender: {
              "table": (context, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: (context.tree as TableLayoutElement)
                      .toWidget(context),
                );
              },
            },
            onImageError: (exception, stackTrace) {
              print(exception);
            },
            onCssParseError: (css, messages) {
              print("css that errored: $css");
              print("error messages:");
              messages.forEach((element) {
                print(element);
              });
            },
          ),
        ),
      ),
    );
  }
}
