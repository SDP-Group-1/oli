import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> getPredict(csv_path) async {
  final response = await http.post(
    // change the ip to your computer's
    'http://192.168.50.144:5000/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'path': csv_path,
    }),
  );
  print(csv_path);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body) as Map<String, int>;
    return decoded['result'];
  }
}
