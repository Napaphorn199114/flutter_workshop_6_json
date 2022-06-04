import 'dart:convert';

import 'package:workshop_6_json/models/JsonTest.dart';
import 'package:workshop_6_json/models/Youtubes.dart';
import 'package:http/http.dart' as http;

//import '../models/JsonTest.dart';

class Network{

  //ตัวอย่างการติดต่อ network web อื่นๆ
    static Future<List<JsonTest>> fetchJsonTest() async {

    final url = 'https://jsonplaceholder.typicode.com/users';

    //final response = await http.get(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      final List jsonResponse = json.decode(response.body);      //รับแบบ List

      List<JsonTest> result = jsonResponse.map((i) => JsonTest.fromJson(i)).toList();

     for (var item in result) {
       print(item.username);    // print title ติดต่อ network
     }

      return result;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }


 //////////////////////////////////////////////////////////////////

    static Future<List<Youtube>> fetchYoutube({final type = "superhero"}) async {

    final url = 'http://codemobiles.com/adhoc/youtubes/index_new.php?username=admin&password=password&type=${type}';

    //final response = await http.get(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      final jsonResponse = json.decode(response.body);     

      Youtubes youtubeList = Youtubes.fromJson(jsonResponse);

    //  for (var item in youtubeList.youtubes) {
    //    print(item.title);    // print title ติดต่อ network
    //  }

      return youtubeList.youtubes;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

