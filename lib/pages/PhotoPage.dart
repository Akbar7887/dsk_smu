import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/Constants.dart';
import 'HistoryImagePage.dart';
import 'PhotoPickPage.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  int bottomindex = 0;
  PageController pageController = PageController();
  FlutterSecureStorage storage = FlutterSecureStorage();

  List<Widget> _pageBottom = <Widget>[
    PhotoPickPage(),
    HistoryImagePage(),
  ];

  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Constans().backroundcolors,
        title: Constans().name
      ),
      body: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (int i) {
            setState(() {
              bottomindex = i;
            });
          },
          itemCount: _pageBottom.length,
          itemBuilder: (context, idx) {
            return _pageBottom[bottomindex];
          }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            if (index == 2) {
              // storage.delete(key: "token");
              exit(0);
            } else {
              bottomindex = index;
            }
          });
        },
        currentIndex: bottomindex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Фото"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "История"),
          BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app), label: "Выход"),
        ],
      ),
    );
  }
}

class ImageCard {
  late String name;
  late String image;

  ImageCard(this.name, this.image);
}
