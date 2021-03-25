//import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getPredict(csv_path) async {
  final response =
      await http.post('https//127.0.0.1:5000/', headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  }, body: {
    'path': csv_path
  });

  if (response.statusCode == 200) {
    print("Response received");
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    print(decoded['result']);
    return decoded['result'];
  }
}
