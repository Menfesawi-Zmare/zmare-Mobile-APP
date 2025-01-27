import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Lyrics {
  static Future<String> getOffLyrics(String path) async {
    try {
      final Audiotagger tagger = Audiotagger();
      final Tag? tags = await tagger.readTags(path: path);
      return tags?.lyrics ?? '';
    } catch (e) {
      return '';
    }
  }

  static Future<File> downloadLyric(String url, String filename) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
