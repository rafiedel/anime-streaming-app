import 'dart:ui';
import 'package:animeapp1/data/animedatabase.dart';
import 'package:animeapp1/data/database.dart';
import 'package:animeapp1/screen/userlistscreen.dart';
import 'package:animeapp1/screen/watchanime.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  void makeNewList() {
    double phoneWidth = MediaQuery.of(context).size.width;
    TextEditingController _listTitleController = TextEditingController();
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          child: Container(
            height: phoneWidth/2.2,
            width: 0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: phoneWidth/ 50,),
                  child: Text(
                    'NEW LIST',
                    
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: MediaQuery.of(context).size.width/40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/50,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _listTitleController,
                    decoration: InputDecoration(
                      labelText: 'Enter title',
                      hintText: 'Watch List Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Adjust the vertical padding
                      // You can customize other decoration properties as needed
                    ),
                  ),
                ),
                SizedBox(height: phoneWidth/17.5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (_listTitleController.text.isNotEmpty) {
                          setState(() {
                            watchLists.add(
                              {
                                'listName' : _listTitleController.text,
                                'animeInList' : []
                              }
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: phoneWidth/6,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: Text(
                          'Save',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: phoneWidth/30,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: phoneWidth/6,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: phoneWidth/40,),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width/ 1.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: 
                    Theme.of(context).colorScheme.background == Colors.grey.shade900?
                    ([
                      Colors.orange, 
                      Color.fromARGB(255, 221, 161, 70),
                      Color.fromARGB(255, 244, 202, 118).withOpacity(0.5), 
                      ]) : ([
                          Color.fromARGB(255, 225, 177, 81), 
                          Color.fromARGB(255, 221, 161, 70),
                          const Color.fromARGB(255, 185, 111, 0).withOpacity(0.5), 
                            ]),
                    stops: [0.0, 0.9,1],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 50,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: phoneWidth/20),
                      child: Text(
                        'Last Seen',
                        style: TextStyle(
                          fontSize: phoneWidth/20,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.background,
                              blurRadius: 5
                            )
                          ]
                        ),
                      ),
                    ),
                    SizedBox(height: phoneWidth/30,),
                    lastSeenTiles(),
                  ],
                )
              ),
            ),
            SizedBox(height: phoneWidth/20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: phoneWidth/20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your List',
                    style: TextStyle(
                      fontSize: phoneWidth/20,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      makeNewList();
                    },
                    child: Icon(
                      Icons.add, 
                      size: phoneWidth/16,
                    ),
                  )
                ],
              ),
            ),
            userListTiles()
          ],
        ),
      )
    );
  }

  Widget lastSeenTiles() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container( 
      height: MediaQuery.of(context).size.width / 2.1,
      child: Swiper(
        duration: 1200,
        loop: false,
        customLayoutOption: CustomLayoutOption(
          startIndex: 0,
        ),
        viewportFraction: 0.9,
        scale: 1.1,
        scrollDirection: Axis.horizontal,
        itemCount: lastSeenAnime.length,
        itemBuilder: (context, index) {
          var anime = animeDataBase.firstWhere(
            (anime) {
              return anime['animeTitle'].contains(lastSeenAnime[index]['animeName']);
            }
          );
          int lastSeenEpisode = lastSeenAnime[index]['lastSeenEpisode'];
          String videoUrl = anime['episodeList'][lastSeenEpisode]['url'];
          String videoId = YoutubePlayer.convertUrlToId(videoUrl)!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => WatchAnimeScreen(anime: anime, userLastVideoIndex: lastSeenEpisode, fromLastSeenSection: true,)
                  )
              );
              
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 1.35,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(YoutubePlayer.getThumbnail(videoId: videoId)),
                  fit: BoxFit.fitWidth
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.background.withOpacity(0.1),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: EdgeInsets.all(phoneWidth/200),
                                child: AspectRatio(
                                  aspectRatio: 1/5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(anime['animePoster']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: phoneWidth/100),
                                child: Text(
                                  '${anime['animeTitle']}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width / 35,
                                    shadows: List.generate(
                                      5, (index) {
                                        return Shadow(
                                          color: Theme.of(context).colorScheme.tertiary,
                                          blurRadius: 5
                                        );
                                      }
                                    )
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                        Positioned(
                          top: -phoneWidth/75,
                          right: phoneWidth/80,
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.background,
                                  blurRadius: 25,
                                ),
                              ]
                            ),
                            child: Text(
                              index <= 8? '#0${lastSeenEpisode + 1}' : '#${lastSeenEpisode}',
                              style: TextStyle(
                                fontSize: phoneWidth/20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900,
                                letterSpacing: phoneWidth/125,
                                decoration: TextDecoration.underline
                              ),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ),
          );
        },
      ),
    );
  }

  Widget userListTiles() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(phoneWidth/50, phoneWidth/20, phoneWidth/50, 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: List.generate(
          watchLists.length,
          (index) {
            var list = watchLists[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserListScreen(userList: list,)
                      )
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width / 2.5,
                    width: MediaQuery.of(context).size.width / 2.5,
                    margin: EdgeInsets.symmetric(
                      vertical: phoneWidth/90, 
                      horizontal : MediaQuery.of(context).size.width / 26
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          direction: Axis.horizontal,
                          children: List.generate(
                            4, (index) {
                              try {
                                var anime = animeDataBase.firstWhere(
                                  (anime) {
                                    return anime['animeTitle'].contains(list['animeInList'][index]);
                                  }
                                );
                                return Container(
                                    height: MediaQuery.of(context).size.width / 2.5 /2,
                                    width: MediaQuery.of(context).size.width / 2.5 /2,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).colorScheme.background, width:phoneWidth/200),
                                      borderRadius: 
                                        index % 2 == 0? (
                                          index == 0? BorderRadius.only(topLeft: Radius.circular(10))
                                            : BorderRadius.only(bottomLeft: Radius.circular(10))
                                            )
                                        : (index == 1? BorderRadius.only(topRight: Radius.circular(10))
                                            : BorderRadius.only(bottomRight: Radius.circular(10))
                                            ),
                                      image: DecorationImage(
                                        image: NetworkImage(anime['animePoster']),
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).colorScheme.background.withOpacity(0.1),
                                          BlendMode.darken,
                                        ),
                                        fit: BoxFit.cover
                                      )             
                                    ),
                                  );
                              } 
                              catch (e) {
                                return Container(
                                  height: MediaQuery.of(context).size.width / 2.5 /2,
                                  width: MediaQuery.of(context).size.width / 2.5 /2,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).colorScheme.background, width:phoneWidth/200),
                                    borderRadius: 
                                      index % 2 == 0? (
                                        index == 0? BorderRadius.only(topLeft: Radius.circular(10))
                                          : BorderRadius.only(bottomLeft: Radius.circular(10))
                                          )
                                      : (index == 1? BorderRadius.only(topRight: Radius.circular(10))
                                          : BorderRadius.only(bottomRight: Radius.circular(10))
                                          ),
                                  ),
                                );
                               }
                            }
                          ),
                        ),
                        Visibility(
                          visible: index == 0 || index == 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: index == 0? Colors.pink.withOpacity(0.5) : Colors.blue.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Icon(
                                index == 0? Icons.favorite : Icons.watch_later,
                                size: MediaQuery.of(context).size.width / 4,
                                color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  padding: EdgeInsets.fromLTRB(phoneWidth/25, 0, phoneWidth/25, phoneWidth/10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list['listName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: phoneWidth/30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '${list['animeInList'].length} item', style: TextStyle(fontSize: phoneWidth/35),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, size.height);

    var firstControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 4, size.height);
    var secondEndPoint = Offset(0, size.height - 30);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}