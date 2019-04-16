import 'package:news_app_flutter/fetch_data/main_fetch_data.dart';
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
                  "https://newsapi.org/v2/everything?q=sport&apiKey=364601550a0348a5818d66050fecdead"),
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=Food&apiKey=364601550a0348a5818d66050fecdead"),
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=Politics&apiKey=364601550a0348a5818d66050fecdead"),
              MainFetchData(
                  "https://newsapi.org/v2/everything?q=Tech&apiKey=364601550a0348a5818d66050fecdead"),
            ],
          ),
        ),
      ),
    );
  }
}
