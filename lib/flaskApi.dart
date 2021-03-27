import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getPredict(csv_str) async {
  final response = await http.post(
    // change it to your local ip address to test
    'http://192.168.50.144:5000/',
    headers: {'Content-Type': 'application/json; charset=utf-8'},
    body: jsonEncode(<String, String>{
      'csv': csv_str,
    }));
  print(response.statusCode);
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    return decoded['result'];
  }
}
