// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zmare/src/core/resources/images.dart';

import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';

class Download with ChangeNotifier {
  static final Map<String, Download> _instances = {};
  final String id;

  factory Download(String id) {
    if (_instances.containsKey(id)) {
      return _instances[id]!;
    } else {
      final instance = Download._internal(id);
      _instances[id] = instance;
      return instance;
    }
  }

  Download._internal(this.id);
  int? rememberOption;
  final ValueNotifier<bool> remember = ValueNotifier<bool>(false);
  String downloadFormat = 'mp3';
  bool createDownloadFolder = Hive.box(BoxType.downloadSettings.name)
      .get('createDownloadFolder', defaultValue: false) as bool;
  double? progress = 0.0;
  String lastDownloadId = '';
  bool downloadLyrics = Hive.box(BoxType.downloadSettings.name)
      .get('downloadLyrics', defaultValue: true) as bool;
  bool download = true;

  Future<void> prepareDownload(
    BuildContext context,
    Map data, {
    bool createFolder = false,
    String? folderName,
  }) async {
    Logger.root.info('Preparing download for ${data['title']}');
    download = true;

    // No need to request storage permissions for downloads since we're using the app's private directory

    final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
    data['title'] = data['title'].toString().split('(From')[0].trim();

    String filename = '';
    final int downFilename = Hive.box(BoxType.downloadSettings.name)
        .get('downFilename', defaultValue: 0) as int;
    if (downFilename == 0) {
      filename = '${data["title"]} - ${data["artist"]}';
    } else if (downFilename == 1) {
      filename = '${data["artist"]} - ${data["title"]}';
    } else {
      filename = '${data["title"]}';
    }

    // Get the app's private directory for downloads
    final Directory appDir = await getApplicationDocumentsDirectory();
    String dlPath = appDir.path;

    Logger.root.info('Download path: $dlPath');

    if (filename.length > 200) {
      final String temp = filename.substring(0, 200);
      final List tempList = temp.split(', ');
      tempList.removeLast();
      filename = tempList.join(', ');
    }

    filename = '${filename.replaceAll(avoid, "").replaceAll("  ", " ")}.mp3';

    if (createFolder && createDownloadFolder && folderName != null) {
      final String foldername = folderName.replaceAll(avoid, '');
      dlPath = '$dlPath/$foldername';
      if (!await Directory(dlPath).exists()) {
        Logger.root.info('Creating folder $foldername');
        await Directory(dlPath).create();
      }
    }

    final bool exists = await File('$dlPath/$filename').exists();
    if (exists) {
      Logger.root.info('File already exists');
      if (remember.value == true && rememberOption != null) {
        switch (rememberOption) {
          case 0:
            lastDownloadId = data['id'].toString();
            break;
          case 1:
            downloadSong(context, dlPath, filename, data);
            break;
          case 2:
            while (await File('$dlPath/$filename').exists()) {
              filename = filename.replaceAll('.mp3', ' (1).mp3');
            }
            break;
          default:
            lastDownloadId = data['id'].toString();
            break;
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var textButton = TextButton(
              onPressed: () {
                lastDownloadId = data['id'].toString();
                Navigator.pop(context);
                rememberOption = 0;
              },
              child: Text(
                context.loc.no,
              ),
            );
            return AlertDialog(
              title: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      Images.zmareIconWhite,
                      height: 25,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      context.loc.alreadyExists,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    '"${data['title']}" ${context.loc.downAgain}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              actions: [
                // Remember Choice Checkbox
                ValueListenableBuilder(
                  valueListenable: remember,
                  builder: (BuildContext context, bool rememberValue,
                      Widget? child) {
                    return Row(
                      children: [
                        Checkbox(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: rememberValue,
                          onChanged: (bool? value) {
                            remember.value = value ?? false;
                          },
                        ),
                        Text(
                          context.loc.rememberChoice,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Replace Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      Hive.box(BoxType.downloads.name).delete(data['id']);
                      downloadSong(context, dlPath, filename, data);
                      rememberOption = 1;
                    },
                    child: Text(
                      context.loc.yesReplace,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.loc.cancel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // // Replace Button
                    // TextButton(
                    //   onPressed: () async {
                    //     Navigator.pop(context);
                    //     Hive.box(BoxType.downloads.name).delete(data['id']);
                    //     downloadSong(context, dlPath, filename, data);
                    //     rememberOption = 1;
                    //   },
                    //   child: Text(
                    //     context.loc.yesReplace,
                    //     style: TextStyle(
                    //       color: Theme.of(context).colorScheme.error,
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(width: 8),

                    // Download Anyway Button
                    OutlinedButton(
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor:
                      //       Theme.of(context).colorScheme.secondary,
                      //   foregroundColor:
                      //       Theme.of(context).colorScheme.onSecondary,
                      // ),
                      onPressed: () async {
                        Navigator.pop(context);
                        while (await File('$dlPath/$filename').exists()) {
                          filename = filename.replaceAll('.mp3', ' (1).mp3');
                        }
                        rememberOption = 2;
                        downloadSong(context, dlPath, filename, data);
                      },
                      child: Text(
                        context.loc.yes,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    } else {
      downloadSong(context, dlPath, filename, data);
    }
  }

  Future<void> downloadSong(
    BuildContext context,
    String? dlPath,
    String fileName,
    Map data,
  ) async {
    progress = null;
    notifyListeners();
    String? filepath;
    late String filepath2;
    String? appPath;
    final List<int> bytes = [];
    String lyrics = '';
    final artname = fileName.replaceAll('.mp3', '.jpg');

    // Get the app's private directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    appPath = appDir.path;

    try {
      Logger.root.info('Creating audio file $dlPath/$fileName');
      await File('$dlPath/$fileName')
          .create(recursive: true)
          .then((value) => filepath = value.path);
      Logger.root.info('Creating image file $appPath/$artname');
      await File('$appPath/$artname')
          .create(recursive: true)
          .then((value) => filepath2 = value.path);
    } catch (e) {
      Logger.root.info('Error creating files: $e');
      return;
    }

    String kUrl = data['url'].toString();

    final client = Client();
    final response = await client.send(Request('GET', Uri.parse(kUrl)));
    final int total = response.contentLength ?? 0;
    int recieved = 0;
    response.stream.asBroadcastStream();
    response.stream.listen((value) {
      bytes.addAll(value);
      try {
        recieved += value.length;
        progress = recieved / total;
        notifyListeners();
        if (!download) {
          client.close();
        }
      } catch (e) {
        Logger.root.info('Error updating progress: $e');
      }
    }).onDone(() async {
      if (download) {
        final file = File(filepath!);
        await file.writeAsBytes(bytes);

        final client = HttpClient();
        final HttpClientRequest request2 =
            await client.getUrl(Uri.parse(data['image'].toString()));
        final HttpClientResponse response2 = await request2.close();
        final bytes2 = await consolidateHttpClientResponseBytes(response2);
        final File file2 = File(filepath2);

        await file2.writeAsBytes(bytes2);
        try {
          Logger.root.info('Checking if lyrics required');
          if (downloadLyrics && data['lyrics'] != null) {
            Logger.root.info('downloading lyrics');
            final Response res = await get(
              Uri.parse(data['lyrics']),
              headers: {'Accept': 'application/json;charset=utf-8'},
            );
            if (res.statusCode == 200) {
              lyrics = utf8.decode(res.bodyBytes);
            }
          }
        } catch (e) {
          Logger.root.severe('Error fetching lyrics: $e');
          lyrics = '';
        }
        if (Platform.isAndroid) {
          try {
            final Tag tag = Tag(
              title: data['title'].toString(),
              artist: data['artist'].toString(),
              albumArtist: data['album_artist']?.toString() ??
                  data['artist']?.toString().split(', ')[0],
              artwork: filepath2,
              album: data['album'].toString(),
              genre: data['genre'].toString(),
              year: data['year'].toString(),
              lyrics: lyrics,
              comment: data['genre'].toString(),
            );
            final tagger = Audiotagger();
            await tagger.writeTags(
              path: filepath!,
              tag: tag,
            );
          } catch (e) {
            Logger.root.severe('Error editing tags: $e');
          }
        } else {
          // Set metadata to file
          await MetadataGod.writeMetadata(
            file: filepath!,
            metadata: Metadata(
              title: data['title'].toString(),
              artist: data['artist'].toString(),
              album: data['album'].toString(),
              genre: data['genre'].toString(),
              year: int.parse(data['year'].toString()),
              fileSize: file.lengthSync(),
              picture: Picture(
                data: File(filepath2).readAsBytesSync(),
                mimeType: 'image/jpeg',
              ),
            ),
          );
        }
        Logger.root.info('Closing connection & notifying listeners');
        client.close();
        lastDownloadId = data['id'].toString();
        progress = 0.0;
        notifyListeners();

        Logger.root.info('Putting data to downloads database');

        final songData = {
          'id': data['id'].toString(),
          'title': data['title'].toString(),
          'subtitle': data['subtitle'].toString(),
          'artist': data['artist'].toString(),
          'albumArtist': data['album_artist']?.toString() ??
              data['artist']?.toString().split(', ')[0],
          'album': data['album'].toString(),
          'genre': data['genre'].toString(),
          'year': data['year'].toString(),
          'lyrics': lyrics,
          'duration': data['duration'],
          'release_date': data['release_date'].toString(),
          'album_id': data['album_id'].toString(),
          'perma_url': data['perma_url'].toString(),
          'path': filepath,
          'image': filepath2,
          'image_url': data['image'].toString(),
          'dateAdded': DateTime.now().toString(),
        };
        //Add download count to server
        final AuthBloc authBloc = locator.get<AuthBloc>();
        authBloc.add(AddDownloadEvent(songData['id']));
        Hive.box(BoxType.downloads.name)
            .put(songData['id'].toString(), songData);
        context.showMaterialSnackBar(
            '"${data['title'].toString()}" ${context.loc.downed}');
      } else {
        download = true;
        progress = 0.0;
        File(filepath!).delete();
        File(filepath2).delete();
      }
    });
  }
}
