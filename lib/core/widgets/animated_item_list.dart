import 'package:flutter/material.dart';

class AnimatedItemList extends StatefulWidget {
  final Widget child;

  const AnimatedItemList({required Key key, required this.child})
    : super(key: key);

  @override
  State<AnimatedItemList> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedItemList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5. Aplica as animações ao widget 'child'
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
