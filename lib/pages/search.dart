import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/books.dart';
import 'package:book/pages/bookdetail.dart';
import 'package:book/pages/buy.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyserchDelegate extends SearchDelegate {
  List<Books> _books = Config.book;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Books> suggestion = _books.where((book) {
      final result = book.bname!.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    return Container(
        child: ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) {
        Books book = suggestion[index];
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
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 112,
                          height: 150,
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
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 200,
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${book.bname}',
                                style: GoogleFonts.kanit(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
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
                                'Category',
                                style: GoogleFonts.kanit(),
                              )),
                          Container(
                              width: 100,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "\$ 12.50",
                                style: GoogleFonts.kanit(
                                    textStyle: const TextStyle(
                                        color: Colors.black12, fontSize: 20)),
                              )),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
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
                                  icon: const Icon(Icons.shopping_bag_sharp),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: '#E72913'.toColor()),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Buy(),
                                            settings: RouteSettings(
                                                arguments: book)));
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
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Books> suggestion = _books.where((book) {
      final result = book.bname!.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) {
        Books book = suggestion[index];
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
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 200,
                              alignment: Alignment.topLeft,
                              child: highlightText(
                                book.bname.toString(),
                                query,
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
                                'Category',
                                style: GoogleFonts.kanit(),
                              )),
                          Container(
                              width: 100,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "\$ 12.50",
                                style: GoogleFonts.kanit(
                                    textStyle: const TextStyle(
                                        color: Colors.black12, fontSize: 20)),
                              )),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
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
                                  icon: const Icon(Icons.shopping_bag_sharp),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: '#E72913'.toColor()),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Buy(),
                                            settings: RouteSettings(
                                                arguments: book)));
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
    );
  }

  Widget highlightText(String bookName, String query) {
    final lowerCaseBookName = bookName.toLowerCase();
    final lowerCaseQuery = query.toLowerCase();

    final startIndex = lowerCaseBookName.indexOf(lowerCaseQuery);

    if (startIndex == -1) {
      return Text(bookName);
    }

    final endIndex = startIndex + query.length;
    final postMatch = bookName.substring(0, startIndex);
    final match = bookName.substring(startIndex, endIndex);
    final preMatch = bookName.substring(endIndex);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: postMatch,
            style: GoogleFonts.kanit(
                textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            )),
          ),
          TextSpan(
            text: match,
            style: GoogleFonts.kanit(
                textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            )),
          ),
          TextSpan(
            text: preMatch,
            style: GoogleFonts.kanit(
                textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
          ),
        ],
      ),
    );
  }
}
