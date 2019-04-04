class News {

  int id;
  String _title;
  String _image;
  String _description;
  String _author;
  String _url;

  News(this._title, this._image, this._description, this._author, this._url);

  News.map(dynamic obj) {
    this._title = obj["title"];
    this._image = obj["image"];
    this._description = obj["description"];
    this._author = obj["author"];
    this._url = obj["url"];
  }

  String get title => _title;

  String get image => _image;

  String get description => _description;

  String get author => _author;

  String get url => _url;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["title"] = _title;
    map["image"] = _image;
    map["description"] = _description;
    map["author"] = _author;
    map["url"] = _url;
    return map;
  }
  void setNewsId(int id) {
    this.id = id;
  }
}