import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // .env dosyasındaki API_URL'i okur. Yoksa localhost varsayılanını alır.
  static String get _host {
     String url = dotenv.env['API_URL'] ?? 'http://localhost';
     // Android Emulator'de localhost (10.0.2.2) erişimi için özel kontrol
     if (!kIsWeb && Platform.isAndroid && (url.contains('localhost') || url.contains('127.0.0.1'))) {
       // localhost yerine 10.0.2.2 kullanarak emülatörden host'a erişim sağlar
       return url.replaceFirst(RegExp(r'localhost|127\.0\.0\.1'), '10.0.2.2');
     }
     return url;
  }

  static String get baseUrl => "$_host:${dotenv.env['API_PORT'] ?? '5000'}";
}
