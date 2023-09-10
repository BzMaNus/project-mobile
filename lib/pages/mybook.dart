import 'dart:async';

import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/order.dart';
import 'package:book/models/users.dart';
import 'package:book/pages/editorder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      setState(() {
        getOrdes();
        isLoading = false;
      });
    });
  }

  List<Orders> _order = [];
  Users user = Config.login;
  Future<void> getOrdes() async {
    var params = {
      "userid": {user.id.toString()}
    };
    var url = Uri.http(Config.server, "orders", params);
    var res = await http.get(url);

    setState(() {
      _order = ordersFromJson(res.body);
    });

    return;
  }

  Future<void> remove(id) async {
    var url = Uri.http(Config.server, "orders/$id");
    var res = await http.delete(url);

    setState(() {
      Navigator.pop(context);
      getOrdes();
      print(res);
      isLoading = false;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Image.asset(
            'assets/images/BookDD-removebg-preview.png',
            width: 90,
            height: 150,
            fit: BoxFit.cover,
          ),
          backgroundColor: '#E72913'.toColor(),
        ),
        backgroundColor: '#F4F4F4'.toColor(),
        body: isLoading ? Loading() : myBook());
  }

  Widget Loading() {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: ['#E72913'.toColor()],
          strokeWidth: 2,
          backgroundColor: '#F4F4F4'.toColor(),
          pathBackgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget myBook() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _order.length,
        itemBuilder: (context, index) {
          Orders order = _order[index];
          return InkWell(
            onTap: () async {
              String result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Editorder(),
                    settings: RouteSettings(arguments: order),
                  ));
              if (result == 'refresh') {
                setState(() {
                  getOrdes();
                });
              }
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(
                  leading: SizedBox(
                      child: Image.network(
                    '${order.image}',
                    fit: BoxFit.cover,
                  )),
                  title: Text(
                    '${order.bname}',
                    style: GoogleFonts.kanit(),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'QTY : ',
                        style: GoogleFonts.kanit(color: Colors.black),
                      ),
                      Text(
                        ' ${order.qty}',
                        style: GoogleFonts.kanit(),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Total Price :',
                        style: GoogleFonts.kanit(color: Colors.black),
                      ),
                      Text(
                        ' \$ ${order.total}',
                        style: GoogleFonts.kanit(),
                      ),
                    ],
                  ),
                  trailing: InkWell(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Are You Sure?'),
                            content: const Text('Delete This Payment Method'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  remove(order.id);
                                },
                                child: const Text(
                                  'DELETE',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.clear)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
