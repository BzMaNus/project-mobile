import 'dart:async';
import 'dart:convert';

import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

import '../models/users.dart';

class UpdatePay extends StatefulWidget {
  const UpdatePay({super.key});

  @override
  State<UpdatePay> createState() => _UpdatePayState();
}

class _UpdatePayState extends State<UpdatePay> {
  bool isLoading = true;
  final _formkey = GlobalKey<FormState>();
  Users user = Config.login;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> updateCard(Payment payment) async {
    payment.userid = user.id;
    var url = Uri.http(Config.server, 'paymentMethod/${payment.id}');
    var res = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(payment.toJson()));
    print(res.body);
    var rs = paymentFromJson('[${res.body}]');
    if (rs.length == 1) {
      Navigator.pop(context, 'refresh');
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    Payment _payment = ModalRoute.of(context)!.settings.arguments as Payment;
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
        body: isLoading ? Loading() : addCardForm(_payment));
  }

  Widget addCardForm(Payment payment) {
    return ListView(
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
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/200px-Mastercard-logo.svg.png',
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
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    cardNum(payment),
                    const SizedBox(
                      height: 5,
                    ),
                    Name(payment),
                    const SizedBox(
                      height: 10,
                    ),
                    Adress(payment),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: City(payment)),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Country(payment))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Province(payment)),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Zipcode(payment))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: CVC(payment)),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Exp(payment))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: add(payment))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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

  Widget cardNum(Payment payment) {
    return TextFormField(
      initialValue: payment.cardNum.toString(),
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          payment.cardNum = int.tryParse(newValue);
        }
      },
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      maxLength: 16,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Card Number',
        hintText: 'Your Card Number',
        hintStyle: GoogleFonts.kanit(),
        labelStyle: GoogleFonts.kanit(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: '#E72913'.toColor(), width: 1.5)),
        prefixIcon: Icon(
          Icons.add_card,
          color: '#E72913'.toColor(),
          size: 30,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่ Card Number';
        }
        return null;
      },
    );
  }

  Widget Name(Payment payment) {
    return TextFormField(
      initialValue: payment.name,
      onSaved: (newValue) => payment.name = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Your name on card',
        hintStyle: GoogleFonts.kanit(),
        labelStyle: GoogleFonts.kanit(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: '#E72913'.toColor(), width: 1.5)),
        prefixIcon: Icon(
          Icons.person,
          color: '#E72913'.toColor(),
          size: 30,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่ Name';
        }
        return null;
      },
    );
  }

  Widget Adress(Payment payment) {
    return TextFormField(
      initialValue: payment.address,
      onSaved: (newValue) => payment.address = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      decoration: InputDecoration(
        labelText: 'Adress',
        hintText: 'Your Adress',
        hintStyle: GoogleFonts.kanit(),
        labelStyle: GoogleFonts.kanit(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: '#E72913'.toColor(), width: 1.5)),
        prefixIcon: Icon(
          Icons.location_on,
          color: '#E72913'.toColor(),
          size: 30,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่ Adress';
        }
        return null;
      },
    );
  }

  Widget City(Payment payment) {
    return TextFormField(
      initialValue: payment.city,
      onSaved: (newValue) => payment.city = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      decoration: InputDecoration(
        labelText: 'City',
        hintText: 'Your City',
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
          return 'กรุณาใส่ City';
        }
        return null;
      },
    );
  }

  Widget Country(Payment payment) {
    return TextFormField(
      initialValue: payment.country,
      onSaved: (newValue) => payment.country = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      decoration: InputDecoration(
        labelText: 'Country',
        hintText: 'Your Country',
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
          return 'กรุณาใส่ Country';
        }
        return null;
      },
    );
  }

  Widget Province(Payment payment) {
    return TextFormField(
      initialValue: payment.province,
      onSaved: (newValue) => payment.province = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      decoration: InputDecoration(
        labelText: 'Province',
        hintText: 'Your Province',
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
          return 'กรุณาใส่ Province';
        }
        return null;
      },
    );
  }

  Widget Zipcode(Payment payment) {
    return TextFormField(
      initialValue: payment.zipCode.toString(),
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          payment.zipCode = int.tryParse(newValue);
        }
      },
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Zip code',
        hintText: 'Your Zip code',
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
          return 'กรุณาใส่ Zip code';
        }
        return null;
      },
    );
  }

  Widget CVC(Payment payment) {
    return TextFormField(
      initialValue: payment.cvc.toString(),
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          payment.cvc = int.tryParse(newValue);
        }
      },
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      keyboardType: TextInputType.number,
      maxLength: 3,
      decoration: InputDecoration(
        labelText: 'CVC',
        hintText: 'Your CVC',
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
          return 'กรุณาใส่ CVC';
        }
        return null;
      },
    );
  }

  Widget Exp(Payment payment) {
    return TextFormField(
      initialValue: payment.exp.toString(),
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          payment.exp = int.tryParse(newValue);
        }
      },
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      maxLength: 4,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Exp',
        hintText: 'Your Exp',
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
          return 'กรุณาใส่ Exp';
        }
        return null;
      },
    );
  }

  Widget add(Payment payment) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: '#E72913'.toColor()),
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            updateCard(payment);
          }
        },
        child: Text(
          'SAVE',
          style: GoogleFonts.kanit(),
        ));
  }
}
