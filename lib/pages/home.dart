import 'dart:async';
import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/users.dart';
import 'package:book/models/books.dart';
import 'package:book/pages/bookdetail.dart';
import 'package:book/pages/buy.dart';
import 'package:book/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Users user = Config.login;
    Timer(const Duration(seconds: 1), () {
      setState(() {
        if (user.id != null) {
          getBooks();
        }
      });
    });
    print(user.id);
  }

  List<Books> _books = [];
  List<Books> _topRating = [];

  Future<void> getBooks() async {
    var url = Uri.http(Config.server, "books");
    var res = await http.get(url);

    setState(() {
      _books = booksFromJson(res.body);
      Config.book = _books;
      _topRating = booksFromJson(res.body);
      _topRating
          .sort((a, b) => (b.rating?.rate ?? 0).compareTo(a.rating?.rate ?? 0));
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
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: MyserchDelegate());
                  },
                  icon: const Icon(Icons.search))
            ]),
        backgroundColor: '#F4F4F4'.toColor(),
        body: bookList());
  }

  Widget bookList() {
    return _books.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommed Books',
                      style: GoogleFonts.kanit(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: 6,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Books topRating = _topRating[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BookDetail(),
                                    settings:
                                        RouteSettings(arguments: topRating)));
                          },
                          child: Card(
                              child: Container(
                            width: 114,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Column(children: [
                              SizedBox(
                                width: 112,
                                height: 120,
                                child: CachedNetworkImage(
                                  imageUrl: '${topRating.imageurl}',
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
                              ),
                              Container(
                                  width: 112,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '${topRating.bname}',
                                    style: GoogleFonts.kanit(
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  width: 112,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "\$ ${topRating.price}",
                                    style: GoogleFonts.kanit(
                                      fontSize: 15,
                                    ),
                                  )),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: RatingBar.builder(
                                  initialRating: topRating.rating!.rate ?? 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 1.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (value) {},
                                ),
                              ),
                            ]),
                          )),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'List of Books',
                      style: GoogleFonts.kanit(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                  ),
                  Flexible(
                      child: ListView.builder(
                    itemCount: _books.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Books book = _books[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BookDetail(),
                                    settings: RouteSettings(arguments: book)));
                          },
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 112,
                                        height: 150,
                                        child: CachedNetworkImage(
                                          imageUrl: '${book.imageurl}',
                                          placeholder: (context, url) =>
                                              SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: LoadingIndicator(
                                                indicatorType:
                                                    Indicator.ballPulse,
                                                colors: ['#E72913'.toColor()],
                                                strokeWidth: 2,
                                                backgroundColor: Colors.white,
                                                pathBackgroundColor:
                                                    Colors.black),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 200,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${book.bname}',
                                              style: GoogleFonts.kanit(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            )),
                                        Container(
                                            width: 100,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Author',
                                              style: GoogleFonts.kanit(),
                                            )),
                                        Container(
                                            width: 100,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${book.author}',
                                              style: GoogleFonts.kanit(
                                                  textStyle: const TextStyle(
                                                      color: Colors.black12)),
                                            )),
                                        Container(
                                            width: 100,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Category',
                                              style: GoogleFonts.kanit(),
                                            )),
                                        Container(
                                            width: 100,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${book.category}',
                                              style: GoogleFonts.kanit(
                                                  color: Colors.black12),
                                            )),
                                        Container(
                                            width: 100,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "\$ ${book.price}",
                                              style: GoogleFonts.kanit(
                                                  fontSize: 20),
                                            )),
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: RatingBar.builder(
                                                initialRating:
                                                    book.rating!.rate ?? 0,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (value) {},
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: 85,
                                              child: ElevatedButton.icon(
                                                icon: const Icon(
                                                    Icons.shopping_bag_sharp),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        '#E72913'.toColor()),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Buy(),
                                                          settings:
                                                              RouteSettings(
                                                                  arguments:
                                                                      book)));
                                                },
                                                label: const Text('Buy'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ]),
                            ),
                          ));
                    },
                  ))
                ],
              ),
            ),
          )
        : Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: ['#E72913'.toColor()],
                  strokeWidth: 2,
                  backgroundColor: '#F4F4F4'.toColor(),
                  pathBackgroundColor: Colors.black),
            ),
          );
  }
}
