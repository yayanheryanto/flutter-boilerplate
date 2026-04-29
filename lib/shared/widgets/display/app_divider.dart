import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double? height;
  final Color? color;
  final double indent;
  final double endIndent;

  const AppDivider({
    super.key,
    this.height,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: color ?? Theme.of(context).colorScheme.outline,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
