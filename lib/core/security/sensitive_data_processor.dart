import 'dart:convert';

class SensitiveDataProcessor {
  static String process(String data) {
    if (data.isEmpty) return "";
    final bytes = utf8.encode(data);
    return base64.encode(bytes);
  }

  static String deprocess(String encoded) {
    if (encoded.isEmpty) return "";
    try {
      final bytes = base64.decode(encoded);
      return utf8.decode(bytes);
    } catch (e) {
      return "Error de descifrado";
    }
  }
}
