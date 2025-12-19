import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBannerSection extends StatefulWidget {
  const HomeBannerSection({super.key});

  @override
  State<HomeBannerSection> createState() => _HomeBannerSectionState();
}

class _HomeBannerSectionState extends State<HomeBannerSection> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<String> _images = const [
    AssetsManager.homeBanner,
    AssetsManager.homeBanner,
    AssetsManager.homeBanner,
  ];

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: _images.length,
          itemBuilder: (context, index, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.asset(
                _images[index],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: 190,
            autoPlay: true,
            viewportFraction: 0.98,
            enlargeCenterPage: true,
            onPageChanged: (index, _) {
              _currentIndex.value = index;
            },
          ),
        ),

        const SizedBox(height: 10),
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, index, _) {
            return AnimatedSmoothIndicator(
              activeIndex: index,
              count: _images.length,
              effect: const WormEffect(
                dotHeight: 13,
                dotWidth: 13,
                activeDotColor: ColorsManager.primaryColor,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
