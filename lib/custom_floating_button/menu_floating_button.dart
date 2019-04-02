import 'package:news_app_flutter/database/database_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:news_app_flutter/database/news.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class MenuFloatingButton extends StatefulWidget {
  var item;

  @override
  MenuFloatingButtonState createState() => new MenuFloatingButtonState(item);

  MenuFloatingButton({Key key, @required this.item}) : super(key: key);
}

class MenuFloatingButtonState extends State<MenuFloatingButton>
    with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;

  var db = new DatabaseHelper();
  var item;
  int _angle = 90;
  bool _isRotated = true;

  MenuFloatingButtonState(var item) {
    this.item = item;
  }

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller.reverse();
    super.initState();
  }

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  Future addRecord() async {
    String _base64;
    http.Response response = await http.get(
      item.image,
    );
    if (mounted) {
      setState(() {
        _base64 = base64.encode(response.bodyBytes);
      });
    }

    var news = new News(item.title, _base64, item.description, item.author);
    db.updateNews(news);
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      new Positioned(
          bottom: 200.0,
          right: 24.0,
          child: new ScaleTransition(
            scale: _animation3,
            alignment: FractionalOffset.center,
            child: new Material(
                color: Colors.white,
                type: MaterialType.circle,
                elevation: 10.0,
                child: new GestureDetector(
                  child: new Container(
                      width: 40.0,
                      height: 40.0,
                      child: new InkWell(
                        onTap: () {
                          if (_angle == 45.0) {
                            addRecord();
                            Fluttertoast.showToast(msg: "  Saved  ", backgroundColor: Colors.blue);
                          }
                        },
                        child: new Center(
                          child: new Icon(
                            Icons.save,
                            color: Colors.blue,
                          ),
                        ),
                      )),
                )),
          )),
      new Positioned(
          bottom: 144.0,
          right: 24.0,
          child: new ScaleTransition(
            scale: _animation2,
            alignment: FractionalOffset.center,
            child: new Material(
                color: Colors.white,
                type: MaterialType.circle,
                elevation: 10.0,
                child: new GestureDetector(
                  child: new Container(
                      width: 40.0,
                      height: 40.0,
                      child: new InkWell(
                        onTap: () {
                          if (_angle == 45.0) {
                            showWebView(context);
                            Fluttertoast.showToast(msg: "  Source page  ", backgroundColor: Colors.blue);
                          }
                        },
                        child: new Center(
                          child: new Icon(
                            Icons.open_in_browser,
                            color: Colors.blue,
                          ),
                        ),
                      )),
                )),
          )),
      new Positioned(
        bottom: 88.0,
        right: 24.0,
        child: new ScaleTransition(
          scale: _animation,
          alignment: FractionalOffset.center,
          child: new Material(
              color: Colors.white,
              type: MaterialType.circle,
              elevation: 10.0,
              child: new GestureDetector(
                child: new Container(
                    width: 40.0,
                    height: 40.0,
                    child: new InkWell(
                      onTap: () {
                        if (_angle == 45.0) {
                        }
                      },
                      child: new Center(
                        child: new Icon(
                          Icons.favorite,
                          color: Colors.blue,
                        ),
                      ),
                    )),
              )),
        ),
      ),
      new Positioned(
        bottom: 16.0,
        right: 16.0,
        child: new Material(
            color: Colors.blue,
            type: MaterialType.circle,
            elevation: 10.0,
            child: new GestureDetector(
              child: new Container(
                  width: 56.0,
                  height: 56.00,
                  child: new InkWell(
                    onTap: _rotate,
                    child: new Center(
                        child: new RotationTransition(
                      turns: new AlwaysStoppedAnimation(_angle / 360),
                      child: new Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
                  )),
            )),
      ),
    ]);
  }

  void showWebView(BuildContext context) {
    var webView = WebView(
      initialUrl: item.url,
      javascriptMode: JavascriptMode.unrestricted,
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return webView;
        });
  }
}
