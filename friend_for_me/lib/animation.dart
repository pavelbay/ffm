import 'package:flutter/material.dart';

const IMAGE_ASSET_PATH = 'graphics';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller, this.index})
      :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.
        opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.7,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.200,
              curve: Curves.ease,
            ),
          ),
        ),
        xTranslation = Tween<double>(
          begin: 0.0,
          end: 120.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.550,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        yTranslation = Tween<double>(begin: 0.0, end: 200.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.750,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Colors.indigo[100],
          end: Colors.orange[400],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.500,
              0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  static const int FIRST_CHOICE = 0;
  static const int SECOND_CHOICE = 1;

  final Animation<double> controller;
  final Animation<double> scale;
  final Animation<double> xTranslation;
  final Animation<double> yTranslation;
  final Animation<double> opacity;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  final int index;

  Widget _buildImage() {
    String assetName;
    if (index == FIRST_CHOICE) {
      assetName = 'clouds.webp';
    } else if (index == SECOND_CHOICE) {
      assetName = 'sun.webp';
    }
    final String imagePath = '$IMAGE_ASSET_PATH/$assetName';
    return Image.asset(imagePath);
  }

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
//  Widget _buildAnimation(BuildContext context, Widget child) {
//    return Container(
//      padding: padding.value,
//      alignment: Alignment.bottomCenter,
//      child: Opacity(
//        opacity: opacity.value,
//        child: Container(
//          width: width.value,
//          height: height.value,
//          decoration: BoxDecoration(
//            color: color.value,
//            border: Border.all(
//              color: Colors.indigo[300],
//              width: 3.0,
//            ),
//            borderRadius: borderRadius.value,
//          ),
//        ),
//      ),
//    );
//  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    final double size = 100.0;
    return Opacity(
      opacity: opacity.value,
      child: Container(
          alignment: new FractionalOffset(0.5, 0.5),
          width: size,
          height: size,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..scale(1.0 + 0.5 * scale.value, 1.0 + 0.5 * scale.value)
              ..setTranslationRaw(
                  0.0 - xTranslation.value, 0.0 + yTranslation.value, 0.0),
            child: _buildImage(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
