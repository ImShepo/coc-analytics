import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String cocKey = dotenv.env['COC_KEY'] ?? 'No hay API Key';
}