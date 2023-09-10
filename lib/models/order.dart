// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

List<Orders> ordersFromJson(String str) =>
    List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));

String ordersToJson(List<Orders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
  int? id;
  int? bid;
  int? userid;
  int? qty;
  int? total;
  String? image;
  String? bname;
  int? price;

  Orders({
    this.id,
    this.bid,
    this.userid,
    this.qty,
    this.total,
    this.image,
    this.bname,
    this.price,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        id: json["id"],
        bid: json["bid"],
        userid: json["userid"],
        qty: json["qty"],
        total: json["total"],
        image: json["image"],
        bname: json["bname"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bid": bid,
        "userid": userid,
        "qty": qty,
        "total": total,
        "image": image,
        "bname": bname,
        "price": price,
      };
}
