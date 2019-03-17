import 'package:flutter/material.dart';
import 'package:news_app_flutter/fetch_data/main_fetch_data.dart';

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
                    tabs: [
                      new Text("Sport"),
                      new Text("Food"),
                      new Text("Politics"),
                      new Text("Tech")
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: new TabBarView(
            children: [
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=sport&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf"),
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=Food&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf"),
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=Politics&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf"),
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=Tech&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf"),
            ],
          ),
        ),
      ),
    );
  }
}
