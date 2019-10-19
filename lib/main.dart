import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: FancyBackgroundApp())));
}

/*
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  @override
  Widget build(BuildContext context) {
    double h =MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Icon(MdiIcons.food),
          ),
          body: Center(
            child: Container(margin: EdgeInsets.all(50.0),height: h/2,decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0),color: Colors.cyan),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(backgroundColor: Colors.cyanAccent),
                        prefixIcon: Icon(MdiIcons.emailBox),
                        hintText: 'Enter your email'),
                    autofocus: true,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                  ),SizedBox(height: 30.0,),TextField(
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(backgroundColor: Colors.cyanAccent),
                        prefixIcon: Icon(MdiIcons.textboxPassword),
                        hintText: 'Enter your email'),
                    autofocus: true,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                  )
                ],
              ),
            ),
          )),
    );
  }
}*/
class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}

class AnimatedWave extends StatelessWidget {
  //const AnimatedWave({Key key}) : super(key: key);
  final double height;
  final double speed;
  final double offset;

  const AnimatedWave({Key key, this.height, this.speed, this.offset = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          width: constraints.biggest.width,
          child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            },
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startingPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startingPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class FancyBackgroundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: AnimatedBackground()),
        onBottom(AnimatedWave(
          height: 180,
          speed: 1.0,
        )),
        onBottom(AnimatedWave(
          height: 120,
          speed: 0.9,
          offset: pi,
        )),
        onBottom(AnimatedWave(
          height: 220,
          speed: 1.2,
          offset: pi / 2,
        )),
        Positioned.fill(
            child: Center(
          child: PageContent(),
        )),
      ],
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

class PageContent extends StatefulWidget {
  PageContent({Key key}) : super(key: key);

  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            scrollPadding: EdgeInsets.all(10.0),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.pink,
                ),
                hintText: 'Enter your email'),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              labelText: 'Password',
              prefixIcon: Icon(
                MdiIcons.textboxPassword,
                color: Colors.redAccent,
              ),
            ),
          ),SizedBox(height: 50.0,),
          RaisedButton(elevation: 90.0,
            child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
