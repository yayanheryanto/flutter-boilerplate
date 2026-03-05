import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final IconData? icon;
  final Color? selectedColor;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.icon,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap?.call(),
        avatar: icon != null ? Icon(icon, size: 16) : null,
        selectedColor: selectedColor ??
            Theme.of(context).colorScheme.primaryContainer,
      );
    }

    return Chip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      onDeleted: onDeleted,
    );
  }
}
