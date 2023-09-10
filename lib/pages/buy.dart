import 'dart:convert';

import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/books.dart';
import 'package:book/models/order.dart';
import 'package:book/models/users.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

class Buy extends StatefulWidget {
  static const routeName = '/buy';
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  Orders order = Orders();
  final _formkey = GlobalKey<FormState>();
  Users user = Config.login;
  Future<void> addOrder(Orders order, Books book) async {
    order.bid = book.bid;
    order.userid = user.id;
    order.total = (order.qty)! * (book.price)!;
    order.bname = book.bname;
    order.image = book.imageurl;
    order.price = book.price;
    var url = Uri.http(Config.server, 'orders');
    var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(order.toJson()));
    print(res.body);
    var rs = ordersFromJson('[${res.body}]');
    if (rs.length == 1) {
      Navigator.pop(context, 'refresh');
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    Books book = ModalRoute.of(context)!.settings.arguments as Books;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: '#E72913'.toColor(),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        backgroundColor: '#F4F4F4'.toColor(),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl: '${book.imageurl}',
                              placeholder: (context, url) => SizedBox(
                                width: 50,
                                height: 50,
                                child: LoadingIndicator(
                                    indicatorType: Indicator.ballPulse,
                                    colors: ['#E72913'.toColor()],
                                    strokeWidth: 2,
                                    backgroundColor: Colors.white,
                                    pathBackgroundColor: Colors.black),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${book.bname}',
                                style: GoogleFonts.kanit(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Quantity',
                                  style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              qty(),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Price',
                                      style: GoogleFonts.kanit(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.57,
                                  ),
                                  Text(
                                    '\$ ${book.price}',
                                    style: GoogleFonts.kanit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: buy(book))
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget qty() {
    return TextFormField(
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          order.qty = int.tryParse(newValue);
        }
      },
      maxLength: 3,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Quantity',
        hintText: 'Your Quantity',
        hintStyle: GoogleFonts.kanit(),
        labelStyle: GoogleFonts.kanit(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: '#E72913'.toColor(), width: 1.5)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่ Quantity';
        }
        return null;
      },
    );
  }

  Widget buy(Books book) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: '#E72913'.toColor()),
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            addOrder(order, book);
          }
        },
        child: Text(
          'BUY',
          style: GoogleFonts.kanit(),
        ));
  }
}
