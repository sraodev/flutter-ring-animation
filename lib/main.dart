import 'package:flutter/material.dart';
import 'widget_ring_animator.dart';
import 'package:avatar_glow/avatar_glow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xFF0B0C0B),
          body: Stack(
            children: <Widget>[
              Center(
                  child: WidgetRingAnimator(
                    size: 120,
                    ringIcons: const [
                      'assets/store.png',
                      'assets/product.png',
                      'assets/cart.png',
                      'assets/rupee.png',
                      'assets/delivery.png',
                    ],
                    ringIconsSize: 3,
                    ringIconsColor: Colors.grey[200],
                    ringAnimation: Curves.linear,
                    ringColor: Colors.green,
                    reverse: false,
                    ringAnimationInSeconds: 10,
                    child: Container(
                      child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'assets/app_logo.png',
                            color: Colors.green,
                            height: 65,
                          ),
                          radius: 45.0,
                        ),
                      ),
                    ),
                  )
              ),
              Center(
                child: AvatarGlow(
                  glowColor: Colors.lightGreen,
                  endRadius: 200.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        'assets/app_logo.png',
                        color: Colors.green,
                        height: 65,
                      ),
                      radius: 45.0,
                    ),
                  ),
                ),
              ),

            ],
          )),
    );
  }
}
