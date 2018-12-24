import 'dart:async';

import 'package:flutter/material.dart';

const IMAGE_ASSET_PATH = 'graphics';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FFM',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Friend for me!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const int FIRST_CHOICE = 0;
  static const int SECOND_CHOICE = 1;
  static const TIMEOUT = const Duration(seconds: 1);
  static const ANIMATION_DURATION = const Duration(milliseconds: 150);
  Timer holdTimer;

  int _animationIndex;
  int _counter = 0;

  AnimationController _controller,
      _imageSizeAnimationController,
      _positionAnimationController;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _imageSizeAnimationController =
        new AnimationController(vsync: this, duration: ANIMATION_DURATION);
    _imageSizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        holdTimer = Timer(TIMEOUT, () {
//          _imageSizeAnimationController.reverse();
          _positionAnimationController.forward();
        });
      }
    });
    _positionAnimationController =
        AnimationController(vsync: this, duration: ANIMATION_DURATION);
    _positionAnimationController.addListener(() {
      setState(() {});
    });
    _imageSizeAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onChoice(int choice) {
    if (holdTimer == null || !holdTimer.isActive) {
      _animationIndex = choice;
      _imageSizeAnimationController.forward(from: 0.0);
    }
  }

  Widget _buildIcons() {
    return Stack(
      alignment: FractionalOffset.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _onChoice(FIRST_CHOICE),
          child: _buildContainer(FIRST_CHOICE),
        ),
        GestureDetector(
          onTap: () => _onChoice(SECOND_CHOICE),
          child: _buildContainer(SECOND_CHOICE),
        )
      ],
    );
  }

  Widget _buildImage(int index) {
    String assetName;
    if (index == FIRST_CHOICE) {
      assetName = 'clouds.webp';
    } else if (index == SECOND_CHOICE) {
      assetName = 'sun.webp';
    }
    final String imagePath = '$IMAGE_ASSET_PATH/$assetName';
    return Image.asset(imagePath);
  }

  Widget _buildContainer(int index) {
    final double size = 100.0;
    final double animationValue = _imageSizeAnimationController.value / 3.0;
    final double factor =
        index == _animationIndex ? 1 + animationValue : 1 - animationValue;
    return new Positioned(
        width: size,
        height: size,
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()..scale(1.0 * factor, 1.0 * factor),
          child: _buildImage(index),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title),
//      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text(
                    'Weather',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.blueGrey),
                  ),
                ),
//                _buildIcons(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(10.0))),
                child: LinearProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.amberAccent,
                  valueColor:
                      ColorTween(begin: Colors.green).animate(_controller),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
