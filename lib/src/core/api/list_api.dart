class ListAPI {
  ListAPI._();
  //Home
  static const String explorer = "/api/explorer";
  static const String homePageTracks = "/api/tracks/";

  //Artist
  static const String allArtist = "/api/artists";
  static const String artistDetail = "/api/artists/";
  static const String artistTracks = "/api/artists/tracks/";
  static const String artistAlbums = "/api/artists/albums/";
  static const String artistSubscribers = "/api/artists/subscribers/";
  //Album
  static const String album = "/api/albums";
  static const String albumDetail = "/api/albums/";
  static const String productionAlbums = "/api/productions/";
  //Track
  static const String addView = "/api/add/view/";
  static const String addDownload = "/api/add/download/";
  static const String checkFavorite = '/api/check/likes/';
  static const String like = "/api/add/likes";
  static const String addComment = "/api/add/comments/";
  static const String loadComment = "/api/tracks/comments/";
  static const String editComment = "/api/edit/comments/";
  static const String deleteComment = "/api/delete/comments/";
  static const String report = "/api/add/report/";
  //Playlist
  static const String accountPlaylists = "/api/account/playlists";
  static const String playlistTracks = "/api/playlists/";
  static const String checkTrackInPlaylist = "/api/playlists/check/";
  static const String createPlaylist = "/api/playlists/new";
  static const String addToPlaylist = "/api/playlists/add";
  //Search
  static const String searchSuggestions = "/api/search/suggestions/";
  static const String searchUsers = "/api/search/users/";
  static const String searchPlaylists = "/api/search/playlists/";
  static const String searchAlbums = "/api/search/albums/";
  static const String searchTracks = "/api/search/tracks/";
  static const String searchArtists = "/api/search/artists/";
  //Profile
  static const String subscriptions = "/api/profile/subscriptions/";
  static const String subscribers = "/api/profile/subscribers/";
  static const String loadLikes = "/api/profile/likes/";
  static const String userPlaylists = "/api/profile/playlists/";
  static const String updatePlaylist = "/api/playlists/update";
  static const String deletePlaylist = '/api/playlists/delete/';
  //Auth
  static const String register = "/api/register";
  static const String login = "/api/login";
  static const String loginWithSocial = "/api/login/google";
  static const String account = "/api/account";
  static const String logout = "/api/logout";
  static const String resendEmail = "/api/resend-verification-email";
  static const String updateBio = "/api/account/general";
  static const String updateSocial = '/api/account/social';
  static const String updatePassword = "/api/account/password";
  static const String updateAvatar = "/api/account/image";
  static const String updateCover = "/api/account/cover";
  static const String deleteAccount = "/api/account/delete";
  static const String subscribe = "/api/account/subscribe/";
  static const String checkSubscribe = "/api/account/check/subscribe/";
  //Stream
  static const String streamTracks = "/api/stream";
  //Production
  static const String production = "/api/productions";
  //APP Settings
  static const String settings = "/api/settings";

  //RequestReset
  static const String requestReset = "/api/forgot-password";

  //verify otp
  static const String verifyOTP = "/api/verify-otp";

  //reset Password
  static const String resetPassword = "/api/reset-password";
}
