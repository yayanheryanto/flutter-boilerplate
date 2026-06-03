import 'package:emas/shared/theme/color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
      style: const TextStyle(
        color: ColorTokens.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorTokens.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorTokens.borderFocused,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorTokens.border,
          ),
        ),
        hintStyle: const TextStyle(
          color: ColorTokens.textHint,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorTokens.textLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }
}

class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;

  const AppPasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hint = 'Enter password',
    this.errorText,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.prefixIcon,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorTokens.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorTokens.borderFocused,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorTokens.border,
          ),
        ),
        hintStyle: const TextStyle(
          color: ColorTokens.textHint,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    if (widget.label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorTokens.textLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }
}

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: const TextStyle(
        color: ColorTokens.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: (controller?.text.isNotEmpty ?? false)
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
      ),
    );
  }
}
