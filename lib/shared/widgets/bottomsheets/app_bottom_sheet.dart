import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

// ─── Base Bottom Sheet Shell ──────────────────────────────────────────────────

/// Shared configuration that all bottom sheet variants use.
class _AppBottomSheetShell extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget content;
  final List<Widget>? actions;
  final bool showHandle;
  final bool showCloseButton;
  final bool isScrollControlled;
  final double? initialChildSize;
  final double maxChildSize;
  final double minChildSize;
  // final bool expand;
  final EdgeInsetsGeometry? contentPadding;

  const _AppBottomSheetShell({
    this.title,
    this.subtitle,
    required this.content,
    this.actions,
    required this.showHandle,
    required this.showCloseButton,
    required this.isScrollControlled,
    this.initialChildSize,
    this.maxChildSize = 0.9,
    this.minChildSize = 0.3,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          if (showHandle)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

          // Header
          if (title != null || showCloseButton)
            Padding(
              padding: EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                showHandle ? SpacingTokens.xs : SpacingTokens.md,
                SpacingTokens.sm,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            title!,
                            variant: AppTextVariant.titleLarge,
                            fontWeight: FontWeight.w600,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            AppText(
                              subtitle!,
                              variant: AppTextVariant.bodySmall,
                              color: scheme.onSurface.withOpacity(0.6),
                            ),
                          ],
                        ],
                      ),
                    ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: contentPadding ??
                  EdgeInsets.fromLTRB(
                    SpacingTokens.lg,
                    SpacingTokens.md,
                    SpacingTokens.lg,
                    actions != null ? SpacingTokens.sm : SpacingTokens.lg + bottomPad,
                  ),
              child: content,
            ),
          ),

          // Footer actions
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                0,
                SpacingTokens.lg,
                SpacingTokens.lg + bottomPad,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: actions!
                    .asMap()
                    .entries
                    .expand(
                      (e) => [
                        e.value,
                        if (e.key < actions!.length - 1)
                          const SizedBox(height: SpacingTokens.sm),
                      ],
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── 1. AppCustomBottomSheet ──────────────────────────────────────────────────

/// The most flexible bottom sheet. Pass any content widget.
///
/// ```dart
/// await AppCustomBottomSheet.show(
///   context,
///   title: 'Pick an option',
///   content: MyCustomWidget(),
///   actions: [
///     AppButton(label: 'Done', onPressed: () => Navigator.pop(context)),
///   ],
/// );
/// ```
class AppCustomBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    required Widget content,
    List<Widget>? actions,
    bool showHandle = true,
    bool showCloseButton = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    double? initialChildSize,
    double maxChildSize = 0.9,
    double minChildSize = 0.3,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusTokens.xl)),
      ),
      builder: (_) => _AppBottomSheetShell(
        title: title,
        subtitle: subtitle,
        content: content,
        actions: actions,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        isScrollControlled: isScrollControlled,
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
        contentPadding: contentPadding,
      ),
    );
  }
}

// ─── 2. AppOptionsBottomSheet ─────────────────────────────────────────────────

/// A list of tappable option tiles. Returns the selected [AppSheetOption.value].
///
/// ```dart
/// final result = await AppOptionsBottomSheet.show<String>(
///   context,
///   title: 'Choose action',
///   options: [
///     AppSheetOption(label: 'Edit', icon: Icons.edit, value: 'edit'),
///     AppSheetOption(label: 'Delete', icon: Icons.delete, value: 'delete', isDestructive: true),
///   ],
/// );
/// ```
class AppOptionsBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    required List<AppSheetOption<T>> options,
    bool showHandle = true,
    bool showCancelButton = true,
    String cancelLabel = 'Cancel',
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => _AppBottomSheetShell(
        title: title,
        subtitle: subtitle,
        showHandle: showHandle,
        showCloseButton: false,
        isScrollControlled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: SpacingTokens.xs),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) => _OptionTile<T>(option: opt)).toList(),
        ),
        actions: showCancelButton
            ? [
                AppButton(
                  label: cancelLabel,
                  onPressed: () => Navigator.of(context).pop(),
                  variant: AppButtonVariant.outlined,
                ),
              ]
            : null,
      ),
    );
  }
}

class _OptionTile<T> extends StatelessWidget {
  final AppSheetOption<T> option;

  const _OptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = option.isDestructive ? scheme.error : null;

    return ListTile(
      leading: option.icon != null
          ? Icon(option.icon, color: color ?? scheme.onSurface)
          : null,
      title: AppText(
        option.label,
        variant: AppTextVariant.bodyLarge,
        color: color,
        fontWeight: option.isDestructive ? FontWeight.w500 : null,
      ),
      subtitle: option.subtitle != null
          ? AppText(option.subtitle!, variant: AppTextVariant.bodySmall)
          : null,
      trailing: option.trailing,
      enabled: option.enabled,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.xs,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusTokens.md)),
      onTap: option.enabled
          ? () {
              Navigator.of(context).pop(option.value);
              option.onTap?.call();
            }
          : null,
    );
  }
}

class AppSheetOption<T> {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final T value;
  final bool isDestructive;
  final bool enabled;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppSheetOption({
    required this.label,
    this.subtitle,
    this.icon,
    required this.value,
    this.isDestructive = false,
    this.enabled = true,
    this.trailing,
    this.onTap,
  });
}

// ─── 3. AppConfirmBottomSheet ─────────────────────────────────────────────────

