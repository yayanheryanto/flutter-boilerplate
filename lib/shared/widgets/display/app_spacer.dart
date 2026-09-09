import 'package:flutter/material.dart';

class AppSpacer extends StatelessWidget {
  final double size;
  final bool horizontal;

  const AppSpacer(this.size, {super.key, this.horizontal = false});

  const AppSpacer.xxs({super.key, this.horizontal = false}) : size = 2;
  const AppSpacer.xs({super.key, this.horizontal = false}) : size = 4;
  const AppSpacer.sm({super.key, this.horizontal = false}) : size = 8;
  const AppSpacer.md({super.key, this.horizontal = false}) : size = 16;
  const AppSpacer.lg({super.key, this.horizontal = false}) : size = 24;
  const AppSpacer.xl({super.key, this.horizontal = false}) : size = 32;
  const AppSpacer.xxl({super.key, this.horizontal = false}) : size = 48;
  const AppSpacer.xxxl({super.key, this.horizontal = false}) : size = 64;

  @override
  Widget build(BuildContext context) {
    return horizontal ? SizedBox(width: size) : SizedBox(height: size);
  }
}
