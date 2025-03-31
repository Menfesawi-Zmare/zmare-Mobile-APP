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
import '../bloc/home_bloc.dart';

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
            ),
      body: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) async {
          if (state is NetworkSuccess) {
            ScaffoldMessenger.of(context).clearSnackBars();
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

            context
                .read<HomeBloc>()
                .add(CurrentIndexEvent(widget.currentPage == 0
                    ? PageType.explorer
                    : widget.currentPage == 1
                        ? PageType.latest
                        : widget.currentPage == 2
                            ? PageType.popular
                            : widget.currentPage == 3
                                ? PageType.library
                                : PageType.login));
            setState(() {});
          } else if (state is NetworkFailure) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              SnackBar(
                dismissDirection: DismissDirection.horizontal,
                margin: EdgeInsets.only(bottom: 50),
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                backgroundColor: context.onPrimary,
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
                  ),
                ),
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
