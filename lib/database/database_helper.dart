import 'package:news_app_flutter/database/news.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;
  String newsTable = "news";
  String favTable = "fav";

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE News(id INTEGER PRIMARY KEY, title TEXT UNIQUE, image BLOB, description TEXT, author TEXT, url TEXT)");
    await db.execute(
        "CREATE TABLE Favorite(id INTEGER PRIMARY KEY, title TEXT UNIQUE, image TEXT, description TEXT, author TEXT, url TEXT)");
  }

  Future<int> saveNews(News news, String tableName) async {
    var dbClient = await db;
    int res;
    if (newsTable == tableName) {
      res = await dbClient.insert("News", news.toMap());
    } else if (favTable == tableName) {
      res = await dbClient.insert("Favorite", news.toMap());
    }
    return res;
  }

  Future<List<News>> getNews(String tableName) async {
    var dbClient = await db;
    List<Map> list;
    if (newsTable == tableName) {
      list = await dbClient.rawQuery('SELECT * FROM News');
    } else if (favTable == tableName) {
      list = await dbClient.rawQuery('SELECT * FROM Favorite');
    }
    List<News> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var news = new News(list[i]["title"], list[i]["image"],
          list[i]["description"], list[i]["author"], list[i]["url"]);
      news.setNewsId(list[i]["id"]);
      employees.add(news);
    }
    print(employees.length);
    return employees;
  }

  Future<int> deleteNews(News news, String tableName) async {
    var dbClient = await db;
    int res;
    if (newsTable == tableName) {
      res =
          await dbClient.rawDelete('DELETE FROM News WHERE id = ?', [news.id]);
    } else if (favTable == tableName) {
      res = await dbClient
          .rawDelete('DELETE FROM Favorite WHERE id = ?', [news.id]);
    }
    return res;
  }

  Future<bool> update(News news, String tableName) async {
    var dbClient = await db;
    int res;
    if (newsTable == tableName) {
      res = await dbClient.update("News", news.toMap(),
          where: "id = ?", whereArgs: <int>[news.id]);
    } else if (favTable == tableName) {
      res = await dbClient.update("Favorite", news.toMap(),
          where: "id = ?", whereArgs: <int>[news.id]);
    }
    return res > 0 ? true : false;
  }

  Future updateNews(News news, String tableName) async {
    var dbClient = await db;
    print(dbClient);

    if (newsTable == tableName) {
      await dbClient.rawInsert(
          'INSERT OR REPLACE INTO News (title, image, description, author, url)'
          ' VALUES("${news.title}", "${news.image}", "${news.description}", "${news.author}", "${news.url}")');
    } else if (favTable == tableName) {
      await dbClient.rawInsert(
          'INSERT OR REPLACE INTO Favorite (title, image, description, author, url)'
          ' VALUES("${news.title}", "${news.image}", "${news.description}", "${news.author}", "${news.url}")');
    }
  }
}
