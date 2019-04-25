import 'package:news_app_flutter/fetch_data/main_fetch_data.dart';
import 'package:news_app_flutter/database/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class FavoriteFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FavoriteFragmentState();
}

class FavoriteFragmentState extends State<FavoriteFragment> {
  var item;
  var list = List();
  var isLoading = false;
  bool connectivity = true;
  var db = new DatabaseHelper();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    await db.getNews("fav").then((list) => this.list = list);
    if (list.length > 0) {
      Fluttertoast.showToast(
          msg: "  Favorite News  ", backgroundColor: Colors.blue);
    } else {
      Fluttertoast.showToast(
          msg: "  No Favorite News  ", backgroundColor: Colors.blue);
    }
    setState(() {
      isLoading = false;
    });
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
                        builder: (context) => MainCollapsingToolbar(
                              item: list[index],
                              connectivity: connectivity,
                              tableName: "fav",
                            ),
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
                              ? NetworkImage(list[index].image)
                              : AssetImage('assets/news_placeholder.jpg'),
                        ),
                        new Padding(
                            padding: new EdgeInsets.all(7.0),
                            child: new Row(
                              children: <Widget>[
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    child: new Icon(Icons.favorite,
                                        color: Colors.blue),
                                    onTap: () => {
                                          db.deleteNews(list[index], "fav"),
                                          initState()
                                        },
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
    );
  }
}
