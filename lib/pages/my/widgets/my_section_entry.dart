import 'dart:ui';

import 'package:flutter/material.dart';

class MySectionEntry extends StatelessWidget {
  const MySectionEntry({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
  });

  final AnimationController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double start = (index * 0.08).clamp(0, 0.3).toDouble();
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (BuildContext context, Widget? animatedChild) {
        final double value = animation.value;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, lerpDouble(18, 0, value)!),
            child: animatedChild,
          ),
        );
      },
    );
  }
}
