import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'auth_functions.dart';
import 'package:image_picker/image_picker.dart';

Future<String> animefy(
    String base64, String url, String version, User user) async {
  final json = {
    'data': ['data:image/jpeg;base64,$base64', version],
  };

  final response = await http.post(Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(json));

  final data = jsonDecode(response.body);
  final base64Image = data['data'][0].split(',')[1];

  final credit = await checkCredit(user);
  updateCredit(user, credit - 1);
  await addImage(user, base64Image);

  final currTimeSinceEpoch = DateTime.now().millisecondsSinceEpoch;
  final uri = '${(await getTemporaryDirectory()).path}/$currTimeSinceEpoch.jpg';
  Uint8List bytes = base64Decode(base64Image);
  await File(uri).writeAsBytes(bytes, mode: FileMode.write);
  return uri;
}

Future<List<Map<String, dynamic>>> loadImages(User user) async {
  final images = await getImages(user);
  final uris = <Map<String, dynamic>>[];
  for (final element in images) {
    final base64 = element['base64'];
    final file = File(
        '${(await getTemporaryDirectory()).path}/${element['timestamp']}.jpg')
      ..writeAsString(base64,
          mode: FileMode.write,
          flush: true,
          encoding: Encoding.getByName('base64')!);
    uris.add({'id': element['timestamp'], 'uri': file.uri});
  }
  uris.sort((a, b) => b['id'].compareTo(a['id']));
  return uris;
}

Future<Uri?> showImageLibrary() async {
  final XFile? result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 100);
  if (result != null) {
    return Uri.parse(result.path);
  }
  return null;
}
