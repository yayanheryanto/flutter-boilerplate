import 'dart:io';

import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ─── AppColorPicker ───────────────────────────────────────────────────────────

/// Inline color swatch picker as a form field.
///
/// ```dart
/// AppColorPicker(
///   label: 'Tag color',
///   initialColor: Colors.blue,
///   onChanged: (color) => setState(() => _color = color),
/// )
/// ```
class AppColorPicker extends StatefulWidget {
  final String label;
  final Color? initialColor;
  final List<Color> colors;
  final void Function(Color)? onChanged;
  final String? Function(Color?)? validator;
  final bool showCustomOption;

  const AppColorPicker({
    super.key,
    required this.label,
    this.initialColor,
    this.colors = _defaultColors,
    this.onChanged,
    this.validator,
    this.showCustomOption = true,
  });

  static const List<Color> _defaultColors = [
    Color(0xFFEF4444), // red
    Color(0xFFF97316), // orange
    Color(0xFFFACC15), // yellow
    Color(0xFF22C55E), // green
    Color(0xFF06B6D4), // cyan
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // violet
    Color(0xFFEC4899), // pink
    Color(0xFF6B7280), // gray
    Color(0xFF000000), // black
    Color(0xFFFFFFFF), // white
  ];

  @override
  State<AppColorPicker> createState() => _AppColorPickerState();
}

class _AppColorPickerState extends State<AppColorPicker> {
  Color? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FormField<Color>(
      initialValue: _selected,
      validator: (_) => widget.validator?.call(_selected),
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            widget.label,
            variant: AppTextVariant.labelLarge,
            color: scheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(height: AppSpacings.sm),
          Wrap(
            spacing: AppSpacings.sm,
            runSpacing: AppSpacings.sm,
            children: [
              ...widget.colors.map(
                (c) => _ColorSwatch(
                  color: c,
                  isSelected: _selected == c,
                  onTap: () {
                    setState(() => _selected = c);
                    widget.onChanged?.call(c);
                    state.didChange(c);
                  },
                ),
              ),
              if (widget.showCustomOption)
                _CustomColorButton(
                  current: _selected,
                  onPick: (c) {
                    setState(() => _selected = c);
                    widget.onChanged?.call(c);
                    state.didChange(c);
                  },
                ),
            ],
          ),
          if (state.hasError) ...[
            const SizedBox(height: 4),
            AppText(
              state.errorText!,
              variant: AppTextVariant.labelSmall,
              color: scheme.error,
            ),
          ],
          if (_selected != null) ...[
            const SizedBox(height: AppSpacings.sm),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _selected,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: scheme.outline.withOpacity(0.4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AppText(
                  '#${_selected!.value.toRadixString(16).substring(2).toUpperCase()}',
                  variant: AppTextVariant.labelMedium,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : color == Colors.white
                    ? Theme.of(context).colorScheme.outline.withOpacity(0.4)
                    : Colors.transparent,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, spreadRadius: 1)] : null,
        ),
        child: isSelected
            ? Icon(
                Icons.check_rounded,
                size: 18,
                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              )
            : null,
      ),
    );
  }
}

class _CustomColorButton extends StatelessWidget {
  final Color? current;
  final void Function(Color) onPick;

  const _CustomColorButton({this.current, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => _showCustomPicker(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: const Icon(Icons.colorize_rounded, size: 18),
      ),
    );
  }

  Future<void> _showCustomPicker(BuildContext context) async {
    // For a production app, integrate a package like `flutter_colorpicker`.
    // Here we show a simple hex input fallback.
    await showDialog<Color>(
      context: context,
      builder: (_) => _HexColorDialog(initial: current),
    ).then((c) {
      if (c != null) onPick(c);
    });
  }
}

class _HexColorDialog extends StatefulWidget {
  final Color? initial;

  const _HexColorDialog({this.initial});

  @override
  State<_HexColorDialog> createState() => _HexColorDialogState();
}

