import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirstFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FirstFragmentState();
  }
}

class FirstFragmentState extends State<FirstFragment> {
  var data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "https://newsapi.org/v2/everything?q=bitcoin&from=2019-02-14&sortBy=publishedAt&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf"),
        headers: {"Content-Type": "application/json"});

    this.setState(() {
      data = json.decode(response.body.toString())['articles'];
    });
    print(data);

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          //if (null != data[index]['urlToImage']) {
            return Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                null != data[index]['urlToImage'] ? data[index]['urlToImage'] : 'https://imgplaceholder.com/420x320/d5f9fa/757575/glyphicon-book?text=_none_',
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            );
         // } else {
//            return Card(
//              semanticContainer: true,
//              clipBehavior: Clip.antiAliasWithSaveLayer,
//              child: Image.network(
//                'https://picsum.photos/420/320?image=0',
//                fit: BoxFit.fill,
//              ),
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10.0),
//              ),
//              elevation: 5,
//              margin: EdgeInsets.all(10),
//            );
         // }
        },
      ),
    );
  }
}
