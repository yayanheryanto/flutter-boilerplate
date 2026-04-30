import 'package:flutter/material.dart';

/// A standardised icon-badge + label branding widget.
///
/// Used on auth pages, onboarding, splash screens, or anywhere a
/// compact app-brand mark is needed.
///
/// Example:
/// ```dart
/// AppLogo(icon: Icons.bolt_rounded, label: 'Boilerplate')
/// AppLogo(icon: Icons.person_add_rounded, label: 'Daftar Akun')
/// ```
class AppLogo extends StatelessWidget {
  final IconData icon;
  final String label;

  /// Size of the icon badge container. Defaults to 72.
  final double size;

  /// Border radius of the badge. Defaults to 16.
  final double radius;

  const AppLogo({
    super.key,
    required this.icon,
    required this.label,
    this.size = 72,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(icon, size: size * 0.56, color: scheme.onPrimary),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
