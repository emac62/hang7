import 'package:flutter/material.dart';

class UndeesImageBox extends StatefulWidget {
  const UndeesImageBox({Key? key, required this.undees}) : super(key: key);
  final Image undees;

  @override
  State<UndeesImageBox> createState() => _UndeesImageBoxState();
}

class _UndeesImageBoxState extends State<UndeesImageBox> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: widget.undees,
    );
  }
}
