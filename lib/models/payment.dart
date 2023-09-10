// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

List<Payment> paymentFromJson(String str) =>
    List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));

String paymentToJson(List<Payment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payment {
  int? id;
  int? userid;
  int? cardNum;
  int? exp;
  int? cvc;
  String? name;
  String? address;
  String? city;
  String? province;
  String? country;
  int? zipCode;

  Payment({
    this.id,
    this.userid,
    this.cardNum,
    this.exp,
    this.cvc,
    this.name,
    this.address,
    this.city,
    this.province,
    this.country,
    this.zipCode,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        userid: json["userid"],
        cardNum: json["cardNum"],
        exp: json["exp"],
        cvc: json["cvc"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        province: json["province"],
        country: json["country"],
        zipCode: json["zipCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "cardNum": cardNum,
        "exp": exp,
        "cvc": cvc,
        "name": name,
        "address": address,
        "city": city,
        "province": province,
        "country": country,
        "zipCode": zipCode,
      };
}
