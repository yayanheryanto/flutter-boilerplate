import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:flutter/material.dart';

/// A labeled dropdown field using [DropdownMenu] (Flutter 3.3+).
///
/// Advantages over [DropdownButtonFormField]:
/// - Native `menuStyle` with full margin/padding/shape control
/// - Built-in search/filter support via [enableSearch]
/// - Consistent Material 3 appearance
///
/// Generic over [T] — works with String, enums, or any value type.
///
/// ```dart
/// // Simple String list
/// AppDropdownField<String>(
///   label: 'Jenis Kelamin',
///   hint: 'Pilih jenis kelamin',
///   value: _jenisKelamin,
///   items: const ['Laki-laki', 'Perempuan'],
///   onChanged: (v) => setState(() => _jenisKelamin = v),
///   validator: (v) => v == null ? 'Wajib dipilih' : null,
/// )
///
/// // Custom display label + popup margin
/// AppDropdownField<MyEnum>(
///   label: 'Status',
///   hint: 'Pilih status',
///   value: _status,
///   items: MyEnum.values,
///   itemLabel: (e) => e.displayName,
///   onChanged: (v) => setState(() => _status = v),
///   menuMargin: EdgeInsets.symmetric(horizontal: 16),
/// )
/// ```
class AppDropdownField<T> extends StatefulWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;

  /// Optional: custom display string for each item.
  /// Defaults to [item.toString()].
  final String Function(T item)? itemLabel;

  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  /// Margin around the popup menu.
  /// Defaults to [EdgeInsets.symmetric(vertical: 4)].
  final EdgeInsetsGeometry menuMargin;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
    this.validator,
    this.enabled = true,
    this.menuMargin = const EdgeInsets.symmetric(vertical: 4),
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = _displayLabel(widget.value as T);
    }
  }

  @override
  void didUpdateWidget(AppDropdownField<T> old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _controller.text =
      widget.value != null ? _displayLabel(widget.value as T) : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _displayLabel(T item) =>
      widget.itemLabel != null ? widget.itemLabel!(item) : item.toString();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inputTheme = Theme.of(context).inputDecorationTheme;

    return FormField<T>(
      initialValue: widget.value,
      validator: (_) => widget.validator?.call(widget.value),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Label ────────────────────────────────────────────────────────
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),

            // ── DropdownMenu ─────────────────────────────────────────────────
            DropdownMenu<T>(
              controller: _controller,
              enabled: widget.enabled,
              expandedInsets: EdgeInsets.zero, // fill parent width
              hintText: widget.hint,
              enableSearch: false,
              requestFocusOnTap: false,

              // Popup menu style — margin is fully controllable here
              menuStyle: MenuStyle(
                padding: WidgetStatePropertyAll(widget.menuMargin),
                backgroundColor: WidgetStatePropertyAll(scheme.surface),
                surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                elevation: const WidgetStatePropertyAll(4),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                    side: BorderSide(
                      color: scheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
              ),

              // Match app input decoration theme
              inputDecorationTheme: InputDecorationTheme(
                // filled: inputTheme.filled,
                // fillColor: inputTheme.fillColor,
                contentPadding: inputTheme.contentPadding,
                border: inputTheme.border,
                enabledBorder: state.hasError
                    ? OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(RadiusTokens.md),
                  borderSide: BorderSide(color: scheme.error),
                )
                    : inputTheme.enabledBorder,
                focusedBorder: inputTheme.focusedBorder,
                errorBorder: inputTheme.errorBorder,
                focusedErrorBorder: inputTheme.focusedErrorBorder,
                hintStyle: inputTheme.hintStyle,
              ),

              trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
              selectedTrailingIcon:
              const Icon(Icons.keyboard_arrow_up_rounded),

              onSelected: (T? selected) {
                widget.onChanged(selected);
                state.didChange(selected);
              },

              dropdownMenuEntries: widget.items
                  .map(
                    (e) => DropdownMenuEntry<T>(
                  value: e,
                  label: _displayLabel(e),
                ),
              )
                  .toList(),
            ),

            // ── Error text ───────────────────────────────────────────────────
            if (state.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.error,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
