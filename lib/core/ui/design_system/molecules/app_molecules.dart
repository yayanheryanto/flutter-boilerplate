import 'package:boilerplate/core/ui/design_system/atoms/buttons/app_button.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/feedback/app_feedback.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';


// EmptyStateWidget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            AppText(
              title,
              variant: AppTextVariant.titleMedium,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              AppText(
                subtitle!,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                isExpanded: false,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ErrorStateWidget
class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            AppText(
              message ?? 'Something went wrong',
              variant: AppTextVariant.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: 'Try Again',
                onPressed: onRetry,
                isExpanded: false,
                width: 160,
                prefixIcon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// LoadingSection
class LoadingSection extends StatelessWidget {
  final String? message;

  const LoadingSection({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppLoader(message: message),
    );
  }
}

// ConfirmationDialog
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDangerous: isDangerous,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: message != null ? Text(message!) : null,
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
          },
          style: isDangerous
              ? ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

// InfoCard molecule
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).colorScheme.primary)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, variant: AppTextVariant.titleSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  AppText(
                    subtitle!,
                    variant: AppTextVariant.bodySmall,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// PaginationFooter
class PaginationFooter extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;

  const PaginationFooter({
    super.key,
    required this.isLoading,
    required this.hasMore,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: AppLoader()),
      );
    }

    if (!hasMore) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: AppText(
          'No more items',
          variant: AppTextVariant.bodySmall,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppButton(
        label: 'Load More',
        onPressed: onLoadMore,
        variant: AppButtonVariant.outlined,
      ),
    );
  }
}

// OTPInputGroup
class OTPInputGroup extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final bool obscureText;

  const OTPInputGroup({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.obscureText = false,
  });

  @override
  State<OTPInputGroup> createState() => _OTPInputGroupState();
}

class _OTPInputGroupState extends State<OTPInputGroup> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: 48,
            height: 56,
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              obscureText: widget.obscureText,
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              onChanged: (value) => _onChanged(index, value),
              decoration: const InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        );
      }),
    );
  }
}
