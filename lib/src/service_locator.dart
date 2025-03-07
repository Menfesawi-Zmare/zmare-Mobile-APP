import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/utils/helper/constants.dart';
import 'package:zmare/src/utils/services/audio/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zmare/src/core/api/api.dart';
import 'package:zmare/src/data/album/data_sources/album_data_source.dart';
import 'package:zmare/src/data/album/repository/album_repository_impl.dart';
import 'package:zmare/src/data/artist/data_source/artist_data_source.dart';
import 'package:zmare/src/data/artist/repository/artist_repository_impl.dart';
import 'package:zmare/src/data/auth/data_sources/auth_data_source.dart';
import 'package:zmare/src/data/auth/repository/auth_repository_impl.dart';
import 'package:zmare/src/data/explorer/data_source/explorer_data_source.dart';
import 'package:zmare/src/data/explorer/repository/explorer_impl.dart';
import 'package:zmare/src/data/track/repositoy/track_repository_impl.dart';
import 'package:zmare/src/data/playlist/data_sources/playlist_data_source.dart';
import 'package:zmare/src/data/playlist/repository/playlist_repository_impl.dart';
import 'package:zmare/src/data/profile/data_sources/profile_data_source.dart';
import 'package:zmare/src/data/profile/repository/profile_repository_impl.dart';
import 'package:zmare/src/data/search/data_sources/search_data_source.dart';
import 'package:zmare/src/data/search/repository/search_repository_impl.dart';
import 'package:zmare/src/domain/album/repository/album_repository.dart';
import 'package:zmare/src/domain/artist/repository/artist_repository.dart';
import 'package:zmare/src/domain/auth/repository/auth_repository.dart';
import 'package:zmare/src/domain/explorer/repository/explorer_repository.dart';
import 'package:zmare/src/domain/track/repository/track_repository.dart';
import 'package:zmare/src/domain/playlist/repository/playlist_repository.dart';
import 'package:zmare/src/domain/profile/repository/profile_repository.dart';
import 'package:zmare/src/domain/search/repository/search_repository.dart';
import 'package:zmare/src/presentation/album/bloc/album_bloc.dart';
import 'package:zmare/src/presentation/explorer/bloc/bloc/explorer_bloc.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:zmare/src/presentation/search/bloc/search_bloc.dart';
import 'package:zmare/src/presentation/track/bloc/track_bloc.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';
import 'core/enum/box_types.dart';
import 'data/track/data_sources/track_data_source.dart';
import 'presentation/artist/bloc/artist_bloc.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/playlist/bloc/playlist_bloc.dart';
import 'dart:developer';
import 'dart:io';

import 'package:logging/logging.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  await _setupHive();
  if (!locator.isRegistered<AudioPlayerHandler>()) {
    final AudioPlayerHandler audioHandler = await _startAudioService();
    locator.registerSingleton<AudioPlayerHandler>(audioHandler);
  }

  _setupDataDependencies();
  _setupRepository();
  _setupBloc();
}

Future<void> _setupHive() async {
  await Hive.initFlutter();
  final boxDynamic = await Hive.openBox(BoxType.settings.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxDynamic,
      instanceName: BoxType.settings.name);
  final boxFavorite = await Hive.openBox(BoxType.favorite.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxFavorite,
      instanceName: BoxType.favorite.name);
  final boxDownload = await Hive.openBox(BoxType.downloads.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxDownload,
      instanceName: BoxType.downloads.name);
  final boxCache = await Hive.openBox(BoxType.cache.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxCache,
      instanceName: BoxType.cache.name);
  final boxSearch = await Hive.openBox(BoxType.search.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxSearch,
      instanceName: BoxType.search.name);
  final boxPlayer = await Hive.openBox(BoxType.player.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxPlayer,
      instanceName: BoxType.player.name);
  final boxPlaylists = await Hive.openBox(BoxType.playlists.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxPlaylists,
      instanceName: BoxType.playlists.name);
  final boxDownloadSettings = await Hive.openBox(BoxType.downloadSettings.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxDownloadSettings,
      instanceName: BoxType.downloadSettings.name);
  final boxMyMusic = await Hive.openBox(BoxType.myMusic.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxMyMusic,
      instanceName: BoxType.myMusic.name);
  final boxAccount = await Hive.openBox(BoxType.account.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxAccount,
      instanceName: BoxType.account.name);
  final boxGrid = await Hive.openBox(BoxType.grid.name);
  locator.registerLazySingleton<Box<dynamic>>(() => boxGrid,
      instanceName: BoxType.grid.name);
}

