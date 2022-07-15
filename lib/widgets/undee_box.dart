import 'package:flutter/material.dart';

class UndeesImageBox extends StatefulWidget {
  const UndeesImageBox({Key? key, required this.undees}) : super(key: key);
  final String undees;

  @override
  State<UndeesImageBox> createState() => _UndeesImageBoxState();
}

class _UndeesImageBoxState extends State<UndeesImageBox> {
  bool isCurrentUndee = false;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Image.asset(widget.undees),
    );
  }
}
