import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBannerSection extends StatefulWidget {
  const HomeBannerSection({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<HomeBannerSection> createState() => _HomeBannerSectionState();
}

class _HomeBannerSectionState extends State<HomeBannerSection> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.getBannersState != current.getBannersState,
      builder: (context, state) => UiStateBuilder(
        state: state.getBannersState,
        onLoading: Skeletonizer(
          effect: ShimmerEffect(
            baseColor: ColorsManager.skeletonColor,
            highlightColor: ColorsManager.skeletonColor.withValues(alpha: .6),
          ),
          child: _buildHomeBanners(banners: ["", "", ""]),
        ),
        onSuccess: _buildHomeBanners(banners: state.banners),
        errorMessage: state.bannersErrorMessage,
        theme: widget.theme,
      ),
    );
  }

  Column _buildHomeBanners({required List<String> banners}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, _) {
            return Skeleton.replace(
              replacement: Container(
                width: double.infinity,
                height: 190,
                color: ColorsManager.skeletonColor,
              ),
              child: CustomCachedNetworkImage(
                imageUrl: banners[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 190,
              ),
            );
          },
          options: CarouselOptions(
            height: 190,
            autoPlay: true,
            viewportFraction: 1.1,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padEnds: false,
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
              count: banners.length,
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
