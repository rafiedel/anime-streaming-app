import 'package:animeapp1/components/popover.dart';
import 'package:animeapp1/data/database.dart';
import 'package:animeapp1/main.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class WatchAnimeScreen extends StatefulWidget {

  final Map anime;
  final int? userLastVideoIndex;
  final bool? fromLastSeenSection;

  const WatchAnimeScreen({super.key, required this.anime, this.userLastVideoIndex, this.fromLastSeenSection});

  @override
  State<WatchAnimeScreen> createState() => _WatchAnimeScreenState();
}

class _WatchAnimeScreenState extends State<WatchAnimeScreen> {

  bool isFullScreen = false;
  bool seeEpisodes = true;
  late final YoutubePlayerController _videoController;
  List episodeList = [];
  String videoId = '';
  int nowWatching = 0;
  String animeDescription = '';
  List animeGenre = [];
  String animeTitle = '';
  bool hasStartedPlaying = false;

  @override
  void initState() {    
    animeTitle = widget.anime['animeTitle'];
    animeGenre = widget.anime['animeGenre'].split(',');
    animeDescription = widget.anime['animeDescription'].join('.');
    episodeList = widget.anime['episodeList'];
    String videoUrl;
    try {
      videoUrl = episodeList[widget.userLastVideoIndex!]['url'];
      nowWatching = widget.userLastVideoIndex!;
    } catch (e) {
      videoUrl = episodeList[0]['url'];
    }
    videoId = '${YoutubePlayer.convertUrlToId(videoUrl)}';
    _videoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false
      ),
    );

    _videoController.addListener(() {
      if (_videoController.value.isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        setState(() {
          isFullScreen = true;
        });
      } else {
        setState(() {
          isFullScreen = false;
        });
      }
      if (!hasStartedPlaying && _videoController.value.playerState == PlayerState.playing) {
        setState(() {
          lastSeenAnime.removeWhere((anime) => anime['animeName'] == animeTitle);
          lastSeenAnime.insert(0,
            {
              'animeName' : animeTitle,
              'lastSeenEpisode' : nowWatching
            }
          );
          hasStartedPlaying = true;
        });
      }
      // if (_videoController.value.playerState == PlayerState.ended) {
      //   if (nowWatching != episodeList.length - 1) {
      //     setState(() {
      //       nowWatching++;
      //       String videoId = YoutubePlayer.convertUrlToId(episodeList[nowWatching]['url'])!;
      //       _videoController.load(videoId);
      //     });
      //     print('kucing');
      //     print(nowWatching);
      //   }
      // }
    });

    super.initState();
  }

  void changeEpisode(int index_video) {
    hasStartedPlaying = false;
    String animeToWatchUrl = episodeList[index_video]['url'];
    String videoId = '${YoutubePlayer.convertUrlToId(animeToWatchUrl)}';
    setState(() {
      _videoController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false
        ),
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: !isFullScreen,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (widget.fromLastSeenSection == true) {
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (BuildContext context) => ScreenNavigator(navigateToScreenIndex: 1,)), 
                            (Route<dynamic>route) => false
                          );
                        } 
                        else {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(Icons.arrow_left,size: phoneWidth/10,color: Theme.of(context).colorScheme.inversePrimary,),
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (favoriteAnime.contains(animeTitle)) {
                                favoriteAnime.remove(animeTitle);
                              } else {
                                favoriteAnime.add(animeTitle);
                              }
                            });
                          },
                          child: Icon(
                            favoriteAnime.contains(animeTitle)? Icons.favorite : Icons.favorite_border,
                            color: favoriteAnime.contains(animeTitle)? Colors.red : Theme.of(context).colorScheme.inversePrimary,
                            size: phoneWidth/15,
                          ),
                        ),
                        SizedBox(width: phoneWidth/30,),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (watchLaterAnime.contains(animeTitle)) {
                              watchLaterAnime.remove(animeTitle);
                              }
                              else {
                                watchLaterAnime.add(animeTitle);
                              }
                            });
                          },
                          child: Icon(
                            watchLaterAnime.contains(animeTitle)? Icons.playlist_add_check : Icons.playlist_add,
                            color: watchLaterAnime.contains(animeTitle)? Colors.amber : Theme.of(context).colorScheme.inversePrimary,
                            size: phoneWidth/10,
                            ),
                        ),
                        SizedBox(width: phoneWidth/50,),
                        // Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: phoneWidth/50),
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         // drawer
                        //       },
                        //       child: Icon(Icons.queue_play_next, size: phoneWidth/15,),
                        //     ),
                        // ),
                      ],
                    )
                  ],
                ),
              )
             ) ,
            Flexible(
              flex: 5,
              child: YoutubePlayer(
                controller: _videoController,
                aspectRatio: 19.45 / 9
                ),
            ),
            Visibility(
              visible: !isFullScreen,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                seeEpisodes = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: phoneWidth/50, vertical: phoneWidth/50),
                              padding: EdgeInsets.symmetric(horizontal: phoneWidth/40, vertical: phoneWidth/80),
                              decoration: BoxDecoration(
                                color: seeEpisodes == true? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'EPISODES',
                                style: TextStyle(
                                  fontSize: seeEpisodes == true? phoneWidth/28 : phoneWidth/30
                                ),
                                ),
                            ),
                          ),
                           GestureDetector(
                            onTap: () {
                              setState(() {
                                seeEpisodes = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: phoneWidth/50, vertical: phoneWidth/50),
                              padding: EdgeInsets.symmetric(horizontal: phoneWidth/40, vertical: phoneWidth/80),
                              decoration: BoxDecoration(
                                color: seeEpisodes == false? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'MORE ABOUT',
                                style: TextStyle(
                                  fontSize: seeEpisodes == false? phoneWidth/28 : phoneWidth/30
                                ),
                                ),
                            ),
                          ),
                        ],
                      ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: phoneWidth/40),
                          child: PopOverButton(
                            animeTitle: animeTitle,
                          ),
                        ),
                    ],
                  )
                ],
              )
            ),
            Visibility(
              visible: !isFullScreen && seeEpisodes,
              child: Expanded(
                flex: 13,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: episodeList.length,
                  itemBuilder: (context,index) {
                    final videoId = YoutubePlayer.convertUrlToId(episodeList[index]['url']);
                    return GestureDetector(
                      onTap: () {
                        String videoId = YoutubePlayer.convertUrlToId(episodeList[index]['url'])!;
                        setState(() {
                          _videoController.load(videoId);
                          nowWatching = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: phoneWidth/100, vertical: phoneWidth/100),
                        decoration: BoxDecoration(
                          color: nowWatching == index? Theme.of(context).colorScheme.tertiary.withOpacity(0.75) : Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).colorScheme.background == Colors.grey.shade900? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5))
                        ), 
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InkWell(
                                onTap: () {},
                                child: AspectRatio(
                                  aspectRatio: 1.8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(YoutubePlayer.getThumbnail(videoId: videoId!)),
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
                                padding: EdgeInsets.symmetric(horizontal: phoneWidth/35),
                                child: Text(
                                  '${episodeList[index]['episode_title']}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: phoneWidth/35
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  ),
              )
            ),
            Visibility(
              visible: !isFullScreen && seeEpisodes == false,
              child: Expanded(
                flex: 13,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: phoneWidth/50, vertical: phoneWidth/200),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Genre',
                        style: TextStyle(
                          fontSize: phoneWidth/15
                        ),
                      ),
                      SizedBox(height: phoneWidth/100,),
                      GridView.builder(
                        shrinkWrap: true, // Ensure the GridView scrolls along with the ListView
                        physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: phoneWidth/45,
                          mainAxisSpacing: phoneWidth/45,
                          childAspectRatio: phoneWidth/125, // Adjust as needed
                        ),
                        itemCount: animeGenre.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3)
                            ),
                            alignment: Alignment.center,
                            child: Text(animeGenre[index], style: TextStyle(fontSize: phoneWidth/40, fontWeight: FontWeight.bold),),
                          );
                        },
                      ),
                      SizedBox(height: phoneWidth/20,),
                      Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: phoneWidth/15
                        ),
                      ),
                      Text(
                        animeDescription,
                        style: TextStyle(
                          fontSize: phoneWidth/25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

