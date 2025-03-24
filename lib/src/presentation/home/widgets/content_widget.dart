import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert'; // Add this import for jsonDecode
// import 'package:material_color_utilities/quantize/quantizer_wu.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/homepage_track_type.dart';
import 'package:zmare/src/presentation/account/pages/account_page.dart';
import 'package:zmare/src/presentation/explorer/pages/explorer_page.dart';
import 'package:zmare/src/presentation/library/pages/library_page.dart';
import 'package:zmare/src/presentation/login/intro/intro_page.dart';
import 'package:zmare/src/presentation/track/pages/track_page.dart';
import 'package:zmare/src/presentation/widgets/zmare_icon_title.dart';
import 'package:zmare/src/presentation/widgets/search_button.dart';

import '../../../service_locator.dart';
import '../../../utils/ext/common.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../network/bloc/network_bloc.dart';

class ContentWidget extends StatefulWidget {
  ContentWidget({
    super.key,
    required this.currentPage,
    this.isLoggedIn,
  });

  final int currentPage;
  bool? isLoggedIn;

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
              title: const ZmareIconTitle(),
              actions: const [
                SearchButton(),
                // UserWidget(),
                SizedBox(width: 8),
              ],

      body: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) {
          if (state is NetworkSuccess) {
            // ScaffoldMessenger.of(context).clearSnackBars();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: SizedBox(
            //       height: 20,
            //       child: Text(
            //         'You are back online!',
            //         style: context.titleSmall,
            //       ),
            //     ),
            //     backgroundColor: context.onPrimary,
            //   ),
            // );
          } else if (state is NetworkFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(minutes: 3),
                content: SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'You are offline.',
                        style: context.titleSmall,
                      ),
                      TextButton(
                          style:
                              TextButton.styleFrom(padding: EdgeInsets.all(0)),
                          onPressed: () {
                            context.pushNamed(downloadsPath);
                            ScaffoldMessenger.of(context).clearSnackBars();
                          },
                          child: Text(
                            "Downloads",
                            style: context.bodySmall,
                          ))
                    ],

      // Use ValueListenableBuilder to rebuild the body when accountJson changes
      body: ValueListenableBuilder(
        valueListenable: account,
        builder: (context, box, child) {
          final accountJson = box.get(accountDetail, defaultValue: '');

          final Map<int, Widget> pages = {
            0: const ExplorerPage(),
            1: TrackPage(type: HomepageTrackType.latest.toName),
            2: TrackPage(type: HomepageTrackType.popular.toName),
            3: LibraryPage(),
            4: accountJson.isNotEmpty
                ? const AccountPage()
                : IntroPage(
                    showBackButton: widget.isLoggedIn ?? false,
                    introPageIndex: widget.currentPage,

                  ),
                ),
                backgroundColor: context.onPrimary,
              ),
            );
          }
        },
        // Use ValueListenableBuilder to rebuild the body when accountJson changes
        child: ValueListenableBuilder(
          valueListenable: account,
          builder: (context, box, child) {
            final accountJson = box.get(accountDetail, defaultValue: '');

            final Map<int, Widget> pages = {
              0: const ExplorerPage(),
              1: TrackPage(type: HomepageTrackType.latest.toName),
              2: TrackPage(type: HomepageTrackType.popular.toName),
              3: const LibraryPage(),
              4: accountJson.isNotEmpty
                  ? const AccountPage()
                  : IntroPage(
                      introPageIndex: widget.currentPage,
                    ),
            };

            return pages[widget.currentPage]!;
          },
        ),
      ),
    );
  }
}
