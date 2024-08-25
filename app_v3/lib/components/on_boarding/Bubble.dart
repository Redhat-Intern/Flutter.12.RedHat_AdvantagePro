import 'dart:math';

import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  final double top;
  final double left;
  final Color color;

  const Bubble({
    super.key,
    required this.top,
    required this.left,
    required this.color,
  }) ;

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(minutes: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        Random().nextDouble() * 2 - 1, // Random value between -1 and 1
        Random().nextDouble() * 2 - 1, // Random value between -1 and 1
      ),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = 8;
    double height = 8;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double offsetX = _animation.value.dx * width * 0.2;
        double offsetY = _animation.value.dy * height * 0.2;

        return Positioned(
          top: widget.top + offsetY,
          left: widget.left + offsetX,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color,
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
