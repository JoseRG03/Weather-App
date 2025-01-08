import 'package:http/http.dart' as http;
import 'dart:convert';

class Networking{

  final String url;

  Networking({required this.url});

  // Await the http get response, then decode the json-formatted response.
  Future getData() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print('Body: $response.body');
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }



}