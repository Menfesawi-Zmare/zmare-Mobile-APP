enum FavoriteType {
  like,
  dislike;

  int get toInt {
    switch (this) {
      case FavoriteType.like:
        return 1;
      case FavoriteType.dislike:
        return 2;
    }
  }
}