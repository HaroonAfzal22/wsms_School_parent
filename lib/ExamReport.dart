import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class ExamReport extends StatefulWidget {
  @override
  _ExamReportState createState() => _ExamReportState();
}

class _ExamReportState extends State<ExamReport> {
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false, isListEmpty = false;
  var token = SharedPref.getUserToken();
  var schoolId = SharedPref.getSchoolId();
  var sId = SharedPref.getStudentId();
  late var db, tId, data = [], term = [];
  late Map myValue = Map();

  Future<void> updateApp() async {
    setState(() {
      isLoading = true;
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
        isLoading = false;
      });

      results['status'] == 200
          ? snackShow(context, 'Sync Successfully')
          : snackShow(context, 'Sync Failed');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    isLoading = true;
    getExamTerm();
  }

  Future<void> getExamTerm() async {
    HttpRequest request = HttpRequest();
    List value = await request.getExamTerm(context, token!);
    setState(() {
      term = value;
      Map map = {"id": "0", 'term': 'Select Term'};
      term.insert(0, map);
      tId = value[0]['id'];
      isLoading = false;
    });
  }

  Future<void> getExamReport() async {
    HttpRequest request = HttpRequest();
    var value = await request.getExamReport(context, token!, sId!, '$tId');
    setState(() {
      value != null ? isListEmpty = false : isListEmpty = true;
      value != null
          ? data = value['student_marks']
          : toastShow('Data is Empty');
      myValue = value;
      isLoading = false;
    });
  }

  List<DataRow> dataRow() {
    List<DataRow> rows = [];
    for (int j = 0; j < data.length; j++) {
      var value = DataRow(cells: <DataCell>[
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width / 4,
            child: Text(
              '${data[j]['subject_name']}',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        DataCell(Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            ' ${data[j]['total_marks'].toString()=='null'?'-':data[j]['total_marks']}',
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            '${data[j]['marks'].toString()=='null'?'-':data[j]['marks']}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: data[j]['marks'].toString() == 'A'
                  ? Colors.red
                  : data[j]['marks'].toString() == 'N/M'
                      ? Colors.blue
                      : Colors.black,
            ),
          ),
        )),
        DataCell(Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            '${data[j]['subject_percentage'].toString()=='null'?'-':data[j]['subject_percentage']}%',
            textAlign: TextAlign.center,
          ),
        )),
      ]);
      rows.add(value);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: schoolId=='15'?true: false,
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text('Exams Result',
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: spinkit)
            : BackgroundWidget(
                childView: RefreshIndicator(
                  onRefresh: getExamReport,
                  child: ListView(
                      children: [
                    dropDownWidget('$tId', getDropDownListItem(term, 'term'),
                        (value) {
                      setState(() {
                        tId = int.parse(value!);
                        getExamReport();
                        isLoading = true;
                      });
                    }, '$newColor'),
                    Visibility(
                      visible: myValue.isNotEmpty?true:false,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/22),
                                  child: FinalResult(
                                    value: 'Name: ${myValue['name'].toString()}',
                                    newColor: '$newColor',
                                  ),
                                ),
                                Expanded(child: Container()),
                                Padding(
                                  padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width/22),
                                  child: FinalResult(
                                    value: 'Roll No: ${myValue['roll_no'].toString()}',
                                    newColor: '$newColor',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: schoolId=='15'?false:true,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                child: Text(
                                  'N/M = Not Marked  |  A = Absent',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(
                                      int.parse('$newColor'),
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: isListEmpty
                                ? Container(
                                    color: Colors.transparent,
                                    child: Lottie.asset('assets/no_data.json',
                                        repeat: true, reverse: true, animate: true),
                                  )
                                : Container(
                                  padding:  EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/22),
                                  child: DataTable(
                                      columnSpacing: 6.0,
                                      horizontalMargin: 12.0,
                                      showBottomBorder: true,
                                      headingRowColor: MaterialStateProperty.all(
                                          Color(int.parse('$newColor'))),
                                      headingRowHeight: 50.0,
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Container(
                                            width:
                                                MediaQuery.of(context).size.width / 5,
                                            child: Text(
                                              'Subject',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width:
                                                MediaQuery.of(context).size.width / 5,
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width:
                                                MediaQuery.of(context).size.width / 5,
                                            child: Text(
                                              'Obtained',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            width:
                                            MediaQuery.of(context).size.width / 5,
                                            child: Text(
                                              '%age',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: dataRow(),
                                    ),
                                ),
                          ),
                          Card(
                            color:  Color(int.parse('$newColor')),
                            margin: EdgeInsets.only(top: 12.0,right: 12.0,left: 12.0),
                            child: Column(
                              children: [
                                FinalResults(
                                    text1:
                                        'Marks: ${myValue['total_obtained'].toString()}/${myValue['total_marks'].toString()}',
                                    text2:
                                        'Percentage: ${myValue['percentage'].toString()}%',
                                    newColor: newColor),
                                FinalResults(
                                    text1: 'Position: ${myValue['position'].toString()=='null'?'-':myValue['position']}',
                                    text2: 'Grade: ${myValue['grade'].toString()==''?'-':myValue['grade']}',
                                    newColor: newColor),
                                Container(
                                  child: FinalResults(
                                      text1: 'P.Sign:',
                                      icon: 'assets/sign.jpeg',
                                      text2: 'Remarks: ${myValue['remarks'].toString()==''?'-':myValue['remarks']}',
                                      newColor: newColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}

class FinalResults extends StatelessWidget {
  const FinalResults({
    Key? key,
    required this.newColor,
    required this.text1,
    required this.text2,
    this.icon,
  }) : super(key: key);

  final String? newColor, text1, text2,icon;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 25.0,
      columnSpacing: 4.0,
      headingTextStyle: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        color:Colors.white,
      ),
      columns: <DataColumn>[
        DataColumn(
          label: Container(
            decoration:  BoxDecoration(
              image:DecorationImage(
                image: AssetImage('$icon'),
                colorFilter: ColorFilter.mode( Color(int.parse('$newColor')), BlendMode.hardLight),
              ),
            ),
            width: MediaQuery.of(context).size.width / 2.5,
            child: Text(
              '$text1',
              textAlign: TextAlign.start,
            ),
          ),
        ),
        DataColumn(
          label: Container(padding: EdgeInsets.only(right: 4.0),

            width: MediaQuery.of(context).size.width / 2.2,
            child: Text(
              '$text2',
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
      // rows: dataRow(),
      rows: [],
    );
  }
}

class FinalResult extends StatelessWidget {
  final String? value, newColor;

  const FinalResult({
    Key? key,
    required this.value,
    required this.newColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      '$value',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Color(
          int.parse('$newColor'),
        ),
      ),
      textAlign: TextAlign.start,
    ));
  }
}
