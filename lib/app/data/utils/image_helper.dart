import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildRecipeImage(String imageUrl, {double? width, double? height, BoxFit fit = BoxFit.cover, Widget? placeholder}) {
  final fallbackPlaceholder = placeholder ?? Container(
    width: width,
    height: height,
    color: Colors.grey[900],
    child: const Icon(Icons.restaurant, color: Colors.white24, size: 30),
  );

  if (imageUrl.isEmpty) {
    return fallbackPlaceholder;
  }

  if (imageUrl.startsWith('assets/')) {
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => fallbackPlaceholder,
    );
  } else if (imageUrl.startsWith('data:image/')) {
    try {
      final base64Content = imageUrl.split(',').last;
      return Image.memory(
        base64Decode(base64Content.trim()),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallbackPlaceholder,
      );
    } catch (_) {
      return fallbackPlaceholder;
    }
  } else {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[900],
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => fallbackPlaceholder,
    );
  }
}

ImageProvider buildRecipeImageProvider(String imageUrl) {
  if (imageUrl.isEmpty) {
    return const AssetImage('assets/recipes/Fish_amok.jpg');
  }

  if (imageUrl.startsWith('assets/')) {
    return AssetImage(imageUrl);
  } else if (imageUrl.startsWith('data:image/')) {
    try {
      final base64Content = imageUrl.split(',').last;
      return MemoryImage(base64Decode(base64Content.trim()));
    } catch (_) {
      return const AssetImage('assets/recipes/Fish_amok.jpg');
    }
  } else {
    return NetworkImage(imageUrl);
  }
}
