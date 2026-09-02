import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

// ─── Base Dialog Shell ────────────────────────────────────────────────────────

/// Low-level dialog container. Use [AppDialog.show] or the typed subclasses.
class AppDialog extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;

  /// If true, a close ✕ button appears in the top-right corner.
  final bool showCloseButton;

  /// Max width for the dialog card (default 480, centers on tablets).
  final double maxWidth;

  const AppDialog({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.showCloseButton = true,
    this.maxWidth = 480,
  });

  // ── Static helpers ──────────────────────────────────────────────────────────

  /// Generic show – lets callers pass an arbitrary [child] widget.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    bool useSafeArea = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      barrierColor: Colors.black54,
      builder: (_) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) header!,
            if (body != null)
              Flexible(
                child: SingleChildScrollView(child: body!),
              ),
            if (footer != null) footer!,
            if (showCloseButton && header == null && body == null)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Confirmation Dialog ──────────────────────────────────────────────────────

enum AppDialogType { info, success, warning, danger }

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? customContent;
  final String confirmLabel;
  final String cancelLabel;
  final AppDialogType type;
  final bool barrierDismissible;
  final bool showCancel;

  const AppConfirmDialog._({
    required this.title,
    this.message,
    this.customContent,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.type,
    required this.barrierDismissible,
    required this.showCancel,
  });

  /// Shows a confirmation dialog and returns `true` (confirm) or `false`/`null` (cancel/dismiss).
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? customContent,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    AppDialogType type = AppDialogType.info,
    bool barrierDismissible = true,
    bool showCancel = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (_) => AppConfirmDialog._(
        title: title,
        message: message,
        customContent: customContent,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        type: type,
        barrierDismissible: barrierDismissible,
        showCancel: showCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (iconData, iconColor, _) = _typeStyle(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(Spacings.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 28),
              ),
              const SizedBox(height: Spacings.md),

              // Title
              AppText(
                title,
                variant: AppTextVariant.titleLarge,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),

              // Message / custom content
              if (message != null) ...[
                const SizedBox(height: Spacings.sm),
                AppText(
                  message!,
                  color: scheme.onSurface.withOpacity(0.65),
                  textAlign: TextAlign.center,
                ),
              ],
              if (customContent != null) ...[
                const SizedBox(height: Spacings.md),
                customContent!,
              ],

              const SizedBox(height: Spacings.xl),

              // Actions
              Row(
                children: [
                  if (showCancel) ...[
                    Expanded(
                      child: AppButton(
                        label: cancelLabel,
                        onPressed: () => Navigator.of(context).pop(false),
                        variant: AppButtonVariant.outlined,
                      ),
                    ),
                    const SizedBox(width: Spacings.sm),
                  ],
                  Expanded(
                    child: AppButton(
                      label: confirmLabel,
                      onPressed: () => Navigator.of(context).pop(true),
                      // Override color for danger via style extension
                      dangerOverride: type == AppDialogType.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  (IconData, Color, Color) _typeStyle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case AppDialogType.success:
        return (Icons.check_circle_outline_rounded, Colors.green.shade600, Colors.green.shade600);
      case AppDialogType.warning:
        return (Icons.warning_amber_rounded, Colors.orange.shade600, Colors.orange.shade600);
      case AppDialogType.danger:
        return (Icons.delete_outline_rounded, scheme.error, scheme.error);
      case AppDialogType.info:
        return (Icons.info_outline_rounded, scheme.primary, scheme.primary);
    }
  }
}

// ─── Info / Alert Dialog ──────────────────────────────────────────────────────

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final AppDialogType type;

  const AppAlertDialog._({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.type,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'OK',
    AppDialogType type = AppDialogType.info,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => AppAlertDialog._(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog._(
      title: title,
      message: message,
      confirmLabel: buttonLabel,
      cancelLabel: '',
      type: type,
      barrierDismissible: true,
      showCancel: false,
    );
  }
}

// ─── Input Dialog ─────────────────────────────────────────────────────────────

class AppInputDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? initialValue;
  final String fieldLabel;
  final String? fieldHint;
  final String confirmLabel;
  final String cancelLabel;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int maxLines;

  const AppInputDialog._({
    required this.title,
    this.subtitle,
    this.initialValue,
    required this.fieldLabel,
    this.fieldHint,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.keyboardType,
    this.validator,
    this.maxLength,
    required this.maxLines,
  });

  /// Returns the entered string or null if cancelled.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? initialValue,
    String fieldLabel = 'Value',
    String? fieldHint,
    String confirmLabel = 'Submit',
    String cancelLabel = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
    int maxLines = 1,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => AppInputDialog._(
        title: title,
        subtitle: subtitle,
        initialValue: initialValue,
        fieldLabel: fieldLabel,
        fieldHint: fieldHint,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
      ),
    );
  }

  @override
  State<AppInputDialog> createState() => _AppInputDialogState();
}

