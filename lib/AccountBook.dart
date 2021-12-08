import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class AccountBook extends StatefulWidget {
  @override
  _AccountBookState createState() => _AccountBookState();
}

class _AccountBookState extends State<AccountBook> {
  var newColor = SharedPref.getSchoolColor();
  var sId = SharedPref.getStudentId();
  bool isLoading = false;
  var token = SharedPref.getUserToken();
  late var db, data = [];

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

  List<bool> _isOpen = List<bool>.filled(50, false);

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getFeeModule();
  }

  getFeeModule() async {
    HttpRequest request = HttpRequest();
    List value = await request.getFeeChallan(context, token!, sId!);
    setState(() {
      value.isNotEmpty ? data = value : toastShow('Data Not Found');
      isLoading = false;
    });
  }

  List<DataRow> dataRow(i) {
    List<DataRow> rows = [];
    for (int j = 0; j < data[i]['details'].length; j++) {
      var value = DataRow(cells: <DataCell>[
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              '${data[i]['details'][j]['fee_name']}',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        DataCell(Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Text('Rs: ${data[i]['details'][j]['amount'].toString()}/-'),
        )),
      ]);
      rows.add(value);
    }
    return rows;
  }

  List<ExpansionPanel> rowTables() {
    List<ExpansionPanel> rows = [];
    for (int i = 0; i < data.length; i++) {
      var value = ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      '${data[i]['voucher_serial']}',
                      style: kExpandStyle,
                    ),
                  ),
                  Center(
                    child: Text('Rs: ${data[i]['total_voucher_amount']}/-',
                        style: kExpandStyle),
                  ),
                  Center(
                    child: Text(
                        '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[i]['due_date']))}',
                        style: kExpandStyle),
                  ),
                  Center(
                    child: Text(
                        '${data[i]['payment_status'] == 0 ? "Pending" : "Paid"}',
                        style: data[i]['payment_status'] == 0
                            ? kStatusStyle(Colors.redAccent)
                            : kStatusStyle(Colors.green)),
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.print,
                        size: 16.0,
                        color: Color(int.parse('$newColor')),
                      ),
                    ),
                    onTap: () {
                      print(' click ! $i');
                    },
                  )
                ],
              ),
            ],
          );
        },
        body: DataTable(
          horizontalMargin: 16.0,
          headingRowColor:
              MaterialStateProperty.all(Color(int.parse('$newColor'))),
          headingRowHeight: 30.0,
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'Fee Category',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: dataRow(i),
        ),
        isExpanded: _isOpen[i],
        canTapOnHeader: true,
      );
      rows.add(value);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text('Fee Module'),
      ),
      drawer: Drawers(
        logout: () async {
          // on signout remove all local db and shared preferences
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          HttpRequest request = HttpRequest();
          var res = await request.postSignOut(context, token!);
          await db.execute('DELETE FROM daily_diary ');
          await db.execute('DELETE FROM profile ');
          await db.execute('DELETE FROM test_marks ');
          await db.execute('DELETE FROM subjects ');
          await db.execute('DELETE FROM monthly_exam_report ');
          await db.execute('DELETE FROM time_table ');
          await db.execute('DELETE FROM attendance ');
          Navigator.pushReplacementNamed(context, '/');
          setState(() {
            if (res['status'] == 200) {
              SharedPref.removeData();
              snackShow(context, 'Logout Successfully');
              isLoading = false;
            } else {
              isLoading = false;
              snackShow(context, 'Logout Failed');
            }
          });
        },
        sync: () async {
          Navigator.pop(context);
          await updateApp();
          Phoenix.rebirth(context);
        },
      ),
      body: SafeArea(
        child: BackgroundWidget(
          childView: ListView(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              color: Color(int.parse('$newColor')),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text('Challan#', style: kTableStyle),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'Amount',
                          style: kTableStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'Due Date',
                          style: kTableStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'Status',
                          style: kTableStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'Print',
                          style: kTableStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'Expand',
                          style: kTableStyle,
                        ),
                      ),
                    ),
                  ]),
            ),
            ExpansionPanelList(
              children: rowTables(),
              expansionCallback: (indx, isOpen) =>
                  setState(() => _isOpen[indx] = !isOpen),
            ),
          ]),
        ),
      ),
    );
  }
}
