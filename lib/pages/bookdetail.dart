import 'package:book/extension.dart';
import 'package:book/models/books.dart';
import 'package:book/pages/buy.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BookDetail extends StatefulWidget {
  static const routeName = '/BookDetail';
  const BookDetail({super.key});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  @override
  Widget build(BuildContext context) {
    Books book = ModalRoute.of(context)!.settings.arguments as Books;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            '${book.bname}',
            style: GoogleFonts.kanit(),
          ),
          backgroundColor: '#E72913'.toColor(),
        ),
        backgroundColor: '#F4F4F4'.toColor(),
        body: Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: RatingBar.builder(
                                          initialRating: book.rating!.rate ?? 0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 30,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (value) {},
                                        ),
                                      ),
                                      Text(
                                        'of ${book.rating?.count}',
                                        style: GoogleFonts.kanit(fontSize: 15),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Description',
                                    style: GoogleFonts.kanit(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                    '${book.description}',
                                    style: GoogleFonts.kanit(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Author',
                                    style: GoogleFonts.kanit(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                    '${book.author}',
                                    style: GoogleFonts.kanit(
                                        textStyle:
                                            const TextStyle(fontSize: 15)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Category',
                                    style: GoogleFonts.kanit(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                    '${book.category}',
                                    style: GoogleFonts.kanit(
                                        textStyle:
                                            const TextStyle(fontSize: 15)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Price',
                                    style: GoogleFonts.kanit(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                    '\$ ${book.price}',
                                    style: GoogleFonts.kanit(
                                        textStyle: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black12,
                                    )),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: ElevatedButton.icon(
                                      icon:
                                          const Icon(Icons.shopping_bag_sharp),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: '#E72913'.toColor()),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Buy(),
                                                settings: RouteSettings(
                                                    arguments: book)));
                                      },
                                      label: Text(
                                        'Buy',
                                        style: GoogleFonts.kanit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
