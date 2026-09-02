import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:emas/core/constants/rounded.dart';

class _SkeletonBase extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const _SkeletonBase({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonBase(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius ?? Rounded.sm),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return _SkeletonBase(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({
    super.key,
    this.width = double.infinity,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonBase(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(Rounded.xs),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double size;

  const SkeletonAvatar({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) => SkeletonCircle(size: size);
}

class SkeletonButton extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonButton({
    super.key,
    this.width = 120,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: Rounded.md,
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonCard({
    super.key,
    this.width,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width ?? double.infinity,
      height: height,
      borderRadius: Rounded.lg,
    );
  }
}
