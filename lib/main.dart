import 'package:news_app_flutter/services/authentication.dart';
import 'package:news_app_flutter/pages/root_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          'Flutter News',
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35.0),
        ),
        image: new Image.asset('assets/newspaper.png'),
        backgroundColor: Colors.lightBlueAccent,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 50.0,
        loaderColor: Colors.white);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new RootPage(auth: new Auth()),
    );
  }
}
