enum BoxType {
  explorer('explorer'),
  latest('latest'),
  popular('popular'),
  random('random'),
  settings('settings'),
  profile('profile'),
  favorite('favorite'),
  downloads('downloads'),
  cache('cache'),
  search('search'),
  player('player'),
  playlists('playlists'),
  myMusic('myMusic'),
  downloadSettings('downloadSettings'),
  account('account'),
  grid('grid');
  final String name;

  const BoxType(this.name);
}
