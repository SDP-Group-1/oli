import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getPredict(csv_str) async {
  // var dict = jsonEncode({'csv' : csv_str});
  final response = await http.post(
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