/// A confirmation-style bottom sheet (alternative to a dialog).
/// Returns `true` on confirm, `false`/`null` on cancel/dismiss.
///
/// ```dart
/// final confirmed = await AppConfirmBottomSheet.show(
///   context,
///   title: 'Delete account?',
///   message: 'This action cannot be undone.',
///   confirmLabel: 'Delete',
///   type: AppSheetConfirmType.danger,
/// );
/// ```
enum AppSheetConfirmType { info, warning, danger }

class AppConfirmBottomSheet {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? customContent,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    AppSheetConfirmType type = AppSheetConfirmType.info,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        final (iconData, iconColor) = _iconForType(ctx, type);

        return _AppBottomSheetShell(
          showHandle: true,
          showCloseButton: false,
          isScrollControlled: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 28),
              ),
              const SizedBox(height: SpacingTokens.md),
              AppText(
                title,
                variant: AppTextVariant.titleLarge,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: SpacingTokens.sm),
                AppText(
                  message,
                  color: scheme.onSurface.withOpacity(0.65),
                  textAlign: TextAlign.center,
                ),
              ],
              if (customContent != null) ...[
                const SizedBox(height: SpacingTokens.md),
                customContent,
              ],
            ],
          ),
          actions: [
            AppButton(
              label: confirmLabel,
              onPressed: () => Navigator.of(ctx).pop(true),
              dangerOverride: type == AppSheetConfirmType.danger,
            ),
            AppButton(
              label: cancelLabel,
              onPressed: () => Navigator.of(ctx).pop(false),
              variant: AppButtonVariant.outlined,
            ),
          ],
        );
      },
    );
  }

  static (IconData, Color) _iconForType(BuildContext context, AppSheetConfirmType type) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case AppSheetConfirmType.danger:
        return (Icons.delete_outline_rounded, scheme.error);
      case AppSheetConfirmType.warning:
        return (Icons.warning_amber_rounded, Colors.orange.shade600);
      case AppSheetConfirmType.info:
        return (Icons.info_outline_rounded, scheme.primary);
    }
  }
}

// ─── 4. AppFormBottomSheet ────────────────────────────────────────────────────

/// A bottom sheet that wraps a [Form] and stays above the keyboard.
/// Returns the form result [T] on submit, or null on cancel.
///
/// ```dart
/// final result = await AppFormBottomSheet.show<Map<String, String>>(
///   context,
///   title: 'Add note',
///   formBuilder: (key) => MyForm(formKey: key),
///   onSubmit: (key) async {
///     if (key.currentState!.validate()) {
///       return {'note': controller.text};
///     }
///     return null;
///   },
/// );
/// ```
class AppFormBottomSheet<T> {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Widget Function(GlobalKey<FormState> formKey) formBuilder,
    required Future<T?> Function(GlobalKey<FormState> formKey) onSubmit,
    String submitLabel = 'Submit',
    String cancelLabel = 'Cancel',
    bool isDismissible = false,
  }) {
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => _FormBottomSheetContent<T>(
        title: title,
        subtitle: subtitle,
        formKey: formKey,
        formBuilder: formBuilder,
        onSubmit: onSubmit,
        submitLabel: submitLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }
}

class _FormBottomSheetContent<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final GlobalKey<FormState> formKey;
  final Widget Function(GlobalKey<FormState> formKey) formBuilder;
  final Future<T?> Function(GlobalKey<FormState> formKey) onSubmit;
  final String submitLabel;
  final String cancelLabel;

  const _FormBottomSheetContent({
    required this.title,
    this.subtitle,
    required this.formKey,
    required this.formBuilder,
    required this.onSubmit,
    required this.submitLabel,
    required this.cancelLabel,
  });

  @override
  State<_FormBottomSheetContent<T>> createState() => _FormBottomSheetContentState<T>();
}

class _FormBottomSheetContentState<T> extends State<_FormBottomSheetContent<T>> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      final result = await widget.onSubmit(widget.formKey);
      if (result != null && mounted) Navigator.of(context).pop(result);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _AppBottomSheetShell(
        title: widget.title,
        subtitle: widget.subtitle,
        showHandle: true,
        showCloseButton: true,
        isScrollControlled: true,
        content: Form(
          key: widget.formKey,
          child: widget.formBuilder(widget.formKey),
        ),
        actions: [
          AppButton(
            label: widget.submitLabel,
            onPressed: _handleSubmit,
            isLoading: _isSubmitting,
          ),
          AppButton(
            label: widget.cancelLabel,
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            variant: AppButtonVariant.outlined,
          ),
        ],
      ),
    );
  }
}

// ─── 5. AppDraggableBottomSheet ───────────────────────────────────────────────

/// A bottom sheet that can be dragged to different sizes.
/// Good for large content like maps, photo grids, etc.
///
/// ```dart
/// AppDraggableBottomSheet.show(
///   context,
///   title: 'All results',
///   content: BigListWidget(),
///   initialSize: 0.5,
///   maxSize: 0.95,
/// );
/// ```
class AppDraggableBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    required Widget content,
    List<Widget>? actions,
    double initialSize = 0.5,
    double maxSize = 0.9,
    double minSize = 0.25,
    bool showHandle = true,
    bool showCloseButton = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: initialSize,
        maxChildSize: maxSize,
        minChildSize: minSize,
        expand: false,
        builder: (ctx, scrollController) => _AppBottomSheetShell(
          title: title,
          subtitle: subtitle,
          showHandle: showHandle,
          showCloseButton: showCloseButton,
          isScrollControlled: true,
          content: content,
          actions: actions,
        ),
      ),
    );
  }
}
