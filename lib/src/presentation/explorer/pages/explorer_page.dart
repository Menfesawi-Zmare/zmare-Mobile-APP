import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/enum/box_types.dart';
import '../../../core/resources/images.dart';

import '../../../service_locator.dart';
import '../../../utils/ext/common.dart';
import '../../../utils/helper/app_info.dart';

import 'explorer_mobile_page.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    _checkAppVersion();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  String? appUrl;
  String? localVersion;
  int? isMust;

  void _checkAppVersion() async {
    final settings = locator.get<Box<dynamic>>(
      instanceName: BoxType.settings.name,
    );

    appUrl = settings.get(Platform.isAndroid ? playStoreUrl : appStoreUrl,
        defaultValue: null);

    localVersion = await AppInfoService.getCurrentAppVersion();

    final keyLatestVersion = settings.get(latestVersion);
    final mandatoryString = settings.get(isMandatory);
    isMust = int.tryParse(mandatoryString ?? '0');

    // Compare versions
    if (AppInfoService.isNewVersionAvailable(
        localVersion!, keyLatestVersion.toString())) {
      _showUpdateDialog(context, isMust!, keyLatestVersion.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isMust == 1) _checkAppVersion();
    } else if (state == AppLifecycleState.inactive) {
      if (isMust == 1) _checkAppVersion();
    } else if (state == AppLifecycleState.paused) {
      if (isMust == 1) _checkAppVersion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => const ExplorerMobilePage(),
    );
  }

  void _showUpdateDialog(
      BuildContext context, int isMandatory, String latestVersion) {
    showDialog(
      context: context,

      barrierDismissible: isMandatory == 0,
      //  !isMandatory, // Prevent closing if mandatory
      builder: (BuildContext context) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (isMandatory == 1) SystemNavigator.pop();
          },
          child: AlertDialog(
            content: SizedBox(
              height: 250, // Set the desired height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Images.zmareIconWhite,
                    height: 100,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Update Required',
                    style: context.headlineLarge?.copyWith(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'A new version $latestVersion is available. Please update the app to continue.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: isMandatory == 1
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (isMandatory == 0)
                    TextButton(
                      child: Text('Later'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  OutlinedButton(
                    child: Text('Update Now'),
                    onPressed: () {
                      _launchAppStore();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _launchAppStore() async {
    if (await canLaunchUrl(Uri.parse(appUrl!))) {
      await launchUrl(Uri.parse(appUrl!));
    } else {
      throw 'Could not launch $appUrl';
    }
  }
}
