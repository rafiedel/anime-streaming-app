import 'dart:ui';

import 'package:animeapp1/theme/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            expandedHeight: phoneHeight/4,
            actions: [
              logOutButton()
            ],
            backgroundColor: Theme.of(context).colorScheme.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://i.pinimg.com/originals/8a/44/9b/8a449b087bddf293ab9142d63c2d00b6.png'),
                    fit: BoxFit.fitWidth,
                    opacity: 0.8
                  )
                ),
                child: userProfile(),
              )
            ),
          ),
          SliverList.list(
            children: <Widget>[
              SizedBox(height: phoneWidth/30,),
              settings(),
              friendList(),
              userSummary(),
            ]
          )
        ],
      ),
    );
  }

  Widget logOutButton() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            height: phoneWidth/17,
            width: phoneWidth/6.5,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background.withOpacity(0.75),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: phoneWidth/40,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold, 
                ),
              )
            ),
          ),
        )
      ],
    );
  }

  Widget userProfile() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: phoneWidth/40, vertical: phoneWidth/50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade900,
                radius: phoneWidth/8,
                backgroundImage: NetworkImage('https://i.pinimg.com/originals/2b/6f/48/2b6f48aa7e601558406b9c08420753c5.jpg'),
              ),
              SizedBox(width: phoneWidth/20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rafie Asadel Tarigan',
                    style: TextStyle(
                      fontSize: phoneWidth/25,
                      fontWeight: FontWeight.bold,
                      shadows: List.generate(5, 
                        (index) {
                          return Shadow(
                            color: Theme.of(context).colorScheme.background.withOpacity(0.75),
                            blurRadius: 10
                          );
                        }
                      )
                    ),
                    ),
                  Text(
                    'Lvl 121',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: phoneWidth/32.5,
                      fontWeight: FontWeight.bold,
                      shadows: List.generate(7, 
                        (index) {
                          return Shadow(
                            color: Theme.of(context).colorScheme.background.withOpacity(0.75),
                            blurRadius: 10
                          );
                        }
                      )
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: phoneWidth/50,)
        ],
      ),
    );
  }

  Widget settings() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth/70),
      child: ExpansionTile(
        title: Text(
          'SETTINGS',
          style: TextStyle(
            letterSpacing: phoneWidth/70,
            fontWeight: FontWeight.w900
          ),
        ),
        trailing: Icon(Icons.settings),
        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('DarkMode'),
            trailing: CupertinoSwitch(
              onChanged: (value) {
                Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
              },
              value: Provider.of<ThemeProvider>(context).isDarkMode,
            )
          )
        ],
      ),
    );
  }

  Widget userSummary() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth/70),
      child: ExpansionTile(
        title: Text(
          'YOUR SUMMARY',
          style: TextStyle(
            letterSpacing: phoneWidth/80,
            fontWeight: FontWeight.w900
          ),
        ),
        trailing: Icon(Icons.poll),
        iconColor: Colors.white,
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        children: [
          
        ],
      ),
    );
  }


  Widget friendList() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth/70),
      child: ExpansionTile(
        title: Text(
          'FRIENDS',
          style: TextStyle(
            letterSpacing: phoneWidth/80,
            fontWeight: FontWeight.w900
          ),
        ),
        trailing: Icon(Icons.group),
        iconColor: Colors.white,
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        children: [
        ],
      ),
    );
  }
}