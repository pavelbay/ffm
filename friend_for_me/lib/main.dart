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

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  static const int FIRST_CHOICE = 0;
  static const int SECOND_CHOICE = 1;
  int _animationIndex;

  int _counter = 0;

  AnimationController _controller, _scoreSizeAnimationController;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scoreSizeAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 150));
    _scoreSizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreSizeAnimationController.reverse();
      }
    });
    _scoreSizeAnimationController.addListener((){
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
    _animationIndex = choice;
    _scoreSizeAnimationController.forward(from: 0.0);
  }

  Widget _buildIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => _onChoice(FIRST_CHOICE),
            child: _buildImage(FIRST_CHOICE),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => _onChoice(SECOND_CHOICE),
            child: _buildImage(SECOND_CHOICE),
          ),
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
    final double extraSize = index == _animationIndex ? _scoreSizeAnimationController.value * 50 : 0.0;
    double height = 100.0 + extraSize;
    double width = 100.0 + extraSize;
    final String imagePath = '$IMAGE_ASSET_PATH/$assetName';
    return Image.asset(imagePath, height: height, width: width);
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
                  valueColor:
                      ColorTween(begin: Colors.green).animate(_controller),
                ),
              ),
            )
          ],
        ),
      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: new Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
