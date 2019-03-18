import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_flutter/fetch_data/item.dart';
import 'package:http/http.dart' as http;

class MainFetchData extends StatefulWidget {
  String url;

  MainFetchData(String url) {
    this.url = url;
  }

  @override
  _MainFetchDataState createState() => _MainFetchDataState(url);
}

class _MainFetchDataState extends State<MainFetchData> {
  List<Item> list = List();
  var isLoading = false;
  String url;

  _MainFetchDataState(String url) {
    this.url = url;
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      list = (json.decode(response.body.toString())['articles'] as List)
          .map((data) => new Item.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MainCollapsingToolbar(item: list[index]),
                        ),
                      );
                    },
                    child: new Card(
                      child: new Column(
                        children: <Widget>[
                          new Image.network(null != list[index].image
                              ? list[index].image
                              : 'https://imgplaceholder.com/420x320/d5f9fa/757575/glyphicon-book?text=_none_'),
                          new Padding(
                              padding: new EdgeInsets.all(7.0),
                              child: new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.all(8.0),
                                    child: new Icon(Icons.bookmark_border,
                                        color: Colors.blue),
                                  ),
                                  new Flexible(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(list[index].title,
                                            style: new TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87))
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                }));
  }
}

class MainCollapsingToolbar extends StatelessWidget {
  final Item item;

  MainCollapsingToolbar({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                      null != item.author
                          ? "Author: " + item.author
                          : "Author: Unknown",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      )),
                  background: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: new Padding(
          padding: new EdgeInsets.all(8.0),
          child:
              new Text(item.description * 10, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