class _HexColorDialogState extends State<_HexColorDialog> {
  final _ctrl = TextEditingController();
  Color? _preview;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _ctrl.text = widget.initial!.value.toRadixString(16).substring(2).toUpperCase();
      _preview = widget.initial;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onHexChanged(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (clean.length == 6) {
      try {
        final color = Color(int.parse('FF$clean', radix: 16));
        setState(() {
          _preview = color;
          _error = null;
        });
      } catch (_) {
        setState(() => _error = 'Invalid hex');
      }
    } else {
      setState(() {
        _preview = null;
        _error = clean.isEmpty ? null : 'Enter 6 hex characters';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusTokens.xl)),
      title: const Text('Custom Color'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_preview != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 56,
              decoration: BoxDecoration(
                color: _preview,
                borderRadius: BorderRadius.circular(RadiusTokens.md),
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            onChanged: _onHexChanged,
            maxLength: 7,
            decoration: InputDecoration(
              labelText: 'Hex Color',
              hintText: 'e.g. FF5733',
              prefixText: '#',
              errorText: _error,
              counterText: '',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _preview != null ? () => Navigator.pop(context, _preview) : null,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

// ─── AppImagePickerField ──────────────────────────────────────────────────────

/// Form field that lets user pick an image from camera or gallery.
///
/// ```dart
/// AppImagePickerField(
///   label: 'Profile Photo',
///   onChanged: (file) => _photo = file,
///   shape: AppImagePickerShape.circle,
/// )
/// ```
enum AppImagePickerShape { square, rounded, circle }

class AppImagePickerField extends StatefulWidget {
  final String label;
  final File? initialFile;
  final String? initialNetworkUrl;
  final AppImagePickerShape shape;
  final double size;
  final void Function(File?)? onChanged;
  final String? Function(File?)? validator;
  final int imageQuality;

  const AppImagePickerField({
    super.key,
    required this.label,
    this.initialFile,
    this.initialNetworkUrl,
    this.shape = AppImagePickerShape.rounded,
    this.size = 100,
    this.onChanged,
    this.validator,
    this.imageQuality = 80,
  });

  @override
  State<AppImagePickerField> createState() => _AppImagePickerFieldState();
}

class _AppImagePickerFieldState extends State<AppImagePickerField> {
  File? _file;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _file = widget.initialFile;
  }

  Future<void> _showPicker() async {
    await AppOptionsBottomSheet.show<String>(
      context,
      title: 'Select image from',
      options: [
        const AppSheetOption(label: 'Camera', icon: Icons.camera_alt_outlined, value: 'camera'),
        const AppSheetOption(label: 'Gallery', icon: Icons.photo_library_outlined, value: 'gallery'),
        if (_file != null)
          const AppSheetOption(
            label: 'Remove photo',
            icon: Icons.delete_outline,
            value: 'remove',
            isDestructive: true,
          ),
      ],
    ).then((source) async {
      if (source == 'remove') {
        setState(() => _file = null);
        widget.onChanged?.call(null);
        return;
      }
      if (source == null) return;

      final picked = await _picker.pickImage(
        source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: widget.imageQuality,
      );
      if (picked != null) {
        final file = File(picked.path);
        setState(() => _file = file);
        widget.onChanged?.call(file);
      }
    });
  }

  BorderRadius get _borderRadius {
    switch (widget.shape) {
      case AppImagePickerShape.circle:
        return BorderRadius.circular(widget.size / 2);
      case AppImagePickerShape.rounded:
        return BorderRadius.circular(RadiusTokens.lg);
      case AppImagePickerShape.square:
        return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasImage = _file != null || widget.initialNetworkUrl != null;

    return FormField<File>(
      initialValue: _file,
      validator: (_) => widget.validator?.call(_file),
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            widget.label,
            variant: AppTextVariant.labelLarge,
            color: scheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(height: AppSpacings.sm),
          GestureDetector(
            onTap: _showPicker,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: _borderRadius,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _file != null
                        ? Image.file(
                            _file!,
                            key: ValueKey(_file!.path),
                            width: widget.size,
                            height: widget.size,
                            fit: BoxFit.cover,
                          )
                        : widget.initialNetworkUrl != null
                            ? Image.network(
                                widget.initialNetworkUrl!,
                                width: widget.size,
                                height: widget.size,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: widget.size,
                                height: widget.size,
                                color: scheme.surfaceContainerHighest,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 28,
                                      color: scheme.onSurface.withOpacity(0.4),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Add photo',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: scheme.onSurface.withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ),
                if (hasImage)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Icon(Icons.edit_rounded, size: 14, color: scheme.onPrimary),
                    ),
                  ),
              ],
            ),
          ),
          if (state.hasError) ...[
            const SizedBox(height: 4),
            AppText(state.errorText!, variant: AppTextVariant.labelSmall, color: scheme.error),
          ],
        ],
      ),
    );
  }
}
