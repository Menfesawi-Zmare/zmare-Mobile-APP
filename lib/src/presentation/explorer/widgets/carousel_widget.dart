import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/data/explorer/model/explorer_model.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key, required this.banners});
  final List<BannerModel>? banners;
  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: CarouselSlider(
        items: widget.banners!
            .map((item) => InkWell(
                  onTap: () {
                    // PlayerInvoke.init(
                    //   songsList:
                    //       widget.songList!.map((e) => e.toJson()).toList(),
                    //   index: widget.songList!
                    //       .map((e) => e.toJson())
                    //       .toList()
                    //       .indexWhere((element) => element['id'] == item.id),
                    //   isOffline: false,
                    // );
                  },
                  child: AspectRatio(
                    aspectRatio: 50 / 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14.0)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              KhmertracksImage(
                                imageUrl: item.image!,
                                placeholderImage: Images.defalultArtistCover,
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      '', // item.title!,'
                                      overflow: TextOverflow.ellipsis,
                                      style: context.titleMedium!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ],
                          )),
                    ),
                  ),
                ))
            .toList(),
        carouselController: _controller,
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true, // Keep this true for smooth scaling effect
          aspectRatio: 2.45, // Adjust to your desired aspect ratio
          viewportFraction: 1.0, // Ensures one slide takes up the full viewport
          onPageChanged: (index, reason) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
