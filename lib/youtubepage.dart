import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jikan_api/jikan_api.dart';

void main() {
  runApp(
    const youtubeapp()
  );
}

class youtubeapp extends StatelessWidget {
  const youtubeapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: YoutubePage()
    );
  }
}


class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}


class _YoutubePageState extends State<YoutubePage> {

  Future getData() async{
    final jikan = Jikan();   /// Packaged API MyAnimeList

    // FOR SAFETY REASON, I NEED TO REMOVE MY API KEY AND EACH CHANNEL API CODE

    // final channelId = '';   /// Muse Indonesia
    final channelId = ''; /// Muse Asia

    final apiKey = '';  /// My First Project
    // final apiKey = '';  /// youtubeapi
    // final apiKey = ''; /// My Project 2


    // /// EXPERIMENT
    // try {
    //   // Fetching playlists
    //   final playlistsUrl = Uri.https(
    //     'www.googleapis.com',
    //     '/youtube/v3/playlists',
    //     {'channelId': channelId, 'key': apiKey, 'part': 'snippet', 'pageToken' : ''},
    //   );
    //   var playlistsResponse = await http.get(playlistsUrl);
    //   var playlistsData = jsonDecode(playlistsResponse.body);
    //   var animeId = playlistsData['items'][1]['id'];
    //   // Fetching playlist items (videos)
    //   final playlistItemsUrl = Uri.https(
    //     'www.googleapis.com',
    //     '/youtube/v3/playlistItems',
    //     {'playlistId': animeId, 'key': apiKey, 'part': 'snippet', 'pageToken' : ''},
    //   );
    //   var playlistItemsResponse = await http.get(playlistItemsUrl);
    //   var playlistItemsData = jsonDecode(playlistItemsResponse.body);
    //   var anime_playlist = playlistItemsData['items'];
    //   return anime_playlist[1];
    //   List dataAnime = [];
    //   for (var anime in anime_playlist) {
    //     animeId = anime['snippet']['resourceId']['videoId'];
    //     final videoUrl = Uri.https(
    //       'www.googleapis.com',
    //       '/youtube/v3/videos',
    //       {'id': animeId, 'key': apiKey, 'part': 'statistics, snippet'},
    //     );
    //     var videoUrlResponse = await http.get(videoUrl);
    //     var videoUrlData = jsonDecode(videoUrlResponse.body);
    //     return videoUrlData['items'];
    //     dataAnime.add(videoUrlData['items']);
    //   }
    //   // return dataAnime;
    // } catch (e) {
    //   var dataNeeded = e.toString();
    //   return dataNeeded;
    // }




    // / JIKAN API 
    // List genre = [];
    // var result = await jikan.searchAnime(query: 'kanojo okarishimasu');
    // var selected_anime = result[0];
    // var anime_description = selected_anime.synopsis;
    // try {
    //     for (var i in selected_anime.genres) {
    //       genre.add(i.name);
    //     };
    // } catch (e) {}
    // try {
    //     for (var i in selected_anime.explicitGenres) {
    //       genre.add(i.name);
    //     }
    // } catch (e) {}
    // try {
    //     for (var i in selected_anime.themes) {
    //       genre.add(i.name);
    //     }
    // } catch (e) {}
    // try {
    //     for (var i in selected_anime.demographics) {
    //       genre.add(i.name);
    //     }
    // } catch (e) {}
    // return anime_description;


    // /// CHANNEL SECTION
    // List channelFeature = [];
    // String nextPageToken = ''; 
    // while (nextPageToken != 'Out of Index') {
    //   try {
    //     final url = Uri.https(                   
    //       'www.googleapis.com',                   
    //       '/youtube/v3/channelSections',
    //       {'part' : 'id,snippet,contentDetails','channelId': channelId, 'key': apiKey, 'pageToken' : nextPageToken},
    //     );
    //     var response = await http.get(url);
    //     var jsonData = jsonDecode(response.body);
    //     var sections = jsonData['items'];
    //     for (var section in sections) {
    //       if (section['snippet']['type'] == 'multipleplaylists') {
    //         var sectionName = section['snippet']['title'];
    //         var animeIdInSection = section['contentDetails']['playlists'];
    //         List animeNameList = [];
    //         for (var animeId in animeIdInSection) {
    //           final url2 = Uri.https(
    //             'www.googleapis.com',
    //             '/youtube/v3/playlists',
    //             {
    //             'key': apiKey,
    //             'id': animeId,
    //             'part': 'id,snippet',
    //             'fields': 'items(id,snippet(title,channelId,channelTitle))',
    //           },
    //           );
    //           var response2 = await http.get(url2);
    //           var jsonData2 = jsonDecode(response2.body); 
    //           var animeName = jsonData2['items'][0]['snippet']['title'];
    //           // print(animeName);
    //           animeNameList.add(animeName);
    //         }
    //         channelFeature.add(
    //           {
    //             'sectionTitle' : sectionName,
    //             'animeNameList' : animeNameList
    //           }
    //         );
    //       }
    //     }
    //     nextPageToken = jsonData['nextPageToken'];
    //   } catch (e) {
    //     nextPageToken = 'Out of Index';
    //   }
    // }
    // return channelFeature;



    /// PROCESSING DATA FROM YOUTUBE TO DATABASE
    List animeDataBase = [];
    /// iterasi pertama, masuk ke setiap halaman playlist
    String nextPageToken = '';
    while (nextPageToken != 'Out of Index') {
      try {
        final url = Uri.https(
          'www.googleapis.com',
          '/youtube/v3/playlists',
          {'channelId': channelId, 'key': apiKey, 'part' : 'snippet', 'pageToken': nextPageToken, 'maxResults' : '50'}, /// 'maxResults' : '50'
        );
        var response = await http.get(url);
        var jsonData = jsonDecode(response.body);
        var anime_playlist = jsonData['items'];
        // var cek = '';
        /// iterasi kedua masuk ke setiap playlist
        for (var anime in anime_playlist) {
          String anime_title = anime['snippet']['title'];
          // if (anime_title.contains('SPY×FAMILY')) {
          //   cek = '01';
          // }
          if (anime_title.toLowerCase().contains('english sub') ||
              anime_title.toLowerCase().contains('english dub') ||
              anime_title.toLowerCase().contains('takarir indonesia') ||
              anime_title.toLowerCase().contains('bahasa indonesia')
          ) {
            /// iterasi ketiga, masuk ke setiap halaman episode
            var nextPageToken2 = '';
            List episodeList= [];
            double avarageViews = 0;
            double total_views = 0;
            double total_episode = 0;
            while (nextPageToken2 != 'Out of Index') {
              try {
                String anime_id = anime['id'];
                //////////////////////////////////////////////////////////////////////////////////////
                final url2 = Uri.https(
                  'www.googleapis.com',
                  '/youtube/v3/playlistItems',
                  {'playlistId': anime_id, 'key': apiKey, 'part' : 'snippet', 'pageToken' : nextPageToken2, 'maxResults' : '50'}, /// 'maxResults' : '50'
                );
                //////////////////////////////////////////////////////////////////////////////////////
                var response2 = await http.get(url2);
                var jsonData2 = jsonDecode(response2.body);
                var anime_episodes = jsonData2['items'];
                /// iterasi keempat, masuk ke setiap episode
                for (var episode in anime_episodes) {
                  String videoId = episode['snippet']['resourceId']['videoId'];
                  String title = episode['snippet']['title'];
                  if (title != 'Private video') {
                    episodeList.add({
                      'url': 'https://www.youtube.com/watch?v=$videoId',
                      'episode_title': title
                    });
                    try {
                      final videoUrl = Uri.https(
                        'www.googleapis.com',
                        '/youtube/v3/videos',
                        {'id': videoId, 'key': apiKey, 'part': 'statistics,snippet'},
                      );
                      var videoUrlResponse = await http.get(videoUrl);
                      var videoUrlData = jsonDecode(videoUrlResponse.body);
                      total_views += int.parse(videoUrlData['items'][0]['statistics']['viewCount']);
                      total_episode += 1;
                      // print('$anime_title        $title');
                    } catch (e) {
                      // Handle errors when fetching video statistics
                      // print('Error fetching video statistics for $videoId: $e');
                    }
                  }
                }
                nextPageToken2 = jsonData2['nextPageToken'];
              } catch (e) {
                nextPageToken2 = 'Out of Index';
              }
            }
            String animePoster; 
            String animeGenre = '';
            List animeDescription = [];
            String searchKey = anime_title
              .replaceAll('[English Sub]', '')
              .replaceAll('[English Dub]', '')
              .replaceAll('【Limited Broadcast】', '')
              .trim()
              .toLowerCase();
            try {
              final result = await jikan.searchAnime(query: searchKey);
              var selected_anime = result[0];
              animePoster = selected_anime.imageUrl;
              animeDescription = selected_anime.synopsis!
                      .replaceAll('\n', '')
                      .replaceAll('"', '')
                      .replaceAll("'", '')
                      .split('.');
              try {
                  for (var i in selected_anime.genres) {
                    animeGenre += '${i.name},';
                  };
              } catch (e) {}
              try {
                  for (var i in selected_anime.explicitGenres) {
                    animeGenre += '${i.name},';
                  }
              } catch (e) {}
              try {
                  for (var i in selected_anime.themes) {
                    animeGenre += '${i.name},';
                  }
              } catch (e) {}
              try {
                  for (var i in selected_anime.demographics) {
                    animeGenre += '${i.name},';
                  }
              } catch (e) {}
                  animeGenre = animeGenre.substring(0, animeGenre.length - 1);
            } catch (e) {
              animePoster = 'https://yt3.googleusercontent.com/p2cg2LI1SBuY6c5dkXLhMVORpbMQ3AZGb-lmHqBaFM6qkceq2EdqDER9cRhw_KFGoBQRioia=s900-c-k-c0x00ffffff-no-rj';
            }
            print('    $anime_title     =   ${episodeList.length}');
            avarageViews = total_views / total_episode / 1000;
            if (episodeList.isNotEmpty) {
              animeDataBase.add(
                {
                  'animeTitle' : anime_title,
                  'avarageView' : '${avarageViews.toStringAsFixed(1)}K',
                  'animeGenre' : animeGenre,
                  'animePoster' : animePoster,
                  'animeDescription' : animeDescription,
                  'episodeList' : episodeList
                }
              );
            }
            // if (anime_title.contains("Ningen Fushin: Adventurers Who Don't Believe in Humanity Will Save the World")) {
            //   return animeDataBase;
            // }
          }
        }
        nextPageToken = jsonData['nextPageToken'];
        // if (cek == '01') {
        //   nextPageToken = 'Out of Index';
        // }
      } catch (e) {
        nextPageToken = 'Out of Index';
      }
    }

    return animeDataBase;
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Page'),
      ),
      body: FutureBuilder(
        future: getData(), 
        builder: (context,snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!;
          return ListView(
            children: <Widget>[
              // Expanded(child: Text('$data')),
              Expanded(child: Text('Done')),
              // Image.network(YoutubePlayer.getThumbnail(videoId: data))
              ElevatedButton(
                onPressed: () {
                  // print(data);

                  // for (var anime in data) {
                  //   print('{');
                  //   print('  "animeTitle" : "${anime['animeTitle']}" ,');
                  //   print('  "avarageView" : "${anime['avarageView']}" ,');
                  //   print('  "animeGenre" : "${anime['animeGenre']}" ,');
                  //   print('  "animePoster" : "${anime['animePoster']}" ,');
                  //   print('  "animeDescription" : [');
                  //   for (var i in anime['animeDescription']) {
                  //     print('     "$i",');
                  //   }
                  //   print('   ],');
                  //   print('  "episodeList" : [');
                  //   for (var i in anime['episodeList']) {
                  //     print('     {"url" :  "${i['url']}", ');
                  //     print('     "episode_title" : "${i['episode_title']}"},');
                  //   }
                  //   print('   ]');
                  //   print('},');
                  // }


                  /// Section Feature di Muse Asia
                  for (var anime in data) {
                    print('{');
                    print('   "sectionTitle" : "${anime['sectionTitle']}" , ');
                    print('   "animeNameList" : [');
                    for (var i in anime['animeNameList']) {
                      print('     "$i",');
                    }
                    print('   ]');
                    print('},');
                  }
                }, 
                child: Text('print data')
                )
            ],
          );
        }
      )
    );
  }
}


