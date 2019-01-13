import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'animation.dart';

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
  static const ANIM_DURATION = const Duration(seconds: 1);
  int _progress = 0;
  Timer holdTimer;

  AnimationController _firstImageController, _secondImageController;

  @override
  initState() {
    super.initState();
    _firstImageController =
        AnimationController(duration: ANIM_DURATION, vsync: this)
          ..addStatusListener(animationListener);
    _secondImageController =
        new AnimationController(vsync: this, duration: ANIM_DURATION)
          ..addStatusListener(animationListener);
  }

  void animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _firstImageController.reset();
        _secondImageController.reset();
      });
    }
  }

  @override
  void dispose() {
    _firstImageController.stop();
    _secondImageController.stop();
    super.dispose();
  }

  Future<void> _playAnimation(int index) async {
    _progress++;
    try {
      index == 0
          ? await _firstImageController.forward().orCancel
          : await _secondImageController.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Widget _buildIcons() {
    int firstIndex = 0;
    int secondIndex = 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => _playAnimation(firstIndex),
            child: StaggerAnimation(
              controller: _firstImageController.view,
              index: firstIndex,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => _playAnimation(secondIndex),
            child: StaggerAnimation(
              controller: _secondImageController.view,
              index: secondIndex,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title),
//      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
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
                _buildIcons(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearPercentIndicator(
                  lineHeight: 20,
                  width: 350,
                  animateFromLastPercent: true,
                  animation: true,
                  backgroundColor: Colors.amberAccent,
                  percent: _progress * 10 / 100,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
