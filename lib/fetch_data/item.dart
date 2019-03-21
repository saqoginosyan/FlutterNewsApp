class Item {
  final String title;
  final String image;
  final String description;
  final String author;
  final String url;

  Item._({this.title, this.image, this.description, this.author, this.url});

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item._(
        title: json['title'],
        image: json['urlToImage'],
        description: json['description'],
        author: json['author'],
        url: json['url']);
  }
}
