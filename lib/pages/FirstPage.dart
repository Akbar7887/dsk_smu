
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/Constants.dart';
import 'home.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  double opacityLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHomePage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(Constans.namecompany, style: TextStyle(fontSize: 30, fontFamily: Constans.font),),
                  ],
                ),
              ));
        }
      },
    );
  }


  void _changeOpacity() {
    setState(() {
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  Future<Widget> getHomePage() async {
    _changeOpacity();
    return await Future.delayed(Duration(seconds: 3), () {})
        .then((value) => Home());
  }
}
