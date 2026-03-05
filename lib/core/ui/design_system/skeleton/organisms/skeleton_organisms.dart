import 'package:boilerplate/core/ui/design_system/skeleton/atoms/skeleton_atoms.dart';
import 'package:boilerplate/core/ui/design_system/skeleton/molecules/skeleton_molecules.dart';
import 'package:flutter/material.dart';


class AuthFormSkeleton extends StatelessWidget {
  const AuthFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 120, height: 40, borderRadius: 8),
          const SizedBox(height: 8),
          const SkeletonText(width: 200),
          const SizedBox(height: 40),
          const SkeletonFormField(),
          const SizedBox(height: 16),
          const SkeletonFormField(),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: SkeletonText(width: 100, height: 14),
          ),
          const SizedBox(height: 32),
          const SkeletonButton(width: double.infinity),
          const SizedBox(height: 16),
          Center(
            child: SkeletonText(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListSkeleton extends StatelessWidget {
  final int itemCount;

  const ProductListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const SkeletonInfoCard(),
    );
  }
}

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              SkeletonAvatar(size: 48),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 120, height: 18),
                    SizedBox(height: 6),
                    SkeletonText(width: 80, height: 14),
                  ],
                ),
              ),
              SkeletonCircle(size: 40),
            ],
          ),
          const SizedBox(height: 24),
          // Stats row
          Row(
            children: List.generate(
              3,
              (_) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: SkeletonCard(height: 80),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SkeletonText(width: 120, height: 18),
          const SizedBox(height: 12),
          const ProductListSkeleton(itemCount: 3),
        ],
      ),
    );
  }
}

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const SkeletonAvatar(size: 80),
        const SizedBox(height: 16),
        const SkeletonText(width: 150, height: 20),
        const SizedBox(height: 8),
        const SkeletonText(width: 200, height: 14),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SkeletonText(width: 40, height: 20),
                  SizedBox(height: 4),
                  SkeletonText(width: 60, height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
