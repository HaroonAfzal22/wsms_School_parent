import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  double progressValue = 35;
  List listSubject = [];
  bool isLoading = false;
  late var newColor='0xffffffff';

  @override
  void initState() {
    super.initState();

    isLoading = true;
    setColor();
    getData();

  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }
  getData() async {
    HttpRequest request = HttpRequest();
    List list = await request.getSubjectsList(context, token!, tok!);
    setState(() {
      listSubject = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Subjects List'),
      ),
      drawer: Drawers(),
      body: SafeArea(
        child: BackgroundWidget(
          childView: Container(
            child: isLoading
                ? Center(
                    child: spinkit
                  )
                : ListView.builder(
                    itemExtent: 70.0,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color(int.parse('$newColor')),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        elevation: 4.0,
                        child: InkWell(
                          child: ListTile(
                            title: Text(
                              '${listSubject[index]['subject_name']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Container(
                              width: 101,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Avg Marks:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: 50,
                                      height: 80,
                                      padding: EdgeInsets.zero,
                                      child: SfRadialGauge(axes: <RadialAxis>[
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
                                                value: double.parse(
                                                    ' ${listSubject[index]['percentage']}'),
                                                width: 0.15,
                                                enableAnimation: true,
                                                animationDuration: 700,
                                                color: Colors.white,
                                                pointerOffset: 0.1,
                                                cornerStyle:
                                                    CornerStyle.bothCurve,
                                                animationType:
                                                    AnimationType.linear,
                                                sizeUnit: GaugeSizeUnit.factor,
                                              )
                                            ],
                                            annotations: <GaugeAnnotation>[
                                              GaugeAnnotation(
                                                positionFactor: 0.5,
                                                widget: Text(
                                                  '${double.parse(listSubject[index]['percentage']).toInt()}%',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ]),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                              isLoading = false;
                            });
                            if (arg['card_type'] == 'subject') {
                              Navigator.pushNamed(context, '/subject_details');
                              var subId = '${listSubject[index]['id']}';
                              await SharedPref.setSubjectId(subId);
                            } else {
                              Navigator.pushNamed(context, '/subject_result');
                              var subId = '${listSubject[index]['id']}';
                              await SharedPref.setSubjectId(subId);
                            }
                          },
                        ),
                      );
                    },
                    itemCount: listSubject.length,
                  ),
          ),
        ),
      ),
    );
  }
}
