import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';

class CarouselImagePreview extends StatefulWidget {
  final List<String> imageIds;
  const CarouselImagePreview({super.key, required this.imageIds});

  @override
  State<CarouselImagePreview> createState() => _CarouselImagePreviewState();
}

class _CarouselImagePreviewState extends State<CarouselImagePreview> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageIds.map((imageId) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(8),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return ref.read(tweetImagesPreviewProvider(imageId)).when(
                            data: (data) => Image.memory(
                              data,
                              fit: BoxFit.cover,
                            ),
                            error: (e, _) => ErrorText(error: e.toString()),
                            loading: () => Shimmer.fromColors(
                              baseColor: Colors.red,
                              highlightColor: Colors.yellow,
                              child: const Loader(),
                            ),
                          );
                    },
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                  // height: 400,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            if (widget.imageIds.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageIds.asMap().entries.map(
                  (e) {
                    return Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                            .withOpacity(_current == e.key ? 0.9 : 0.4),
                      ),
                    );
                  },
                ).toList(),
              ),
          ],
        ),
      ],
    );
  }
}
