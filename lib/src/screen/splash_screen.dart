import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
                child: Image(
                  image: const AssetImage('assets/images/logo.png'),
                  color: Theme.of(context).colorScheme.primary,
                  width: 104 * scaleFactor,
                  height: 94 * scaleFactor,
                ))));
  }
}
