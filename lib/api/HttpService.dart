import 'dart:convert';
import 'dart:typed_data';
import 'package:dsk_smu/models/ImageData.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../domain/Constants.dart';
import '../models/Dom.dart';
import '../models/Kompleks.dart';

class HttpService {
  late final response;
  FlutterSecureStorage storage = FlutterSecureStorage();

  String urimain = Constans().uri;
  Map<String, String> headers = {
    "Accept": "application/json",
    "content-type": "application/json"
  };
  FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Kompleks>> getAllkomleks() async {
    String? token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final uri = Uri.parse('$urimain/api/les/kompleks');

    response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(utf8.decode(response.bodyBytes));
      return List<Kompleks>.from(
          l.map((element) => Kompleks.fromJson(element)));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<Dom>> getDomByIdKompleks(String id) async {
    if (id == '') {
      return [];
    }

    String? token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    Map<String, String> param = {"id": id};
    final uri =
        Uri.parse('$urimain/api/les/dom').replace(queryParameters: param);

    response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(utf8.decode(response.bodyBytes));
      return List<Dom>.from(l.map((element) => Dom.fromJson(element)));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<ImageData>> getAllImage(String id) async {
    String? token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    if (id == '') {
      return [];
    }
    Map<String, String> param = {"id": id};
    final uri =
        Uri.parse('$urimain/api/les/imageall').replace(queryParameters: param);

    response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      print(response.statusCode);
      Iterable l = jsonDecode(utf8.decode(response.bodyBytes));
      return List<ImageData>.from(l.map((e) => ImageData.fromJson(e)));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future postImage(String id, String name, var img) async {
    Uint8List data = await img.readAsBytes();
    List<int> list = data.cast();
    final bytes = <int>[];
    String? token = await storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    // Map<String, String> mapparam = {"dom_id": id};
    final uri = Uri.parse('$urimain/api/les/imageupload');
    // .replace(queryParameters: mapparam);

    var request = await http.MultipartRequest('POST', uri);
    request.fields['dom_id'] = id;
    request.fields['name'] = name;

    request.headers.addAll(hedersWithToken);
    request.files
        .add(http.MultipartFile.fromBytes("file", list, filename: img.toString()));
    final contentLength = request.contentLength;

    request.send().then((value) => {
      value.stream.listen((value) {
        bytes.addAll(value);

        double p = (bytes.length / contentLength) * 100;
        // setState(() {
        //   if (p > 100) {
        //     progress = 100;
        //     sended = true;
        //   } else {
        //     progress = p;
        //   }
        // });
      }, onDone: () {
        // setState(() {
        //   progress = 0;
        // });
      }, cancelOnError: true),
      if (value.statusCode == 200) {print('Ok')}
    });
  }

}