Future<AudioPlayerHandler> _startAudioService() async {
  initializeLogging();
  MetadataGod.initialize();

  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: androidNotificationChannelId,
      androidNotificationChannelName: androidNotificationChannelName,
      androidNotificationIcon: 'drawable/splash',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: false,
      notificationColor: Colors.grey[900],
    ),
  );

  return audioHandler; // Return the initialized handler
}

Future<void> initializeLogging() async {
  final Directory tempDir = await getTemporaryDirectory();
  final File logFile = File('${tempDir.path}/logs/logs.txt');
  if (!await logFile.exists()) {
    await logFile.create(recursive: true);
  }
  // clear old session data
  await logFile.writeAsString('');
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) async {
    if (record.level.name != 'INFO') {
      log('${record.level.name}: ${record.time}: record.message: ${record.message}\nrecord.error: ${record.error}\nrecord.stackTrace: ${record.stackTrace}\n\n');
      try {
        await logFile.writeAsString(
          '${record.level.name}: ${record.time}: record.message: ${record.message}\nrecord.error: ${record.error}\nrecord.stackTrace: ${record.stackTrace}\n\n',
          mode: FileMode.append,
        );
      } catch (e) {
        log('Error writing to log file: $e');
      }
    } else {
      log('${record.level.name}: ${record.time}: record.message: ${record.message}\n\n');
      try {
        await logFile.writeAsString(
          '${record.level.name}: ${record.time}: record.message: ${record.message}\n\n',
          mode: FileMode.append,
        );
      } catch (e) {
        log('Error writing to log file: $e');
      }
    }
  });
}

void _setupDataDependencies() {
  locator.registerSingleton<DioClient>(DioClient());
  locator.registerLazySingleton<IExplorerDataSource>(
      () => ExplorerDataSource(locator()));
  locator.registerLazySingleton<IArtistDataSource>(
      () => ArtistDataSource(locator()));
  locator.registerLazySingleton<ITrackDataSource>(
      () => TrackDataSource(locator()));
  locator.registerLazySingleton<IAlbumDataSource>(
      () => AlbumDataSource(locator()));
  locator.registerLazySingleton<ISearchDataSources>(
      () => SearchDataSources(locator()));
  locator.registerLazySingleton<IPlaylistDataSource>(
      () => PlaylistDataSource(locator()));
  locator.registerLazySingleton<IProfileDataSource>(
      () => ProfileDataSource(locator()));
  locator
      .registerLazySingleton<IAuthDataSource>(() => AuthDataSource(locator()));
}

void _setupRepository() {
  locator.registerFactory<IExplorerRepository>(() => ExplorerRepositoryImpl(
      iExplorerDataSource: locator<IExplorerDataSource>()));
  locator.registerFactory<IArtistRepository>(() =>
      ArtistRepositoryImpl(iArtistDataSource: locator<IArtistDataSource>()));
  locator.registerFactory<ITrackRepository>(
      () => TrackRepositoryImpl(iTrackDataSource: locator<ITrackDataSource>()));
  locator.registerFactory<IAlbumRepository>(
      () => AlbumRepositoryImpl(iAlbumDataSource: locator<IAlbumDataSource>()));
  locator.registerFactory<ISearchRepository>(() =>
      SearchRepositoryImpl(iSearchDataSources: locator<ISearchDataSources>()));
  locator.registerFactory<IPlaylistRepository>(() => PlaylistRepositoryImpl(
      iPlaylistDataSource: locator<IPlaylistDataSource>()));
  locator.registerFactory<IProfileRepository>(() =>
      ProfileRepositoryImpl(iProfileDataSource: locator<IProfileDataSource>()));
  locator.registerFactory<IAuthRepository>(
      () => AuthRepositoryImpl(iAuthDataSource: locator<IAuthDataSource>()));
}

void _setupBloc() {
  locator.registerFactory(() =>
      HomeBloc(locator.get<Box<dynamic>>(instanceName: BoxType.settings.name)));
  locator.registerFactory<ExplorerBloc>(
      () => ExplorerBloc(iExplorerRepository: locator.get()));
  locator.registerFactory<ArtistBloc>(
      () => ArtistBloc(iArtistRepository: locator.get()));
  locator.registerFactory<TrackBloc>(
      () => TrackBloc(iTrackRepository: locator.get()));
  locator.registerFactory<AlbumBloc>(
      () => AlbumBloc(iAlbumRepository: locator.get()));
  locator.registerFactory<SearchBloc>(
      () => SearchBloc(iSearchRepository: locator.get()));
  locator.registerFactory<PlaylistBloc>(
      () => PlaylistBloc(iPlaylistRepository: locator.get()));
  locator.registerFactory<ProfileBloc>(
      () => ProfileBloc(iProfileRepository: locator.get()));
  locator.registerFactory<AuthBloc>(
      () => AuthBloc(iAuthRepository: locator.get()));
}
