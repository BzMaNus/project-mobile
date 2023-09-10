import 'dart:async';

import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/payment.dart';
import 'package:book/models/users.dart';
import 'package:book/pages/addcard.dart';
import 'package:book/pages/login.dart';
import 'package:book/pages/updatecard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Users user = Config.login;
  bool isLoading = true;
  List<Payment> _payment = [];
  Future<void> getMethod() async {
    var params = {
      "userid": {user.id.toString()}
    };
    var url = Uri.http(Config.server, 'paymentMethod', params);
    print(url);
    var res = await http.get(url);
    _payment = paymentFromJson(res.body);

    print(_payment.length);

    setState(() {
      isLoading = false;
    });

    return;
  }

  Future<void> remove(id) async {
    var url = Uri.http(Config.server, 'paymentMethod/$id');
    print(url);
    var res = await http.delete(url);
    print(res.body);
    _payment.removeWhere((payment) => payment.id == id);
    print(_payment);
    setState(() {
      Navigator.pop(context);
    });
    return;
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        getMethod();
      });
    });
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
      body: isLoading ? Loading() : ProfileDetail(),
    );
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

  Widget ProfileDetail() {
    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.80,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                      height: 200,
                      width: 200,
                      child: CircleAvatar(
                        child: Image.network(
                          '${user.imageurl}',
                          fit: BoxFit.cover,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${user.username}',
                    style: GoogleFonts.kanit(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email',
                            style: GoogleFonts.kanit(
                              textStyle: const TextStyle(fontSize: 15),
                            )),
                        Text('${user.email}',
                            style: GoogleFonts.kanit(
                              textStyle: const TextStyle(
                                  fontSize: 15, color: Colors.black12),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'My Cards',
                          style: GoogleFonts.kanit(
                              textStyle: TextStyle(fontSize: 15)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _payment.isEmpty ? paymentEmpty() : payment(),
                        const SizedBox(
                          height: 2,
                        ),
                        Center(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SplashScreen.routeName);
                              },
                              icon: const Icon(Icons.logout_rounded),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: '#E72913'.toColor()),
                              label: Text(
                                'Logout',
                                style: GoogleFonts.kanit(),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget paymentEmpty() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            String result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPay(),
                ));
            if (result == "refresh") {
              setState(() {
                getMethod();
              });
            }
          },
          child: Card(
            child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 1,
                child: const Icon(
                  Icons.add_box_rounded,
                  color: Colors.black12,
                  size: 30,
                )),
          ),
        );
      },
    );
  }

  Widget payment() {
    return _payment.length == 1
        ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: _payment.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      String result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpdatePay(),
                              settings:
                                  RouteSettings(arguments: _payment[index])));
                      if (result == "refresh") {
                        setState(() {
                          getMethod();
                        });
                      }
                    },
                    child: Card(
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 1,
                        child: ListTile(
                          title:
                              Text('Master Card', style: GoogleFonts.kanit()),
                          subtitle: Text(
                            '${_payment[index].cardNum}',
                            style: GoogleFonts.kanit(),
                          ),
                          leading: SizedBox(
                            width: 50,
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/200px-Mastercard-logo.svg.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          trailing: InkWell(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Are You Sure?'),
                                    content: const Text(
                                        'Delete This Payment Method'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          remove(_payment[index].id);
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      String result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPay(),
                          ));
                      if (result == "refresh") {
                        setState(() {
                          getMethod();
                        });
                      }
                    },
                    child: Card(
                      child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.add_box_rounded,
                            color: Colors.black12,
                            size: 30,
                          )),
                    ),
                  );
                },
              )
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _payment.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: ListTile(
                    title: Text('Master Card', style: GoogleFonts.kanit()),
                    subtitle: Text(
                      '${_payment[index].cardNum}',
                      style: GoogleFonts.kanit(),
                    ),
                    leading: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/200px-Mastercard-logo.svg.png',
                      width: 50,
                      fit: BoxFit.cover,
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
                                    remove(_payment[index].id);
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
              );
            },
          );
  }
}
