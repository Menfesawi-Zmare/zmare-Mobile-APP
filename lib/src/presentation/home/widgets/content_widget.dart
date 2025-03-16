import 'package:flutter/material.dart';
import 'package:zmare/src/core/enum/homepage_track_type.dart';
import 'package:zmare/src/presentation/explorer/pages/explorer_page.dart';
import 'package:zmare/src/presentation/home/widgets/user_widget.dart';
import 'package:zmare/src/presentation/library/pages/library_page.dart';
import 'package:zmare/src/presentation/login/intro/intro_page.dart';
import 'package:zmare/src/presentation/track/pages/track_page.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_icon_title.dart';
import 'package:zmare/src/presentation/widgets/search_button.dart';

class ContentWidget extends StatefulWidget {
  ContentWidget({
    super.key,
    required this.currentPage,
  });

  final int currentPage;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget>
    with AutomaticKeepAliveClientMixin {
  final Map<int, Widget> pages = {
    0: const ExplorerPage(),
    1: TrackPage(type: HomepageTrackType.latest.toName),
    2: TrackPage(type: HomepageTrackType.popular.toName),
    3: const LibraryPage(),
    4: const IntroPage()
  };

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: widget.currentPage == 4
            ? null // No AppBar when currentPage is 4
            : AppBar(
                title: const KhmertracksIconTitle(),
                actions: const [
                  SearchButton(),
                  // UserWidget(),
                  SizedBox(width: 8),
                ],
              ),
        body: pages[widget.currentPage]);
  }
}
