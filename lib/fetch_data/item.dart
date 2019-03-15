class Item {
  final String title;
  final String image;

  Item._({this.title, this.image});

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item._(
      title: json['title'],
      image: json['urlToImage'],
    );
  }
}
