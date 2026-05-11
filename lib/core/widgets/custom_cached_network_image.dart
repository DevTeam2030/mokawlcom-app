import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.of(context).devicePixelRatio;

        double? displayWidth = width;
        if (constraints.hasBoundedWidth && constraints.maxWidth > 0) {
          displayWidth = displayWidth != null
              ? math.min(displayWidth, constraints.maxWidth)
              : constraints.maxWidth;
        }

        double? displayHeight = height;
        if (constraints.hasBoundedHeight && constraints.maxHeight > 0) {
          displayHeight = displayHeight != null
              ? math.min(displayHeight, constraints.maxHeight)
              : constraints.maxHeight;
        }

        final int? cacheWidth =
            displayWidth != null &&
                displayWidth != double.infinity &&
                displayWidth > 0
            ? (displayWidth * dpr).round()
            : null;

        final int? cacheHeight =
            displayHeight != null &&
                displayHeight != double.infinity &&
                displayHeight > 0
            ? (displayHeight * dpr).round()
            : null;

        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: displayWidth,
          height: displayHeight,
          fit: fit,
          memCacheWidth: cacheWidth,
          memCacheHeight: cacheHeight,
          errorWidget: (context, url, error) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.error),
          ),
        );
      },
    );
  }
}
