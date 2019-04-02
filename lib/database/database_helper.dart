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
        "CREATE TABLE News(id INTEGER PRIMARY KEY, title TEXT UNIQUE, image BLOB, description TEXT, author TEXT)");
  }

  Future<int> saveNews(News news) async {
    var dbClient = await db;
    int res = await dbClient.insert("News", news.toMap());
    return res;
  }

  Future<List<News>> getNews() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM News');
    List<News> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var news = new News(list[i]["title"], list[i]["image"],
          list[i]["description"], list[i]["author"]);
      news.setNewsId(list[i]["id"]);
      employees.add(news);
    }
    print(employees.length);
    return employees;
  }

  Future<int> deleteNews(News news) async {
    var dbClient = await db;
    int res =
        await dbClient.rawDelete('DELETE FROM News WHERE id = ?', [news.id]);
    return res;
  }

  Future<bool> update(News news) async {
    var dbClient = await db;
    int res = await dbClient.update("News", news.toMap(),
        where: "id = ?", whereArgs: <int>[news.id]);
    return res > 0 ? true : false;
  }

  Future updateNews(News news) async {
    var dbClient = await db;
    print(dbClient);

    await dbClient.rawInsert(
        'INSERT OR REPLACE INTO News (title, image, description, author)'
        ' VALUES("${news.title}", "${news.image}", "${news.description}", "${news.author}")');
  }
}
