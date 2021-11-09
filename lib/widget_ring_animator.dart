import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetRingAnimator extends StatefulWidget {
  const WidgetRingAnimator({
    @required this.child,
    this.ringColor = Colors.deepOrange,
    this.ringAnimation = Curves.linear,
    this.ringAnimationInSeconds = 30,
    this.ringIconsSize = 3,
    this.size = 200,
    this.reverse = true,
    this.ringIcons,
    this.ringIconsColor = Colors.black
  }) : assert(child != null);

  final Color ringColor;
  final Curve ringAnimation;
  final int ringAnimationInSeconds;
  final List<String> ringIcons;
  final Color ringIconsColor;
  final double ringIconsSize;
  final double size;
  final Widget child;
  final bool reverse;

  @override
  _WidgetAnimatorState createState() => _WidgetAnimatorState();
}

class _WidgetAnimatorState extends State<WidgetRingAnimator>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  List<UI.Image> image = <UI.Image>[];

  @override
  void initState() {
    super.initState();
    initAnimations();
    initUiImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          _ringArc(),
          _child(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Center _child() {
    return Center(
      child: Container(
        width: widget.size * 0.7,
        height: widget.size * 0.7,
        child: widget.child,
      ),
    );
  }

  Center _ringArc() {
    return Center(
      child: RotationTransition(
        turns: animation,
        child: CustomPaint(
          painter: Arc2Painter(
              color: widget.ringColor,
              iconsSize: widget.ringIconsSize,
              image: image,
              imageColor: widget.ringIconsColor),
          child: Container(
            width: widget.size,
            height: widget.size,
          ),
        ),
      ),
    );
  }

  Future _loadUiImage(String imageAssetPath) async {
    final data = await rootBundle.load(imageAssetPath);
    final bytes = data.buffer.asUint8List();
    final decodeImage = await decodeImageFromList(bytes);
    image.add(decodeImage);

    setState(() {
      image = image;
    });
  }

  void initUiImages() async {
    for (var imageAssetPath in widget.ringIcons) {
      await _loadUiImage(imageAssetPath);
    }
  }

  void initAnimations() {
    controller = AnimationController(
        duration: Duration(seconds: widget.ringAnimationInSeconds),
        vsync: this);

    final _ringAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: widget.ringAnimation)));

    // reverse or same direction animation
    widget.reverse
        ? animation = ReverseAnimation(_ringAnimation)
        : animation = _ringAnimation;

    controller.repeat();
  }
}

class Arc2Painter extends CustomPainter {
  Arc2Painter({this.color, this.iconsSize = 3, this.image, this.imageColor});

  final Color color;
  final double iconsSize;
  final List<UI.Image> image;
  final Color imageColor;


  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final ColorFilter filter = ColorFilter.mode(imageColor, BlendMode.srcATop);

    num degreesToRads(num deg) {
      return deg * (pi / 180.0);
    }

    // draw the ring arcs with imagesIcons
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final noOfImages = image.length;
    final arcAngle = 360 / noOfImages;

    for (var i = 0; i < noOfImages; i++) {
      final radians = degreesToRads(i * arcAngle).toDouble();
      final Offset pointOnArc = Offset(
        radius * math.cos(radians) + center.dx,
        radius * math.sin(radians) + center.dy,
      );
      canvas.drawImage(
          image[i],
          pointOnArc + Offset(-(image[i].width / 2).toDouble(), -(image[i].height / 2).toDouble()),
          Paint()..colorFilter = filter);
      canvas.drawArc(
          rect,
          degreesToRads((i * arcAngle) + image[i].width / 2).toDouble(), //startAngle
          degreesToRads(arcAngle - image[i].width).toDouble(),  //sweepAngle
          false, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}