import 'package:flutter/material.dart';
import 'package:zmare/src/core/enum/homepage_track_type.dart';
import 'package:zmare/src/presentation/explorer/pages/explorer_page.dart';
import 'package:zmare/src/presentation/home/widgets/user_widget.dart';
import 'package:zmare/src/presentation/library/pages/library_page.dart';
import 'package:zmare/src/presentation/track/pages/track_page.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_icon_title.dart';
import 'package:zmare/src/presentation/widgets/search_button.dart';

class ContentWidget extends StatelessWidget {
  ContentWidget({
    super.key,
    required this.currentPage,
  });
  final int currentPage;
  final Map<int, Widget> pages = {
    0: const ExplorerPage(),
    1: TrackPage(type: HomepageTrackType.latest.toName),
    2: TrackPage(type: HomepageTrackType.popular.toName),
    3: TrackPage(type: HomepageTrackType.random.toName),
    4: const LibraryPage(),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const KhmertracksIconTitle(),
          actions: const [
            SearchButton(),
            UserWidget(),
            SizedBox(width: 8),
          ],
        ),
        body: pages[currentPage]);
  }
}
