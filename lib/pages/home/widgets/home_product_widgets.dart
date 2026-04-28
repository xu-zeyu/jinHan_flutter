import 'package:flutter/material.dart';

import '../../../shared/models/home_models.dart';
import 'home_image_widgets.dart';

class HomeProductCard extends StatelessWidget {
  const HomeProductCard({super.key, required this.product});

  final HomeProductItem product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: HomeRemoteImage(
                    imageUrl: product.mainImage,
                    fit: BoxFit.cover,
                    placeholderColor: const Color(0xFFF7F2ED),
                  ),
                ),
                if (product.isExcellence)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '优选',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${formatPrice(product.price)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                      if (product.originPrice > product.price) ...[
                        const SizedBox(width: 8),
                        Text(
                          '¥${formatPrice(product.originPrice)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.isShipFree)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF4ECDC4),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            '包邮',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF4ECDC4),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          product.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatPrice(double value) {
  if (value == value.truncateToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
