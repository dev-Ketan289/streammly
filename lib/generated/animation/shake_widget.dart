import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;

  const ShakeWidget({Key? key, required this.child, required this.shake}) : super(key: key);

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    final double shakeOffset = 10;

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -shakeOffset), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -shakeOffset, end: shakeOffset), weight: 2),
      TweenSequenceItem(tween: Tween(begin: shakeOffset, end: -shakeOffset), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -shakeOffset, end: shakeOffset), weight: 2),
      TweenSequenceItem(tween: Tween(begin: shakeOffset, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _animation, builder: (context, child) => Transform.translate(offset: Offset(_animation.value, 0), child: widget.child));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
