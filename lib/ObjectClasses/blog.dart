import 'dart:convert';

import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:http/http.dart' as http;

class Blog {
  Future<Map<String, dynamic>> listAllPost() async {
    const path = "https://travel-application-api.herokuapp.com/api/";
    var response = await http.get(Uri.parse(path + "list-all-posts"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + LoginFormPage.currentCustomer.token
    });
    var response_json = json.decode(response.body);
    if (response_json["status"] == 1) {
      print(response_json);
    }
    return response_json;
  }
}
