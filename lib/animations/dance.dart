import 'package:flutter/material.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class Dance extends StatefulWidget {
  const Dance(
      {Key? key,
      required this.child,
      required this.animate,
      required this.delay})
      : super(key: key);
  final Widget child;
  final bool animate;
  final int delay;
  @override
  State<Dance> createState() => _DanceState();
}

class _DanceState extends State<Dance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.50)),
          weight: 15),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, -0.5), end: const Offset(0, 0)),
          weight: 10),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.25)),
          weight: 12),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, -0.25), end: const Offset(0, 0)),
          weight: 8)
    ]).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Dance oldWidget) {
    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return settingsProvider.withWordAnimation
        ? SlideTransition(
            position: _animation,
            child: widget.child,
          )
        : widget.child;
  }
}
