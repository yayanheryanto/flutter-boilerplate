import 'package:emas/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withOpacity(0.2),
        child: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColors.primary500,
            size: 40,
          ),
        ),
      ),
    );
  }
}
