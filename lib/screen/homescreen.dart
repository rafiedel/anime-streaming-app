import 'dart:async';
import 'dart:math';
// import 'package:animeapp1/components/notifbottomsheet.dart';
import 'package:animeapp1/data/animedatabase.dart';
import 'package:animeapp1/data/database.dart';
import 'package:animeapp1/screen/searchscreen.dart';
import 'package:animeapp1/screen/watchanime.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              children: <Widget>[
                SlidingAppBar(),
                SizedBox(height: phoneWidth / 15,),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: channelFeature.length,
                  itemBuilder: (context,index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(width: phoneWidth / 45,),
                            Expanded(
                              child: Text(
                                '${channelFeature[index]['sectionTitle']}',
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: phoneWidth/22.5,
                                  fontWeight: FontWeight.w900
                                ),
                                ),
                            ),
                          ],
                        ),
                        SizedBox(height: phoneWidth/45,),
                        SizedBox(
                          height: phoneWidth /2.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: channelFeature[index]['animeNameList'].length,
                            itemBuilder: (context,animeIndex) {
                              var animeTitle = channelFeature[index]['animeNameList'][animeIndex].toLowerCase();
                              int animeIndexInDB = animeDataBase.indexWhere((anime) => anime['animeTitle'].toLowerCase().contains(animeTitle));
                              try {
                                return GestureDetector(
                                  onTap: () {
                                    var item = lastSeenAnime.firstWhere(
                                      (anime) => anime['animeName'] == animeDataBase[animeIndexInDB]['animeTitle'], 
                                      orElse: () => null
                                    );
                                    int lastSeenIndex;
                                    if (item!= null) {
                                      lastSeenIndex = item['lastSeenEpisode'];
                                    }
                                    else {
                                      lastSeenIndex = 0;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => WatchAnimeScreen(anime: animeDataBase[animeIndexInDB],userLastVideoIndex: lastSeenIndex,)
                                      )
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 3.1,
                                        margin: EdgeInsets.symmetric(horizontal: phoneWidth / 45),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(animeDataBase[animeIndexInDB]['animePoster']),
                                            fit: BoxFit.fill
                                          )
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.visibility, 
                                              size: phoneWidth / 25, 
                                              color: Colors.white, 
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 0),
                                                ),
                                              ]
                                            ),
                                            SizedBox(width: phoneWidth/80), // Adjust as needed
                                            Text(
                                              '${animeDataBase[animeIndexInDB]['avarageView']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: phoneWidth/30,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ]
                                              ),
                                            ),
                                            SizedBox(width: phoneWidth/32.5,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (e) {
                                return SizedBox.shrink();
                              }
                            }
                          ),
                        ),
                        SizedBox(height: phoneWidth/10,)
                      ],
                    );
                  }
                )
              ],
            ),
            Positioned(
              top: 0, // Adjust top position as needed
              left: 0, // Adjust left position as needed
              right: 0, // Adjust right position as needed
              child: Container(
                padding: EdgeInsets.all(0),
                color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: phoneWidth/50,),
                        Text(
                          'MUSE ASIA',
                          style: TextStyle(
                            letterSpacing: phoneWidth/70,
                            fontWeight: FontWeight.w900,
                            fontSize: phoneWidth/19,
                            color: Colors.orange,
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                blurRadius: 40,
                                offset: Offset(0, 0),
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(1, 0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(phoneWidth/80),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SearchScreen()
                                )
                              );
                            },
                            child: Icon(
                              Icons.search, 
                              size: phoneWidth/14,
                              color: Colors.white, 
                              shadows: [
                                Shadow(
                                  color: Colors.orange,
                                  blurRadius: 40,
                                  offset: Offset(0, 0),
                                ),
                                Shadow(
                                  color: Colors.orange,
                                  blurRadius: 10,
                                  offset: Offset(1, 0),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: phoneWidth/60,),
                        // Padding(
                        //   padding: EdgeInsets.all(phoneWidth/100),
                        //   child: NotifButton()
                        // ),
                        SizedBox(width: phoneWidth/60,)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SlidingAppBar extends StatefulWidget {
  const SlidingAppBar({super.key});

  @override
  State<SlidingAppBar> createState() => _SlidingAppBarState();
}
class _SlidingAppBarState extends State<SlidingAppBar> {

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: phoneWidth,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: 10,
            itemBuilder: (context, index) {
              int randomIndex = Random().nextInt(animeDataBase.length);
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(animeDataBase[randomIndex]['animePoster']),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Theme.of(context).colorScheme.background == Colors.grey.shade900? Alignment.topCenter : Alignment.center,
                        colors: [
                          Theme.of(context).colorScheme.background.withOpacity(1), // Semi-transparent black color
                          Theme.of(context).colorScheme.background.withOpacity(0.1), // Fully transparent
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: phoneWidth/45),
                        child: Text(
                          '${animeDataBase[randomIndex]['animeTitle']
                                .replaceAll('[English Sub]', '')
                                .replaceAll('[English Dub]', '')
                                .replaceAll('【Limited Broadcast】', '')
                                .trim()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: phoneWidth/19,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.visibility,size: phoneWidth/25,),
                          Text('${animeDataBase[randomIndex]['avarageView']}',style: TextStyle(fontSize: phoneWidth/30),)
                        ],
                      ),
                      SizedBox(height: phoneWidth/45,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!watchLaterAnime.contains(animeDataBase[randomIndex]['animeTitle'])) GestureDetector(
                            onTap: () {
                              setState(() {
                                if (watchLaterAnime.contains(animeDataBase[randomIndex]['animeTitle'])) {
                                  watchLaterAnime.remove(animeDataBase[randomIndex]['animeTitle']);
                                } else {
                                  watchLaterAnime.add(animeDataBase[randomIndex]['animeTitle']);
                                }
                              });
                            },
                            child: Container(
                              height: phoneWidth/11,
                              width: phoneWidth/4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Text(
                                  'Watch it Later',
                                  style: TextStyle(
                                    fontSize: phoneWidth/35,
                                    color: Theme.of(context).colorScheme.background,
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),
                              ),
                            ),
                          ),
                          SizedBox(width: phoneWidth/45,),
                          GestureDetector(
                            onTap: () {
                              var item = lastSeenAnime.firstWhere(
                                (anime) => anime['animeName'] == animeDataBase[randomIndex]['animeTitle'], 
                                orElse: () => null
                              );
                              int lastSeenIndex;
                              if (item!= null) {
                                lastSeenIndex = item['lastSeenEpisode'];
                              }
                              else {
                                lastSeenIndex = 0;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => WatchAnimeScreen(anime: animeDataBase[randomIndex], userLastVideoIndex: lastSeenIndex,)
                                )
                              );
                            },
                            child: Container(
                              height: phoneWidth/11,
                              width: phoneWidth/4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Text(
                                  'Watch it Now',
                                  style: TextStyle(
                                    fontSize: phoneWidth/35,
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: phoneWidth/20,)
                    ],
                  )
                ],
              );
            },
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
        ],
      )
    );
  }
}

