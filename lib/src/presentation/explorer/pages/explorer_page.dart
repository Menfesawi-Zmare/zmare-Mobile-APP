import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'explorer_mobile_page.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => const ExplorerMobilePage(),
    );
  }
}
