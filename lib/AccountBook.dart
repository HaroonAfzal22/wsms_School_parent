import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
   var newColor= SharedPref.getSchoolColor();
   bool isLoading=false;
   var token = SharedPref.getUserToken();
    late var db;
   Future<void> updateApp() async {
     setState(() {
       isLoading=true;
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
         isLoading=false;
       });

       results['status'] == 200
           ? snackShow(context, 'Sync Successfully')
           : snackShow(context, 'Sync Failed');
     }
   }

   @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text('Accounts Book'),
      ),
      body: AccountDetails(),
      drawer: Drawers(
          logout:  () async {
        // on signout remove all local db and shared preferences
            Navigator.pop(context);

            setState(() {
          isLoading=true;
        });
        HttpRequest request = HttpRequest();
        var res =
        await request.postSignOut(context, token!);
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
            isLoading=false;
          } else {
            isLoading=false;
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
    );
  }
}



class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

// still pending due to not working
class _AccountDetailsState extends State<AccountDetails> {
  List<bool> _isOpen = List<bool>.filled(50, false);
  var newColor=SharedPref.getSchoolColor();

  List<ExpansionPanel> rowTables() {
    List<ExpansionPanel> rows = [];
    for (int i = 0; i < 50; i++) {
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
                      'Challan#',
                      style:kExpandStyle,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Amount',
                      style: kExpandStyle),
                  ),
                  Center(
                    child: Text(
                      'Due Date',
                      style: kExpandStyle ),
                  ),
                  Center(
                    child: Text(
                      'Status',
                      style: kExpandStyle ),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available',
            style: TextStyle(),
            textAlign: TextAlign.justify,
          ),
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

    return SafeArea(
      child: BackgroundWidget(
        childView: ListView(
            children: [
              Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            color: Color(int.parse('$newColor')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Challan#',
                    style: kTableStyle
                  ),
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
                padding:EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Status',
                    style: kTableStyle,
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Print',
                    style: kTableStyle,
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}
