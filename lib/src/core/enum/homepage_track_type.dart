enum HomepageTrackType {
  latest,
  popular,
  random;

  String get toName {
    switch (this) {
      case HomepageTrackType.latest:
        return 'latest';
      case HomepageTrackType.popular:
        return 'popular';
      case HomepageTrackType.random:
        return 'random';
    }
  }
}
