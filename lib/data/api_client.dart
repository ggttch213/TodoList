import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiClient {
  const ApiClient();

  Future<Map<String,dynamic>> getJson(Uri url) async {
    var response = await http.get(url);
    if (response.statusCode != 200){
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    var jsonResponse = convert.jsonDecode(response.body) as Map<String,dynamic>;
    return jsonResponse;
  }
}