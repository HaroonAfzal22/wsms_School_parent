import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class AccountBook extends StatefulWidget {
  @override
  _AccountBookState createState() => _AccountBookState();
}

class _AccountBookState extends State<AccountBook> {
   var newColor='0xff15728a';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   setColor();

    print('account $newColor');
  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      statusColor(newColor);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        brightness: Brightness.dark,
        title: Text('Accounts Book'),
      ),
      body: AccountDetails(),
      drawer: Drawers(
        complaint: null,
        aboutUs: () {
          Navigator.pop(context);
         // Navigator.pushNamed(context, '/list_attendance');
        },
        PTM: null,
        dashboards: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
        Leave: null,
        onPress: () {
          setState(() {
            SharedPref.removeData();
            Navigator.pushReplacementNamed(context, '/');
            toastShow("Logout Successfully");
          });
        },
      ),
    );
  }
}

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  List<bool> _isOpen = List<bool>.filled(50, false);
  var newColor=getSchoolColor();
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
    setState(() {
      statusColor(newColor);
    });
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
