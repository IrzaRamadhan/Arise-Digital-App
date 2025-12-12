import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../shared/theme.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadiusGeometry? borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder:
          (context, imageProvider) => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              borderRadius: borderRadius,
            ),
          ),
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: neutral200,
            highlightColor: neutral300,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: borderRadius,
              ),
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: borderRadius,
            ),
            child: const Center(child: Icon(Icons.error)),
          ),
    );
  }
}
