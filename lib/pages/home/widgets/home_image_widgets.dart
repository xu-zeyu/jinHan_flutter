import 'package:flutter/material.dart';

class HomeRemoteImage extends StatelessWidget {
  const HomeRemoteImage({
    super.key,
    required this.imageUrl,
    required this.fit,
    required this.placeholderColor,
  });

  final String imageUrl;
  final BoxFit fit;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return HomeImagePlaceholder(color: placeholderColor);
    }

    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return HomeImagePlaceholder(color: placeholderColor);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return HomeImagePlaceholder(color: placeholderColor);
      },
    );
  }
}

class HomeImagePlaceholder extends StatelessWidget {
  const HomeImagePlaceholder({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: const Center(
        child: Icon(
          Icons.pets_outlined,
          size: 22,
          color: Color(0xFFB7A899),
        ),
      ),
    );
  }
}
