import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> getPredict(csv_path) async {
  final response = await http.post(
      'https//127.0.0.1:5000/',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'path': csv_path,
      }),
  );

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body) as Map<String, int>;
    return decoded['result'];
  }
}
