enum ReportType {
  comment,
  track;

  int get toIndex {
    switch (this) {
      case ReportType.comment:
        return 0;
      case ReportType.track:
        return 1;
    }
  }
}
