import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_flutter/fetch_data/item.dart';
import 'package:http/http.dart' as http;

class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<MainFetchData> {
  List<Item> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("https://newsapi.org/v2/everything?q=samsung&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf");
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
                  return ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: new Text(list[index].title),
                    trailing: new Image.network(
                      null != list[index].image ? list[index].image : 'https://imgplaceholder.com/420x320/d5f9fa/757575/glyphicon-book?text=_none_',
                      fit: BoxFit.cover,
                      height: 40.0,
                      width: 40.0,
                    ),
                  );
                }));
  }
}
