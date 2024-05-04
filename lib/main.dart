import 'package:animeapp1/screen/favoritescreen.dart';
import 'package:animeapp1/screen/homescreen.dart';
import 'package:animeapp1/screen/profilescreen.dart';
import 'package:animeapp1/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Streaming App 1',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: ScreenNavigator()
    );
  }
}




class ScreenNavigator extends StatefulWidget {
  final int? navigateToScreenIndex;
  const ScreenNavigator({Key? key, this.navigateToScreenIndex}) : super(key: key);

  @override
  State<ScreenNavigator> createState() => _ScreenNavigatorState();
}

class _ScreenNavigatorState extends State<ScreenNavigator> {
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  final List _pageIcons = [Icons.home_outlined, Icons.video_collection_sharp, Icons.account_box_rounded];
  int? _currentPageIndex;

  PageController? _pageController;

  @override
  void initState() {
    try {
      _pageController = PageController(initialPage: widget.navigateToScreenIndex!);
      _currentPageIndex = widget.navigateToScreenIndex!;
    } catch (e) {
      _pageController = PageController(initialPage: 0);
      _currentPageIndex = 0;
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _widgetOptions.length,
              itemBuilder: (context, index) {
                return _widgetOptions[index];
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(phoneWidth/45),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.175),
              border: Theme.of(context).colorScheme.inversePrimary == Colors.grey.shade900? Border(
                top: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1)
                )
              ):null
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _widgetOptions.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                    child: Stack(
                      children: [
                        // White underline strip
                        if (index == _currentPageIndex)
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 10000),
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 2,
                          child: Container(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Icon(
                          _pageIcons[index],
                          size: phoneWidth/15,
                          color: index == _currentPageIndex ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primary,
                          shadows: [
                            index == _currentPageIndex
                            ? Shadow(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                blurRadius: 40,
                                offset: Offset(0, 0),
                              )
                            : Shadow(),
                            Shadow(
                              color: Theme.of(context).colorScheme.secondary,
                              blurRadius: 10,
                              offset: Offset(1, 0),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


