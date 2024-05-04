import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const cobaApp()
  );
}

class cobaApp extends StatelessWidget {
  const cobaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: SwiperCoba(),
    );
  }
}

class SwiperCoba extends StatelessWidget {
  const SwiperCoba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SwipeTile()
          ],
        ),
      ),
    );
  }
}


class SwipeTile extends StatelessWidget {
  const SwipeTile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Adjust the height as per your requirement
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: Swiper(
          itemWidth: 400,
          itemHeight: 225,
          duration: 1200,
          loop: false,
          customLayoutOption: CustomLayoutOption(
            startIndex: 0,
          ),
          viewportFraction: 0.8,
          scale: 0.9,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              width: 400,
              height: 225,
              margin: EdgeInsets.all(10), // Add margin for spacing between items
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                color: Colors.grey.shade900,
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Item $index',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
