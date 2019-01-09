import 'dart:async';

import 'package:flutter/material.dart';

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
  static const TIMEOUT = const Duration(seconds: 1);

  Timer holdTimer;

  AnimationController _firstImageController, _secondImageController;

  @override
  initState() {
    super.initState();
    _firstImageController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _secondImageController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _firstImageController.stop();
    _secondImageController.stop();
    super.dispose();
  }

  Future<void> _playAnimation(int index) async {
    try {
      index == 0
          ? await _firstImageController.forward().orCancel
          : await _secondImageController.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Widget _buildIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => _playAnimation(0),
            child: StaggerAnimation(
              controller: _firstImageController.view,
              index: 0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => _playAnimation(1),
            child: StaggerAnimation(
              controller: _secondImageController.view,
              index: 1,
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
                _buildIcons(),
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
                  valueColor: ColorTween(begin: Colors.green)
                      .animate(_firstImageController),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
