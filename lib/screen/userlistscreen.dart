import 'package:animeapp1/data/animedatabase.dart';
import 'package:animeapp1/data/database.dart';
import 'package:animeapp1/main.dart';
import 'package:animeapp1/screen/watchanime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserListScreen extends StatefulWidget {
  final Map userList;

  const UserListScreen({super.key, required this.userList});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String listName = '';
  List animeInList = [];

  @override
  void initState() {
    listName = widget.userList['listName'];
    animeInList = widget.userList['animeInList'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    int listIndex = watchLists.indexWhere((element) => element['listName'] == listName,);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: 
            listIndex == 0 || listIndex == 1
            ? (listIndex == 0? Colors.pink : Colors.blue)
            : Colors.orange,
         actions: [
          listIndex > 1  ? IconButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
                    ),
                    icon: Icon(
                      Icons.warning, 
                      size: phoneWidth/6, 
                      color: Colors.yellow,
                      shadows: List.generate(
                        5, (index) {
                          return Shadow(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            blurRadius: 5
                          );
                        }
                      ),
                    ),
                    title: Text('Delete "$listName" from your list?'),
                    titleTextStyle: TextStyle(
                      fontSize: phoneWidth / 25,
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        onPressed: () {
                          setState(() {
                            watchLists.removeAt(listIndex);
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(builder: (BuildContext context) => ScreenNavigator( navigateToScreenIndex: 1,)), 
                              (Route<dynamic> route) => false,
                            );
                          });
                        }, 
                        child: Text(
                          'Yes',
                           style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
                        )
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }, 
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
                        )
                      )
                    ],
                  );
                }
              );
            },
            icon: Icon(Icons.delete),
          ) : Center(),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (BuildContext context) => ScreenNavigator(navigateToScreenIndex: 1,)), 
              (Route<dynamic>route) => false
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        shadowColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 4, // Add elevation for a subtle shadow effect
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.background,
        ),
        centerTitle: true,
        title: Text(
          listName.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
            bottom: Radius.circular(40),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.width/30,),
          Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: animeInList.map(
              (animeTitle) {
                var anime = animeDataBase.firstWhere(
                  (anime) {
                    return anime['animeTitle'].contains(animeTitle);
                  }
                );
                return GestureDetector(
                  onTap: () {
                    var result = lastSeenAnime.firstWhere(
                      (animeSeen) => animeSeen['animeName'] == anime['animeTitle'], 
                      orElse: () => null
                    );
                    int lastSeenIndex;
                    if (result!= null) {
                      lastSeenIndex = result['lastSeenEpisode'];
                    }
                    else {
                      lastSeenIndex = 0;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => WatchAnimeScreen(anime: anime, userLastVideoIndex: lastSeenIndex,)
                      )
                    );
                  },
                  child: Container(
                    height: phoneWidth/1.6,
                    width: phoneWidth/2.31,
                    margin: EdgeInsets.symmetric(horizontal: phoneWidth/30, vertical: phoneWidth/30),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.white, width: phoneWidth/200),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(anime['animePoster']),
                        fit: BoxFit.fill
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          blurRadius: 20,
                        )
                      ]
                    ),
                  ),
                );
              }
            ).toList(),
          )
        ],
      )
    );
  }
}