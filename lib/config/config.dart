import 'dart:convert';
import 'package:flutter/services.dart';

abstract class Configurations {
  static late Map<String, dynamic> _config;

  static Future<void> initialize(String env) async {
    final configString = await rootBundle.loadString('config/${env}_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getGoogleMapsApiKey() {
    return _config['GOOGLE_MAPS_API_KEY'] as String;
  }
}