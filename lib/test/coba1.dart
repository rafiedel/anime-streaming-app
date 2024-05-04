import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wavy Background Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wavy Background Example'),
        ),
        body: WavyBackground(),
      ),
    );
  }
}

class WavyBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        color: Colors.blue, // Background color
        height: 500,
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from the top-left corner
    path.lineTo(0, size.height * 0.8);

    // Define the bezier curve for the wave
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    // Line to the bottom-right corner
    path.lineTo(size.width, size.height);

    // Line to the bottom-left corner
    path.lineTo(size.width, 0);

    // Line to close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
