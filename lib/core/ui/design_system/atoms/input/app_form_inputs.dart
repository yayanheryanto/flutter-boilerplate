import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;

  const AppDropdown({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String? label;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(!value),
              child: Text(label!, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      );
    }
    return Checkbox(value: value, onChanged: onChanged);
  }
}

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String? label;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return RadioListTile<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(label!),
        contentPadding: EdgeInsets.zero,
      );
    }
    return Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged);
  }
}

class AppSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  final String? label;
  final String? subtitle;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label!),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        contentPadding: EdgeInsets.zero,
      );
    }
    return Switch(value: value, onChanged: onChanged);
  }
}
