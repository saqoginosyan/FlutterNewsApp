import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Material(
        child: new Center(
          child: new Text("HOME"),
        ),
      ),
    );
  }
}
