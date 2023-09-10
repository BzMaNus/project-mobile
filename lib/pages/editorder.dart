import 'dart:convert';

import 'package:book/config.dart';
import 'package:book/extension.dart';

import 'package:book/models/order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

class Editorder extends StatefulWidget {
  const Editorder({super.key});

  @override
  State<Editorder> createState() => _EditorderState();
}

class _EditorderState extends State<Editorder> {
  Orders order = Orders();
  final _formkey = GlobalKey<FormState>();
  Future<void> updateOrder(Orders order) async {
    order.total = (order.price)! * (order.qty)!;
    var url = Uri.http(Config.server, 'orders/${order.id}');
    var res = await http.put(url,
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
    Orders order = ModalRoute.of(context)!.settings.arguments as Orders;

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
                              imageUrl: '${order.image}',
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
                                '${order.bname}',
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
                              qty(order),
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
                                    '\$ ${order.price}',
                                    style: GoogleFonts.kanit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: buy(order))
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

  Widget qty(Orders order) {
    return TextFormField(
      initialValue: order.qty.toString(),
      maxLength: 3,
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          order.qty = int.tryParse(newValue);
        }
      },
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

  Widget buy(Orders order) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: '#E72913'.toColor()),
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            updateOrder(order);
          }
        },
        child: Text(
          'SAVE',
          style: GoogleFonts.kanit(),
        ));
  }
}
