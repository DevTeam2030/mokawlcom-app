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
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width ?? double.infinity,
      height: height,
      fit: fit,
      memCacheWidth: 200,
      memCacheHeight: 200,
      errorWidget: (context, url, error) =>
          const Icon(Icons.error_outline, size: 50),
    );
  }
}
