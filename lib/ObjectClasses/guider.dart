import 'dart:collection';
import 'dart:convert';

import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:http/http.dart' as http;

class Guider {
  Future<LinkedHashMap<String, dynamic>> listAllGuider() async {
    const path = "https://travel-application-api.herokuapp.com/api/";
    var response =
        await http.get(Uri.parse(path + "list-all-guiders"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + LoginFormPage.currentCustomer.token
    });
    var response_json = json.decode(response.body);
    return response_json;
  }
}
