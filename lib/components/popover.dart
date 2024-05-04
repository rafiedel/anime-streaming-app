import 'package:animeapp1/data/database.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';


class PopOverButton extends StatelessWidget {
  final String animeTitle;
  const PopOverButton({super.key, required this.animeTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context, 
          width: MediaQuery.of(context).size.width/2.2,
          height: MediaQuery.of(context).size.width / 8.5  * (watchLists.length-2),
          bodyBuilder: (context) => ShowItems( animeTitle:  animeTitle,),
          arrowDxOffset: -MediaQuery.of(context).size.width/(2.2 * 2), arrowDyOffset: 0,
          arrowHeight: 0, arrowWidth: 0,
          backgroundColor: Colors.grey.shade700
        );
      },
      child: Icon(Icons.movie), 
    );
  }
}

class ShowItems extends StatefulWidget {
  final String animeTitle;
  const ShowItems({super.key, required this.animeTitle});

  @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: watchLists.sublist(2).map(
        (list) {
          return GestureDetector(
            onTap: () {
              int listIndex = watchLists.indexWhere((element) => element['listName'] == list['listName']);
              if (watchLists[listIndex]['animeInList'].contains(widget.animeTitle)) {
                setState(() {
                  watchLists[listIndex]['animeInList'].remove(widget.animeTitle);
                });
              }
              else {
                setState(() {
                  watchLists[listIndex]['animeInList'].add(widget.animeTitle);
                });
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: phoneWidth/150),
              margin: EdgeInsets.symmetric(vertical: phoneWidth/150, horizontal: phoneWidth/100),
              decoration: BoxDecoration(
                color: list['animeInList'].contains(widget.animeTitle) 
                      ? Theme.of(context).colorScheme.background.withOpacity(0.75)
                      : Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(4)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: phoneWidth/50, vertical: phoneWidth/150),
                    child: Text(
                      list['listName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/27.5
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Icon(
                      Icons.done,
                      color: list['animeInList'].contains(widget.animeTitle) 
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1)
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ).toList() 
    );
  }
}