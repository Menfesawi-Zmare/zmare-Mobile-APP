import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/library_mobile_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => const LibraryMobilePage(),
    );
  }
}