class _AppInputDialogState extends State<AppInputDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(Spacings.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(widget.title, variant: AppTextVariant.titleLarge, fontWeight: FontWeight.w600),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  AppText(
                    widget.subtitle!,
                    variant: AppTextVariant.bodySmall,
                    color: scheme.onSurface.withOpacity(0.6),
                  ),
                ],
                const SizedBox(height: Spacings.md),
                TextFormField(
                  controller: _controller,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  autofocus: true,
                  validator: widget.validator ?? (v) => (v == null || v.trim().isEmpty) ? '${widget.fieldLabel} is required' : null,
                  decoration: InputDecoration(
                    labelText: widget.fieldLabel,
                    hintText: widget.fieldHint,
                  ),
                ),
                const SizedBox(height: Spacings.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: widget.cancelLabel,
                        onPressed: () => Navigator.of(context).pop(),
                        variant: AppButtonVariant.outlined,
                      ),
                    ),
                    const SizedBox(width: Spacings.sm),
                    Expanded(
                      child: AppButton(
                        label: widget.confirmLabel,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.of(context).pop(_controller.text.trim());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Loading Dialog ───────────────────────────────────────────────────────────

class AppLoadingDialog extends StatelessWidget {
  final String? message;

  const AppLoadingDialog._({this.message});

  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) => AppLoadingDialog._(message: message),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacings.xl,
            vertical: Spacings.lg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: Spacings.md),
              Flexible(
                child: AppText(
                  message ?? 'Please wait...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Custom Content Dialog ────────────────────────────────────────────────────

class AppCustomDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<AppDialogAction>? actions;
  final bool showCloseButton;
  final EdgeInsetsGeometry? contentPadding;

  const AppCustomDialog._({
    this.title,
    required this.content,
    this.actions,
    required this.showCloseButton,
    this.contentPadding,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    List<AppDialogAction>? actions,
    bool showCloseButton = true,
    bool barrierDismissible = true,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (_) => AppCustomDialog._(
        title: title,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
        contentPadding: contentPadding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            if (title != null || showCloseButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacings.lg,
                  Spacings.md,
                  Spacings.sm,
                  0,
                ),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: AppText(
                          title!,
                          variant: AppTextVariant.titleLarge,
                          fontWeight: FontWeight.w600,
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
                      Spacings.lg,
                      title != null ? Spacings.sm : Spacings.lg,
                      Spacings.lg,
                      actions != null ? Spacings.sm : Spacings.lg,
                    ),
                child: content,
              ),
            ),

            // Footer actions
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacings.lg,
                  0,
                  Spacings.lg,
                  Spacings.lg,
                ),
                child: Row(
                  children: actions!
                      .asMap()
                      .entries
                      .expand(
                        (e) => [
                          Expanded(child: _buildAction(context, e.value)),
                          if (e.key < actions!.length - 1) const SizedBox(width: Spacings.sm),
                        ],
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, AppDialogAction action) {
    return AppButton(
      label: action.label,
      onPressed: () {
        Navigator.of(context).pop(action.returnValue);
        action.onPressed?.call();
      },
      variant: action.variant,
    );
  }
}

// ─── Shared data class ────────────────────────────────────────────────────────

class AppDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final dynamic returnValue;

  const AppDialogAction({
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.returnValue,
  });
}
