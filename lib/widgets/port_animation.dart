import 'package:flutter/material.dart';

class UndeesAnimation extends StatefulWidget {
  const UndeesAnimation({
    Key? key,
    required this.undeeSizeStart,
    required this.undeeSizeEnd,
    required this.undeeLeft,
    required this.controller,
    required this.showUndee,
  }) : super(key: key);

  final double undeeSizeStart;
  final double undeeSizeEnd;
  final double undeeLeft;
  final AnimationController controller;
  final bool showUndee;

  @override
  State<UndeesAnimation> createState() => _UndeesAnimationState();
}

class _UndeesAnimationState extends State<UndeesAnimation> {
  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
            Rect.fromLTWH(
                250, 150, widget.undeeSizeStart, widget.undeeSizeStart),
            const Size(300, 175)),
        end: RelativeRect.fromSize(
            Rect.fromLTWH(
                widget.undeeLeft, 60, widget.undeeSizeEnd, widget.undeeSizeEnd),
            const Size(300, 175)),
      ).animate(CurvedAnimation(
        parent: widget.controller,
        curve: Curves.bounceOut,
      )),
      child: Visibility(
        visible: widget.showUndee,
        child: Image.asset(
          'assets/images/undees.png',
        ),
      ),
    );
  }
}
