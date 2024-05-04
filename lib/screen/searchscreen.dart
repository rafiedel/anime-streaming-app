import 'package:animeapp1/data/animedatabase.dart';
import 'package:animeapp1/data/database.dart';
import 'package:animeapp1/screen/watchanime.dart';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';


class Anime extends ISuspensionBean{
  final  String title;
  final String poster_url;
  final int total_episodes;
  String genre;
  final String tag;

  Anime({
    required this.title,
    required this.poster_url,
    required this.total_episodes,
    required this.genre,
    required this.tag
  });

  @override
  String getSuspensionTag() {
    return tag;
  }
}



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with WidgetsBindingObserver{

  final TextEditingController _searchController = TextEditingController();
  String _searchKey = '';
  List<Anime> allItems = [];
  List<Anime> itemsSearched = [];
  List genreToSort = [];
  List selectedGenre = [];
  bool showFilterAnime = false;
  bool isKeyBoardVisible = false;

  @override
  void initState() {
    super.initState();
    initList(animeDataBase);
    initGenre(animeDataBase);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      isKeyBoardVisible = keyboardHeight > 0;
      // if (isKeyBoardVisible && showFilterAnime) {
      //   showFilterAnime = false;
      // } 
      // else if (isKeyBoardVisible == false && showFilterAnime == true) {
      //   showFilterAnime = true;
      // }
    });
  }


  void initGenre(List animeDataBase) {
    List allGenre = animeDataBase
        .expand((anime) => anime['animeGenre'].split(','))
        .where((genre) => genre.trim().isNotEmpty) // Remove empty items
        .toList()
        .toSet()
        .toList();
        allGenre.sort();

    genreToSort = allGenre.map(
      (element) => {'genre': element, 'beingSearch': false}
    ).toList();
  }

  void initList(List animeDataBase) {
    allItems = animeDataBase.map((item) {
      return Anime(
        title: item['animeTitle'],
        poster_url: item['animePoster'],
        genre: item['animeGenre'],
        total_episodes: item['episodeList'].length,
        tag: item['animeTitle'][0],
      );
    }).toList();

    allItems.sort((a, b) => a.title[0].compareTo(b.title[0]));
    itemsSearched = allItems;
  }

  void searchAnime(String searchKey, List genreToSort) {
    setState(() {
      if (genreToSort.isNotEmpty) {
        itemsSearched = allItems.where(
          (anime) =>
              anime.title.toString().toLowerCase().contains(searchKey)
              &&
              selectedGenre.any((genre) =>anime.genre.contains(genre))
        ).toList();
      }
      else {
        itemsSearched = allItems.where(
        (anime) =>
            anime.title.toString().toLowerCase().contains(searchKey)
      ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: phoneWidth/5,),
                Expanded(
                  child: AlphabeticScrollView(),
                )
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(height: phoneWidth/30,),
                SearchTools(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchTools() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: phoneWidth/50,),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: phoneWidth/35),
                height: phoneWidth/8,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.inversePrimary), // Adjust border color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: showFilterAnime == false? Radius.circular(10) : Radius.circular(0),
                    bottomRight: showFilterAnime == false? Radius.circular(10) : Radius.circular(0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (searchKey) {
                          setState(() {
                            _searchKey = searchKey;
                          });
                          searchAnime(searchKey, selectedGenre);
                        },
                        style: TextStyle(
                          fontSize: phoneWidth/25
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none, // Hide TextField border
                          hintText: 'Search', // Add a placeholder
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), // Hint text color
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showFilterAnime = !showFilterAnime;
                          });
                        },
                        child: Icon(Icons.manage_search, size: phoneWidth/15, color: Theme.of(context).colorScheme.inversePrimary), // Adjust icon color
                      ),
                    )
                  ],
                ),
              ),
              filterAnime()
            ],
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width / 50,),
        Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/30, horizontal: MediaQuery.of(context).size.width / 40),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, size: phoneWidth/20,),
            ),
          ),
      ],
    );
  }

  Widget filterAnime() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Visibility(
      visible: showFilterAnime,
      child: Container(
        height:MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(50),
          ),
          color: Theme.of(context).colorScheme.background ,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(50),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal, // Set wrap direction to horizontal
                children: genreToSort.map((genre) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: phoneWidth/100),
                    child: ChoiceChip(
                      label: Text(
                        genre['genre'],
                        style: TextStyle(
                          fontSize: phoneWidth/35,
                          fontWeight: FontWeight.bold,
                          color: genre['beingSearch']? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.inversePrimary
                        ),
                        ),
                      selected: genre['beingSearch'],
                      backgroundColor: Theme.of(context).colorScheme.background == Colors.grey.shade900
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.75),
                      selectedColor: Theme.of(context).colorScheme.background == Colors.grey.shade900
                            ? Colors.white
                            : Colors.black.withOpacity(0.75),
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        int targetIndex = genreToSort.indexWhere(
                          (element) => element.containsValue(genre['genre'])
                        );
                        setState(() {
                          genreToSort[targetIndex]['beingSearch'] = !genreToSort[targetIndex]['beingSearch'];

                        if (genreToSort[targetIndex]['beingSearch'] == true) {
                            selectedGenre.add(genre['genre']);
                          }
                          else {
                            selectedGenre.remove(genre['genre']);
                          }
                        });
                        print(selectedGenre);

                        searchAnime(_searchKey, selectedGenre);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      )
    );
  }


  Widget AlphabeticScrollView() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return AzListView(
      data: itemsSearched, 
      // indexBarMargin: const EdgeInsets.all(10),
      indexHintBuilder: (context,tag) {
        return Container(
          width: phoneWidth/10,
          height: phoneWidth/10,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background,
          child: Text(
            tag,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: phoneWidth/20,
              fontWeight: FontWeight.bold
            ),
          ),
        );
      },
      indexBarOptions: IndexBarOptions(
        indexHintAlignment: Alignment.center,
        selectTextStyle: TextStyle(
          fontSize: phoneWidth/40,
          color: Theme.of(context).colorScheme.background,
          fontWeight: FontWeight.bold
        ),
        selectItemDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.inversePrimary
        )
      ),
      itemCount: itemsSearched.length, 
      itemBuilder: (context,index){
        final item = itemsSearched[index];
        return _buildListItem(item);
      }
    );
  }

  Widget _buildListItem(Anime item) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        int index = animeDataBase.indexWhere((anime) => anime['animeTitle'] == item.title);
        var result = lastSeenAnime.firstWhere(
          (anime) => anime['animeName'] == animeDataBase[index]['animeTitle'], 
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
            builder: (BuildContext context) => WatchAnimeScreen(anime: animeDataBase[index], userLastVideoIndex: lastSeenIndex,)
          )
        );
      },
      child: Container(
        height:phoneWidth/1.8,
        margin: EdgeInsets.only( right: phoneWidth/10, bottom: phoneWidth/20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
            top: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
            right: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)
          )
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.poster_url),
                    fit: BoxFit.fill
                  )
                ),
              ),
            ),
            Container(
              width: 1,
              color: Theme.of(context).colorScheme.inversePrimary
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: phoneWidth/50, right: phoneWidth/100),
                    child: Text(
                      item.title, 
                      maxLines: null,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: phoneWidth/35
                      ),
                      ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: phoneWidth/50),
                    child: Text(
                      'Episodes : ${item.total_episodes}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        fontSize: phoneWidth/37.5
                      ),
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: phoneWidth/50),
                    child: Text(
                      '${item.genre}',
                      style: TextStyle(
                        fontSize: phoneWidth/41,
                        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)
                      ),
                      ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}