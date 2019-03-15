import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CategoriesState();
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new DefaultTabController(
        length: 10,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: new Container(
              color: Colors.lightBlue,
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      tabs: [new Text("Sport"), new Text("Food"), new Text("People"), new Text("Tech") ],
                    ),
                  ],
                ),
              ),
          ),
          body: new TabBarView(
            children: <Widget>[
              new Column(
                children: <Widget>[new Text("Sport Page")],
              ),
              new Column(
                children: <Widget>[new Text("Food Page")],
              ),
              new Column(
                children: <Widget>[new Text("People Page")],
              ),
              new Column(
                children: <Widget>[new Text("Tech Page")],
              )
            ],
          ),
        ),
      ),
    );
  }
}