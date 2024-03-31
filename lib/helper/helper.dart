import 'dart:convert';
import 'package:http/http.dart' as http;

String cutString(String teks, int maxLength) {
  if (teks.length <= maxLength) {
    return teks;
  } else {
    return teks.substring(0, maxLength) + "...";
  }
}

Future<String> convertImgBase64(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  } else {
    throw Exception('Failed to load image');
  }
} 