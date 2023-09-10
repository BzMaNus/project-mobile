// To parse this JSON data, do
//
//     final books = booksFromJson(jsonString);

import 'dart:convert';

List<Books> booksFromJson(String str) =>
    List<Books>.from(json.decode(str).map((x) => Books.fromJson(x)));

String booksToJson(List<Books> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Books {
  int? bid;
  String? bname;
  String? author;
  String? category;
  int? price;
  String? imageurl;
  String? description;
  Rating? rating;

  Books({
    this.bid,
    this.bname,
    this.author,
    this.category,
    this.price,
    this.imageurl,
    this.description,
    this.rating,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        bid: json["bid"],
        bname: json["bname"],
        author: json["author"],
        category: json["category"],
        price: json["price"],
        imageurl: json["imageurl"],
        description: json["description"],
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "bid": bid,
        "bname": bname,
        "author": author,
        "category": category,
        "price": price,
        "imageurl": imageurl,
        "description": description,
        "rating": rating?.toJson(),
      };
}

class Rating {
  double? rate;
  int? count;

  Rating({
    this.rate,
    this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}
