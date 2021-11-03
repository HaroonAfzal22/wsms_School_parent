import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class DailyDiary extends StatefulWidget {
  const DailyDiary({Key? key}) : super(key: key);

  @override
  _DailyDiaryState createState() => _DailyDiaryState();
}

class _DailyDiaryState extends State<DailyDiary> {
  DateTime selectedDate = DateTime.now();
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late var result, newColor="0xffffffff";
  bool isLoading = false;
  var colors = SharedPref.getSchoolColor();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    setColor();
    getStudentDiary(token!);
  }

  setColor() async {
    var color = await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }

  void getStudentDiary(String token) async {
    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentDailyDiary(context, token, sId!);
    setState(() {
      var document = parse('$classes');
      classes.isNotEmpty ? result = document : toastShow('No Homework Found');
      isLoading = false;
    });
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onPopScope,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(int.parse('$newColor')),
            title: Text('Daily Diary'),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          drawer: Drawers(
            complaint: null,
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
            aboutUs: null,
          ),
          body: isLoading
              ? Center(
                  child: spinkit,
                )
              : SafeArea(
                  child: BackgroundWidget(
                    childView: HtmlWidget(
                      '${result.outerHtml}',
                      customStylesBuilder: (element) {
                        if (element.id==('homework-table')) {
                          return {
                            'color': '$colors',
                            'text-align': 'center',
                            'font-weight': 'bold',
                            'font-size': '16px',
                            'padding': '12px',
                            'align': 'center'
                          };
                        }
                        if (element.localName == 'th') {
                          return {
                            'color': '#ffffff',
                            'font-weight': 'bold',
                            'background-color': '$colors',
                            'font-size': '20px',
                            'text-align': 'center',
                            'padding': '8px',
                            'valign': 'center',
                            'Sizing': '${MediaQuery.of(context).size.width}px'
                          };
                        }
                        if (element.localName == 'td') {
                          return {
                            'color': '#ffffff',
                            'background-color': '$colors',
                            'font-size': '15px',
                            'text-align': 'center',
                            'padding': '8px',
                          };
                        }

                        return null;
                      },
                      /*customWidgetBuilder: (element) {

                      print('table ${element.id=='monthly-tests-table'}');
                      if (element.id == 'monthly-tests-table') {
                        print('ok');
                        return Container();
                      }
                      return null;
                    },*/

                      onErrorBuilder: (context, element, error) =>
                          Text('$element error: $error'),
                      onLoadingBuilder: (context, element, loadingProgress) =>
                          CircularProgressIndicator(),
                      renderMode: RenderMode.listView,
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
        ));
  }
}
