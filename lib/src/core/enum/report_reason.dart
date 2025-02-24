import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

enum ReportReason {
  copyright,
  other;

  int get toIndex {
    switch (this) {
      case ReportReason.copyright:
        return 0;
      case ReportReason.other:
        return 1;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case ReportReason.copyright:
        return context.loc.report_ci;
      case ReportReason.other:
        return context.loc.others;
    }
  }
}
