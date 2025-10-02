import 'package:todolist/data/api_client.dart';
import 'package:todolist/model/bored_activity.dart';
import 'package:flutter/material.dart';
class BoredRepository{
  final ApiClient _client;
  BoredRepository(this._client);
  
  Future<BoredActivity> fetchRandomActivity() async{
    final uri = Uri.https('bored-api.appbrewery.com','/random');
    final map = await _client.getJson(uri);
    debugPrint('RAW JSON => $map');
    return BoredActivity.fromJson(map);
  } 
}