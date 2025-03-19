import 'package:flutter/material.dart';
import 'dart:convert'; // Add this import for jsonDecode
// import 'package:material_color_utilities/quantize/quantizer_wu.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/homepage_track_type.dart';
import 'package:zmare/src/presentation/account/pages/account_page.dart';
import 'package:zmare/src/presentation/explorer/pages/explorer_page.dart';
import 'package:zmare/src/presentation/library/pages/library_page.dart';
import 'package:zmare/src/presentation/login/intro/intro_page.dart';
import 'package:zmare/src/presentation/track/pages/track_page.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_icon_title.dart';
import 'package:zmare/src/presentation/widgets/search_button.dart';

import '../../../service_locator.dart';
import '../../../utils/ext/common.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({
    super.key,
    required this.currentPage,
  });

  final int currentPage;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget>
    with AutomaticKeepAliveClientMixin {
  final account =
      locator.get<Box<dynamic>>(instanceName: BoxType.account.name).listenable(
    keys: [accountDetail],
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      // Use ValueListenableBuilder to rebuild the body when accountJson changes
      body: ValueListenableBuilder(
        valueListenable: account,
        builder: (context, box, child) {
          final accountJson = box.get(accountDetail, defaultValue: '');

          final Map<int, Widget> pages = {
            0: const ExplorerPage(),
            1: TrackPage(type: HomepageTrackType.latest.toName),
            2: TrackPage(type: HomepageTrackType.popular.toName),
            3: const LibraryPage(),
            4: accountJson.isNotEmpty ? const AccountPage() : const IntroPage(),
          };

          return pages[widget.currentPage]!;
        },
      ),
    );
  }
}
