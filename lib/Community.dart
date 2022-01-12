import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loadmore/loadmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  var log = 'images/background.png',
      logos = SharedPref.getSchoolLogo(),
      br = SharedPref.getBranchName(),
      sc = SharedPref.getSchoolName(),
      token = SharedPref.getUserToken(),
      newColor = SharedPref.getSchoolColor();
  int value = 0;
  var data = [];
  bool isVisible = true;
  bool isLoading = false;
BetterPlayerPlaylistController? _configuration;
  setLogo() {
    if (logos != null) {
      return '$logos';
    } else
      return '$log';
  }

  var activeIndex = 0;
  List<bool> isLiked = [];
  List<bool> isDescClick = [];
  List<int> isLikedCount = [];
  var indexes = [],
      listing = [],
      values = [1, 2, 3, 4, 5],
      pos = [
        'https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171__340.jpg',
        'https://cdn.pixabay.com/photo/2018/01/14/23/12/nature-3082832__340.jpg',
        'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072821__340.jpg',
        'https://cdn.pixabay.com/photo/2014/02/27/16/10/tree-276014__340.jpg',
        'https://cdn.pixabay.com/photo/2017/02/08/17/24/fantasy-2049567__340.jpg',
        'https://cdn.pixabay.com/photo/2015/06/19/21/24/avenue-815297__340.jpg',
        'https://cdn.pixabay.com/photo/2014/04/14/20/11/pink-324175__340.jpg',
      ],
      vid = [];
  BetterPlayerConfiguration? betterPlayerConfiguration;
  BetterPlayerListVideoPlayerController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    controller = BetterPlayerListVideoPlayerController();
    betterPlayerConfiguration = BetterPlayerConfiguration(autoPlay: true);
    getCommunity();
    indexes = List<int>.filled(values.length, 0);
    listing = List<int>.filled(values.length, 0);
    isLikedCount = List<int>.filled(values.length, 0);
    isLiked = List<bool>.filled(values.length, false);
    isDescClick = List<bool>.filled(values.length, false);
  }

  void getCommunity() async {
    HttpRequest request = HttpRequest();
    var result = await request.getCommunity(context, token!);
    setState(() {
      data = result;
      isLoading = false;
    });
  }

  Future<bool> _loadMore() async {
    debugPrint("onLoadMore");
    //await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text('$sc Community'),
      ),
      bottomSheet: Padding(padding: EdgeInsets.only(bottom: 100.0)),
      body: SafeArea(
        child: isLoading
            ? Center(child: spinkit)
            : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 13.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: titleIcon(setLogo(), 12.0),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              '$sc $br',
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff262626)),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) async {
                                await showMenuDialog(
                                    context, details.globalPosition);
                                setState(() {
                                  // isLoading = true;
                                  // postApplicationStatus(listValue[index]['id'], value);
                                });
                              },
                              child: Icon(
                                Icons.more_vert_sharp,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Stack(
                          children: [
                            Container(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isVisible = true;
                                  });
                                },
                                child: CarouselSlider.builder(
                                  itemCount: 1,
                                  itemBuilder: (BuildContext context,
                                      int itemIndex, int pageViewIndex) {
                                    return Container(
                                      child: data[index]['media_type'] ==
                                              'video'
                                          ? Container(
                                              child: BetterPlayerListVideoPlayer(
                                                BetterPlayerDataSource(BetterPlayerDataSourceType.network,'https://wasisoft.com/dev/${data[index]['media']}'),
                                                playFraction: 0.8,
                                                betterPlayerListVideoPlayerController: controller,
                                                configuration:BetterPlayerConfiguration(
                                                  aspectRatio: 9/9,
                                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                                      enableMute: false,
                                                      enableOverflowMenu: false,
                                                      enablePlayPause: false,
                                                      enableFullscreen: false,
                                                      enableSkips: false,
                                                      enableProgressText: false,
                                                      playIcon: CupertinoIcons.play_arrow_solid,
                                                      controlBarColor: Colors.transparent,
                                                      enableProgressBar:false),
                                                ),

                                               /* betterPlayerPlaylistConfiguration: BetterPlayerPlaylistConfiguration(),
                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                  aspectRatio: 9/9,
                                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                                        enableMute: false,
                                                          enableOverflowMenu: false,
                                                          enablePlayPause: false,
                                                          enableFullscreen: false,
                                                          enableSkips: false,
                                                          enableProgressText: false,
                                                          playIcon: CupertinoIcons.play_arrow_solid,
                                                          controlBarColor: Colors.transparent,
                                                          enableProgressBar:false),
                                                ),
                                                betterPlayerDataSourceList:
                                                    createDataSet(
                                                        'https://wasisoft.com/dev/${data[index]['media']}'),*/
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              filterQuality:
                                                  FilterQuality.medium,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height / 2,
                                              imageUrl:
                                                  'https://wasisoft.com/dev/${data[index]['media']}',
                                            ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    viewportFraction: 1.0,
                                    enableInfiniteScroll: false,
                                    height:
                                        MediaQuery.of(context).size.height/2,
                                    onPageChanged: (i, reason) =>
                                        setState(() {
                                      activeIndex = i;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        child: AnimatedSmoothIndicator(
                          count: 1,
                          activeIndex:
                              1 /*int.parse(data[index]['media'][activeIndex])*/,
                          effect: WormEffect(
                              offset: 8.0,
                              spacing: 4.0,
                              radius: 8.0,
                              dotWidth: 8.0,
                              dotHeight: 8.0,
                              paintStyle: PaintingStyle.fill,
                              strokeWidth: 1.0,
                              dotColor: Colors.grey,
                              activeDotColor: Colors.indigo),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isLiked[index] == true
                                        ? isLiked[index] = false
                                        : isLiked[index] = true;
                                    isLiked[index] == true
                                        ? isLikedCount[index]++
                                        : isLikedCount[index]--;
                                  });
                                },
                                icon: isLiked[index] == true
                                    ? Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Color(0xffd80000),
                                      )
                                    : Icon(CupertinoIcons.heart)),
                          ),
                          Expanded(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.send))),
                          Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '${data[index]['likes']} likes',
                                  textAlign: TextAlign.end,
                                ),
                              )),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: 8.0, left: 8.0, bottom: 8.0),
                        child: InkWell(
                          child: RichText(
                              maxLines:
                                  isDescClick[index] == true ? null : 2,
                              overflow: isDescClick[index] == true
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '$sc $br ',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xff262626),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '${data[index]['desc']}',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Color(0xff262626),
                                    )),
                              ])),
                          onTap: () {
                            setState(() {
                              isDescClick[index] == true
                                  ? isDescClick[index] = false
                                  : isDescClick[index] = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: data.length,
            ),
      ),
    );
  }

  showMenuDialog(context, details) async {
    double left = details.dx;
    double top = details.dy;
    await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(left, top, 0, 0),
            items: [
              PopupMenuItem<String>(child: Text('Edit'), value: '1'),
              PopupMenuItem<String>(child: Text('Delete'), value: '-1'),
            ],
            elevation: 8.0)
        .then((item) {
      switch (item) {
        case '1':
          value = 1;
          break;
        case '-1':
          value = -1;
          break;
      }
    });
  }

}
