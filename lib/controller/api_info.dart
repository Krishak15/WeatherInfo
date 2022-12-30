import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiInfo {
  ApiInfo(this.Url);

  final String Url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      String dat = response.body;
      return jsonDecode(dat);
    } else {
      print(response.statusCode);
    }
  }
}
