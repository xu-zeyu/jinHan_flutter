import 'package:flutter/material.dart';

class FramesAnimation extends StatefulWidget {
  const FramesAnimation({
    Key? key,
    this.initIndex = 0,
    required this.images,
  }) : super(key: key);

  final int initIndex;
  final List images;

  @override
  State<FramesAnimation> createState() => FramesAnimationState();
}

class FramesAnimationState extends State<FramesAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animatedContainer;
  late Animation _animation;

  @override
  void initState() {
    _animatedContainer =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _animation = Tween(begin: 0.0, end: (widget.images.length - 1).toDouble())
        .animate(_animatedContainer);

    _animation.addListener(() {
      setState(() {});
    });

    if (widget.initIndex == 0) {
      startAnimation();
    }

    super.initState();
  }

  @override
  void dispose() {
    _animatedContainer.dispose();
    super.dispose();
  }

  void startAnimation() => _animatedContainer.forward();
  void resetAnimation() => _animatedContainer.reset();

  @override
  Widget build(BuildContext context) {
    int animationIndex = _animation.value.floor();
    return widget.images[animationIndex];
  }
}
