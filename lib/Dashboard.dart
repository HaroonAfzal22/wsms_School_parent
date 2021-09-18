import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Shared_Pref.dart';
import 'DashboardCards.dart';
import 'NavigationDrawer.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List value;
  late var newColor = '0xff5728a',
      br = '',
      sc = '',
      logos =
          'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg',
      log = 'assets/background.png';

  Future<bool> _onWillPop() async {
    if (Platform.isIOS) {
      return await showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to exit an App'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      CupertinoDialogAction(
                        child: Text('Yes'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  )) ??
          false;
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  var r = SharedPref.getRoleId();
  late Timer _timer;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Future(() async {
      setColor();
      return await getSchoolInfo();
    });
  }

  setColor() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      var colors = await getSchoolColor();
      setState(() {
        newColor = colors;
        br = SharedPref.getBranchName()!;
        sc = SharedPref.getSchoolName()!;
        var logo = SharedPref.getSchoolLogo();
        logos = logo!;
      });
      if (br != null && sc != null && newColor != null && logos != null) {
        setState(() {
          statusColor('$newColor');
          isLoading = false;
          _timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 26.0,
          backgroundColor: Color(int.parse('$newColor')),
          title:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: logos,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '$sc\n $br',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          brightness: Brightness.dark,
          actions: <Widget>[
            Visibility(
              visible: true,
              child: IconButton(
                icon: Icon(
                  Icons.youtube_searched_for,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _settingModalBottomSheet(context);
                  });
                },
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.bell_solid,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  setState(() {
                    _settingModalBottomSheet(context);
                  });
                },
              ),
            ),
          ],
        ),
        drawer: Drawers(
          complaint: null,
          aboutUs: null,
          PTM: null,
          dashboards: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          Leave: null,
          onPress: () {
            setState(() {
              SharedPref.removeData();
              Navigator.pushReplacementNamed(context, '/');
              toastShow('Logout Successfully');
            });
          },
        ),
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: SpinKitCircle(
                    color: Color(int.parse('$newColor')),
                    size: 50.0,
                  ),
                )
              : BackgroundWidget(
                  childView: WillPopScope(
                    onWillPop: _onWillPop,
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          /*imageUser != null
                                    ? imageUser!
                                    :*/
                                          'https://st.depositphotos.com/2868925/3523/v/950/depositphotos_35236485-stock-illustration-vector-profile-icon.jpg',
                                      width: 100,
                                      height: 100,
                                    ),
                                    text: 'Profile',
                                    onClicks: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, '/profile');
                                      });
                                    },
                                  ),
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://st.depositphotos.com/1741875/1237/i/950/depositphotos_12376816-stock-photo-stack-of-old-books.jpg',
                                      width: 100,
                                      height: 100,
                                    ),
                                    text: 'Subjects',
                                    onClicks: () {
                                      Navigator.pushNamed(context, '/subjects',
                                          arguments: {
                                            'card_type': 'subject',
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://st2.depositphotos.com/1005979/8328/i/950/depositphotos_83286562-stock-photo-report-card-a-plus.jpg',
                                      width: 100,
                                      height: 100,
                                    ),
                                    text: 'Results',
                                    onClicks: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, '/result_category',
                                            arguments: {
                                              'card_type': 'result',
                                            });
                                      });
                                    },
                                  ),
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://static8.depositphotos.com/1323913/926/v/950/depositphotos_9261330-stock-illustration-vector-personal-organizer-features-xxl.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                    text: 'Daily Diary',
                                    onClicks: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, '/daily_diary');
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://static9.depositphotos.com/1004887/1206/i/950/depositphotos_12064461-stock-photo-accounting.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    text: 'Account Book',
                                    onClicks: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, '/accounts_book');
                                      });
                                    },
                                  ),
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://images.unsplash.com/photo-1518607692857-bff9babd9d40?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=667&q=80',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    text: 'Time Table',
                                    onClicks: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, '/time_table_category');
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://media.istockphoto.com/vectors/online-education-duringquarantine-covid19-coronavirus-disease-vector-id1212946108?s=612x612',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    text: 'Online Classes',
                                    onClicks: () {
                                      setState(() {
                                        print('online card click');
                                        Navigator.pushNamed(
                                            context, '/online_class_list');
                                      });
                                    },
                                  ),
                                  DashboardCards(
                                    images: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl:
                                          'https://media.istockphoto.com/vectors/businessman-hands-holding-clipboard-checklist-with-pen-checklist-vector-id935058724?s=612x612',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    text: 'Attendance',
                                    onClicks: () {
                                      setState(() {
                                        Navigator.pushNamed(
                                            context, '/student_attendance');
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) => Container(
        height: MediaQuery.of(context).copyWith().size.height,
        child: ListView.builder(
          itemBuilder: (context, index) => Card(
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            color: Color(0xff15728a),
            child: ListTile(
              leading: Card(
                elevation: 4.0,
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: value[index]['avatar'],
                ),
              ),
              title: Text(value[index]['name'],
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Roll No# ${value[index]['roll_no']}',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => {
                print('music  click at    '
                    '${value[index]['id']}'),
              },
            ),
          ),
          itemCount: value.length,
        ),
      ),
    );
  }
}
