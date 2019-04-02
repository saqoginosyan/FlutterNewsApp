import 'dart:typed_data';

import 'package:news_app_flutter/custom_floating_button/menu_floating_button.dart';
import 'package:news_app_flutter/database/database_helper.dart';
import 'package:news_app_flutter/fetch_data/item.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class MainFetchData extends StatefulWidget {
  String url;
  String mainUrl;

  MainFetchData(String url) {
    this.url = url;
    this.mainUrl = url;
  }

  @override
  _MainFetchDataState createState() => _MainFetchDataState(url);
}

class _MainFetchDataState extends State<MainFetchData> {
  ScrollController _controller;
  var list = List();
  var isLoading = false;
  var db = new DatabaseHelper();
  var result;
  String url;
  String mainUrl;
  String message = "";
  int page = 1;
  bool connectivity = false;
  final maxPageSize = 50;

  _MainFetchDataState(String url) {
    this.url = url;
    this.mainUrl = url;
  }

  _scrollListener() async {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      ++page;
      if (maxPageSize == page) {
        return;
      }
      url = mainUrl + "&page=${page.toString()}";
      final response = await http.get(url);
      if (response.statusCode == 200) {
        list.addAll((json.decode(response.body.toString())['articles'] as List)
            .map((data) => new Item.fromJson(data))
            .toList());
        setState(() {});
      } else {
        throw Exception('Failed to load photos');
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      await db.getNews().then((list) => this.list = list);
      if (list.length > 0) {
        Fluttertoast.showToast(
            msg: "  Saved News  ", backgroundColor: Colors.blue);
      } else {
        Fluttertoast.showToast(
            msg: "  No Saved News  ", backgroundColor: Colors.blue);
      }
      connectivity = true;
    } else {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        list.addAll((json.decode(response.body.toString())['articles'] as List)
            .map((data) => new Item.fromJson(data))
            .toList());
      } else {
        throw Exception('Failed to load photos');
      }
      connectivity = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  ImageProvider _setImage(var image) {
    ImageProvider imageProvider;
    if (result == ConnectivityResult.none) {
      Uint8List bytes = base64.decode(image);
      imageProvider = MemoryImage(bytes);
    } else {
      imageProvider = NetworkImage(image);
    }
    return imageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _controller,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainCollapsingToolbar(
                                item: list[index], connectivity: connectivity),
                          ),
                        );
                      },
                      child: new Card(
                        child: new Column(
                          children: <Widget>[
                            new FadeInImage(
                              placeholder:
                                  AssetImage('assets/news_placeholder.jpg'),
                              image: null != list[index].image
                                  ? _setImage(list[index].image)
                                  : AssetImage('assets/news_placeholder.jpg'),
                            ),
                            new Padding(
                                padding: new EdgeInsets.all(7.0),
                                child: new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: new EdgeInsets.all(8.0),
                                      child: new GestureDetector(
                                        child: new Icon(Icons.bookmark_border,
                                            color: Colors.blue),
                                        onTap: _fetchData,
                                      ),
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
                  }),
          onRefresh:  _fetchData,
          color: Colors.white,
          backgroundColor: Colors.lightBlue),
    );
  }
}

class MainCollapsingToolbar extends StatelessWidget {
  var item;
  var result;
  bool connectivity;

  MainCollapsingToolbar(
      {Key key, @required this.item, @required this.connectivity})
      : super(key: key);

  Image _setImage(var image) {
    Image dbImage;

    if (connectivity) {
      Uint8List bytes = base64.decode(image);
      dbImage = Image.memory(bytes, fit: BoxFit.cover);
    } else {
      dbImage = Image.network(
        image,
        fit: BoxFit.cover,
      );
    }
    return dbImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
      children: <Widget>[
        new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                        null == item.author || item.author.isEmpty
                            ? "Author: Unknown"
                            : "Author: " + item.author,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        )),
                    background: _setImage(item.image)),
              ),
            ];
          },
          body: new Padding(
            padding: new EdgeInsets.all(8.0),
            child:
                new Text(item.description * 10, style: TextStyle(fontSize: 18)),
          ),
        ),
        new MenuFloatingButton(item: item),
      ],
    ));
  }
}
