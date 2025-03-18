import 'dart:ui';

const String baseUrl = 'http://192.168.100.199:8000';
//Font
const defaultFontName = 'Poppins';
const String androidNotificationChannelName = 'zmare';
const String androidNotificationChannelId = 'com.zmare.pro';

const String themeModeKey = 'key_theme_mode';
const String appColorKey = 'key_app_color';
const String dynamicThemeKey = 'keydynamicColor';
const String userIntroKey = 'user_intro_key';
const String userNameKey = 'user_name_key';
const String userImageKey = 'user_image_key';
const String appLanguageKey = 'user_laguage_key';
const String appFontChangerKey = "app_font_changer_key";
const String circularPlayButtonKey = 'circular_play_button_key';
const String artistGridKey = 'arist_grid_key';
const String albumGridKey = 'album_grid_key';
const String playlistGridKey = 'playlist_grid_key';
const String productionGridKey = 'production_grid_key';
const String extraControlsKey = 'extra_control_key';
const String searchKey = "key_search";
const String accessToken = 'token';
const String accountDetail = 'account_detail';
const String loginType = 'login_type';
//API App Settings
const String explorerPerPage = 'key_e_per_page';
const String facebookUrl = 'key_facebook';
const String youtubeUrl = 'key_youtube';
const String telegramUrl = 'key_telegram';
const String instagramUrl = 'key_instagram';
const String twitterUrl = 'key_twitter';
const String playStoreUrl = 'key_playstore';
const String appStoreUrl = 'key_appstore';
const String tosUrl = 'key_tos';
const String privacyUrl = 'key_privacy';
const String androidExplorerAd = 'key_android_explorer_ad';
const String androidInterstitialAd = 'key_android_interstitial_ad';
const String androidMaxInterstitialAdClick =
    'key_android_max_interstitial_ad_click';
const String androidAppOpenAd = 'key_android_app_open_ad';
const String iosExplorerAd = 'key_ios_explorer_ad';
const String iosInterstitialAd = 'key_ios_interstitial_ad';
const String iosMaxInterstitialAdClick = 'key_ios_max_interstitial_ad_click';
const String iosAppOpenAd = 'key_ios_app_open_ad';
const String androidExplorerStatus = 'key_android_explorer_status';
const String androidAppOpenStatus = 'key_android_app_open_status';
const String iosExplorerStatus = 'key_ios_explorer_status';
const String androidInterstitialStatus = 'key_android_interstitial_status';
const String iosInterstitialStatus = 'key_ios_interstitial_status';
const String iosAppOpenStatus = 'key_ios_app_open_status';
const String latestVersion = 'Key_latestVersion';
const String isMandatory = 'Key_isMandatory';
const String minRequiredVersion = 'Key_minRequiredVersion';

//Player
const String playerRepeatMode = 'repeatMode';

//Color
const facebookColor = 0xFF415893;
const gmailColor = 0xFFc71610;
const appleColor = 0xFF66b447;
const List<Color?> defaultGradientColor = [
  Color(0xff2e2a33),
  Color(0xff141216)
];

//Route
const onboardingPath = '/onboarding';
const onboardingName = 'onboarding';
const homePagePath = '/homepage';
const homePageName = 'homepage';
const latestPagePath = '/latest';
const popularPagePath = '/popular';
const randomPagePath = '/random';
const libraryPagePath = '/library';
const loginPath = '/login';
const loginName = 'login';
const userNamePath = '/user-name';
const userImagePath = '/user-image';
const landingPath = '/landing';
const landingName = 'landing';
const explorerPath = 'explorer';
const latestPath = 'latest';
const popularPath = 'popular';
const randomPath = 'random';
const profilePath = 'profile';
const libraryPath = 'library';
const likesPath = 'likes';
const signInPath = '/signin';
const signInName = 'signin';
const verifyAccountPath = '/verifyAccount';
const verifyAccountName = 'verifyAccount';
const signUpPath = '/signup';
const signUpName = 'signup';
const allArtistPath = 'all-artists';
const allPlaylistsPath = 'all-playlists';
const allProductionPath = 'all-productions';
const allAlbumPath = 'all-albums';
const customArtistPath = 'custom-artists';
const customAlbumPath = 'custom-albums';
const customProductionPath = 'custom-productions';
const artistPath = 'artist';
const allArtistAlbumsPath = 'artist-albums';
const allArtistSongsPath = 'artist-songs';
const artistFollowersPath = 'artist-followers';
const albumSongsPath = 'album-songs';
const viewProductionAlbumsPath = 'production-albums';
const viewPlaylistsPath = 'view-playlist';
const viewProfilePath = 'view-profile';
const myMusicPath = 'my-music-path';
const myMusicName = 'my-music-path';
const myMusicDetailPath = 'my-music-detail-path';
const myMusicDetailName = 'my-music-detail-path';
const downloadsPath = 'downloads';
const recentlyPath = 'recently';
const nowPlayingPath = 'now-playing';
const searchPath = 'search';
const searchName = 'search';
const settingsPath = 'settings';
const settingsName = 'settings';
const streamPath = 'stream';
const streamName = 'stream';
const subscriptionsPath = 'subscriptions';
const subscriptionsName = 'subscriptions';
const personalizeName = 'personalize';
const personalizePath = 'personalize';
const userPlaylistPath = 'user-playlist';
const userPlaylistName = 'user-playlist';
const playerPath = 'player';
const accountPath = 'account';
const editProfilePath = 'edit-profile';
const editBioPath = 'edit-bio';
const editSocialPath = 'edit-social';
const changePasswordPath = 'change-password';
const deleteAccountPath = 'delete-account';
const showSongName = 'show-song';
const showSongPath = 'show-song';
