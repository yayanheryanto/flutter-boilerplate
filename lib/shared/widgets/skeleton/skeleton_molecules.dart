import 'package:emas/shared/widgets/skeleton/skeleton_atoms.dart';
import 'package:flutter/material.dart';


class SkeletonListTile extends StatelessWidget {
  final bool hasAvatar;
  final bool hasSubtitle;

  const SkeletonListTile({
    super.key,
    this.hasAvatar = true,
    this.hasSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (hasAvatar) ...[
            const SkeletonAvatar(size: 48),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonText(),
                if (hasSubtitle) ...[
                  const SizedBox(height: 8),
                  SkeletonText(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 12,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonFormField extends StatelessWidget {
  const SkeletonFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonText(width: 80, height: 12),
        SizedBox(height: 8),
        SkeletonBox(width: double.infinity, height: 50, borderRadius: 12),
      ],
    );
  }
}

class SkeletonInfoCard extends StatelessWidget {
  const SkeletonInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonCircle(size: 32),
              SizedBox(width: 12),
              Expanded(child: SkeletonText()),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonText(height: 12),
          const SizedBox(height: 8),
          SkeletonText(width: MediaQuery.of(context).size.width * 0.6, height: 12),
        ],
      ),
    );
  }
}
