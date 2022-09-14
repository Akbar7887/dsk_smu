import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/Constants.dart';
import 'PhotoPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController logincontroller = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool validate = false;
  bool visiblepassvord = true;

  Future<void> _getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user = await prefs.getString('user');
    if (user != null) {
      setState(() {
        logincontroller.text = user;
      });
    }
    String? password = await prefs.getString('password');
    if (password != null) {
      setState(() {
        passwordControler.text = password;
      });
    }
  }

  Future<void> _setPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user', logincontroller.text);
    await prefs.setString('password', passwordControler.text);
  }

  @override
  void initState() {
    super.initState();
    _getPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: BackButton(
        //   color: Constans().backroundcolors,
        // ),
        backgroundColor: Constans().backroundcolors,
        title: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'Програмный продукт',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 15,
                  fontFamily: Constans.font),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: BodyContainer(),
    );
  }

  Widget BodyContainer() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Constans().backroundcolors,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/logo1.png',
                    width: 100,
                    height: 80,
                  ),
                  Container(
                    child: Constans().name,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Text(
                  'Вход',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[700],
                      fontFamily: Constans.font),
                )),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: logincontroller,
                    style: TextStyle(fontFamily: Constans.font),
                    decoration: InputDecoration(
                        hintText: "Пользователь",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide())),
                  ),
                  //
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordControler,
                    style: TextStyle(fontFamily: Constans.font),
                    obscureText: visiblepassvord,
                    decoration: InputDecoration(
                        hintText: "Пароль",
                        suffixIcon: IconButton(
                          icon: Icon(
                            (visiblepassvord)
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblepassvord = !visiblepassvord;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide())),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
                height: 60,
                width: 200,
                // padding: EdgeInsets.only(left: 40, right: 40),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Constans().backroundcolors),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () async {
                    // String token = getToken() as String;
                    Map<String, String> data = {
                      'username': logincontroller.text.trim(),
                      'password': passwordControler.text.trim()
                    };
                    Map<String, String> header = {
                      "Content-Type": "application/x-www-form-urlencoded", //
                      // "Authorization": "Bearer $token",
                    };
                    // final uri = Uri.parse();
                    final uri = Uri.parse('${Constans().uri}/api/login');
                    var response = await http.post(uri,
                        body: data,
                        headers: header,
                        encoding: Encoding.getByName('utf-8'));
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> l =
                          jsonDecode(utf8.decode(response.bodyBytes));
                      await storage.write(
                          key: "token", value: l["access_token"]);

                      setState(() {
                        validate = true;
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PhotoPage()));
                      _setPreference();
                    } else {
                      // String output = json.decode(response.body);
                      setState(() {
                        validate = false;
                        SnackBar snakbar = SnackBar(
                          content: Text(
                              "Не правильно указан пользователь или пароль"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snakbar);
                      });
                    }
                  },
                  child: Text(
                    'Вход',
                    style: TextStyle(fontSize: 30, fontFamily: Constans.font),
                  ),
                )),
            SizedBox(
              height: 200,
            ),
            Divider(),
            Container(
              child: Text(
                "Телефоны для справки: +99871-205-08-53",
                style: TextStyle(fontFamily: Constans.font),
              ),
            )
          ],
        ));
  }
}
