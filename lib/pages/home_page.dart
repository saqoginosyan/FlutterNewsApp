import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:news_app_flutter/fragments/categories_fragment.dart';
import 'package:news_app_flutter/fragments/favorite_fragment.dart';
import 'package:news_app_flutter/fragments/profile_fragment.dart';
import 'package:news_app_flutter/fragments/info_fragment.dart';
import 'package:news_app_flutter/fragments/settings_fragment.dart';
import 'package:news_app_flutter/fetch_data/main_fetch_data.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  var drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Categories", Icons.category),
    new DrawerItem("Favorite", Icons.bookmark_border),
    new DrawerItem("Profile", Icons.face),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Info", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  File _image;

  Future getImageCamera() async {
    var image;

    image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageGallery() async {
    var image;

    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new MainFetchData(
            "https://newsapi.org/v2/everything?q=daily&apiKey=d9df3e32fcfb4dc880ec8cc179b924cf");
      case 1:
        return new Categories();
      case 2:
        return new FavoriteFragment();
      case 3:
        return new ProfileFragment();
      case 4:
        return new SettingsFragment();
      case 5:
        return new InfoFragment();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName:
                  new Text("Flutter News", style: TextStyle(fontSize: 25)),
              accountEmail: null,
              currentAccountPicture: new GestureDetector(
                child: _image == null
                    ? Image.asset('assets/add.ico')
                    : Image.file(_image),
                onTap: getImageCamera,
              ),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.blueGrey, Colors.lightBlueAccent]),
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
