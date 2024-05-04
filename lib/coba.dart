import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';


class FoodList extends ISuspensionBean{
  final String title;
  final String tag;
  FoodList({
    required this.title,
    required this.tag
  });

  @override
  String getSuspensionTag() {
    return tag;
  }
}


void main() {
  runApp(
    const ThisApp()
  );
}

class ThisApp extends StatelessWidget {
  const ThisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage()
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Az List View'),
      ),
      body: const AlphabeticScrollView(
        items: [
          'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry',
          'Fig', 'Grape', 'Honeydew', 'Jackfruit', 'Kiwi',
          'Lemon', 'Mango', 'Nectarine', 'Orange', 'Peach',
          'Quince', 'Raspberry', 'Strawberry', 'Tangerine', 'Ugli Fruit',
          'Vanilla', 'Watermelon', 'Xigua', 'Yellow Plum', 'Zucchini'
        ],
      )
    );
  }
}





class AlphabeticScrollView extends StatefulWidget {
  final List items;
  const AlphabeticScrollView({super.key, required this.items});

  @override
  State<AlphabeticScrollView> createState() => _AlphabeticScrollViewState();
}

class _AlphabeticScrollViewState extends State<AlphabeticScrollView> {
  List<FoodList> items = [];

  @override
  void initState() {
    super.initState();
    initList(widget.items);
  }

  void initList(List items) {
    this.items = items.map((item) => FoodList(title: item, tag: item[0])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: items, 
      indexBarMargin: const EdgeInsets.all(8),
      indexHintBuilder: (context,tag) {
        return Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          color: Colors.indigo,
          child: Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        );
      },
      indexBarOptions: const IndexBarOptions(
        indexHintAlignment: Alignment.centerRight,
        selectTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
        selectItemDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue
        )
      ),
      itemCount: items.length, 
      itemBuilder: (context,index){
        final item = items[index];
        return _buildListItem(item);
      }
    );
  }

  Widget _buildListItem(FoodList item) {
    return ListTile(
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.white
        ),
        ),
    );
  }
}