
import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  Future<String> getData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> postData(String url, Map<String,String> headers,dynamic body) async {
    http.Response response;
    try {
      http.Response response = await http.post(Uri.parse(url),headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        print('Data posted successfully');
        print(response.body);
        return response.body;
      } else {
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
    return ;
  }
}

