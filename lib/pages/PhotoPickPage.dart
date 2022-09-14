import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../api/HttpService.dart';
import '../domain/Constants.dart';
import '../models/Dom.dart';
import '../models/Kompleks.dart';

class PhotoPickPage extends StatefulWidget {
  const PhotoPickPage({Key? key}) : super(key: key);

  @override
  State<PhotoPickPage> createState() => _PhotoPickPageState();
}

class _PhotoPickPageState extends State<PhotoPickPage> {
  List<Kompleks> _komplekslist = [];
  Kompleks? _dropdownAdress; //KompleksEntity(name: "", id: "");
  List<Dom> _domlist = [];
  Dom? _dropdownDom;
  String filename = '';
  var imagePassport;
  File? file;
  double progress = 0;
  String urimain = Constans().uri;
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool sended = false;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    HttpService().getAllkomleks().then((value) {
      setState(() {
        _komplekslist = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          color: Constans().backroundcolors,
          height: 60,
          child: Wrap(
            children: [
              Text(
                "Передача данные",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constans.font),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: getImage(),
        ),
        Container(
          child: Text("Выбор комплекса!"),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: firstDropDown(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: secondDropdown(),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(label: Text("Описание", style: TextStyle(fontFamily: Constans.font),), ),
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          pickImage(ImageSource.camera);
                          sended = false;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Снять фото",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    sended = false;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Галерея",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ))
              ]),
        ),
        SizedBox(
          height: 10,
        ),
        // linerProgress(),
        // SizedBox(
        //   height: 10,
        // ),
        Container(
            height: 100,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black, width: 1)))),
                onPressed: () {
                  if (_dropdownDom == null) {
                    return;
                  }
                  HttpService()
                      .postImage(_dropdownDom!.id.toString(),
                          _nameController.text, imagePassport)
                      .then((value) {
                    setState(() {
                      imagePassport = null;
                      _nameController.text = "";
                      sended = true;
                      //getImage();
                    });
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    child: Text("Отправить",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: Constans.font))))),
      ],
    );
  }

  Widget getImage() {
    if (imagePassport != null && sended == false) {
      return Card(child: Image.file(imagePassport));
    } else if (imagePassport == null && sended == false) {
      return Icon(
        Icons.image,
        size: 80,
        color: Colors.black,
      );
    } else if (sended == true) {
      return Center(
          child: Text(
        "Отправлен!",
        style: TextStyle(fontFamily: Constans.font, fontSize: 20),
      ));
    } else {
      return Icon(
        Icons.image,
        size: 80,
        color: Colors.black,
      );
    }
  }

  Widget firstDropDown() {
    return DropdownButton<Kompleks>(
      // borderRadius: BorderRadius.circular(10),
      style: TextStyle(fontSize: 20, color: Colors.black),
      isExpanded: true,
      hint: Text("Комплекс", style: TextStyle(fontFamily: Constans.font)),
      onChanged: (newValue) {
        _dropdownDom = null;
        setState(() {
          _dropdownAdress = newValue!;
        });

        HttpService()
            .getDomByIdKompleks(
                _dropdownAdress == null ? "" : _dropdownAdress!.id.toString())
            .then((value) {
          setState(() {
            _domlist = value;
          });
        });
      },
      items: _komplekslist.map((Kompleks e) {
        return DropdownMenuItem<Kompleks>(
          child: Text(
            e.name,
            style: TextStyle(fontFamily: Constans.font),
          ),
          value: e,
        );
      }).toList(),
      value: _dropdownAdress,
    );
  }

  Widget secondDropdown() {
    return DropdownButton<Dom>(
      borderRadius: BorderRadius.circular(10),
      isExpanded: true,
      style: TextStyle(fontSize: 20, color: Colors.black),
      hint: Text(
        "Дом",
        style: TextStyle(fontFamily: Constans.font),
      ),
      onChanged: (newValue) {
        setState(() {
          _dropdownDom = newValue!;
        });
      },
      items: _domlist
          .map((Dom e) => DropdownMenuItem<Dom>(
                child: Text(
                  e.name,
                  style: TextStyle(fontFamily: Constans.font),
                ),
                value: e,
              ))
          .toList(),
      value: _dropdownDom,
    );
  }

  Widget linerProgress() {
    return LinearProgressIndicator(
      value: progress,
      valueColor: AlwaysStoppedAnimation(Colors.black),
      backgroundColor: Colors.white,
      minHeight: 10,
    );
  }

  Future pickImage(ImageSource source) async {
    XFile? _imageFile =
        await ImagePicker().pickImage(source: source, imageQuality: 30);
    if (_imageFile == null) return;

    filename = _imageFile.name;
    setState(() {
      imagePassport = File(_imageFile.path);
    });
  }
}
