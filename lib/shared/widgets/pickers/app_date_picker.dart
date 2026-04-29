import 'package:boilerplate/core/constants/tokens/radius_tokens.dart';
import 'package:boilerplate/core/constants/tokens/spacing_tokens.dart';
import 'package:boilerplate/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─── AppDatePicker ────────────────────────────────────────────────────────────

/// Full-featured date/time/range picker system.
///
/// ## Single date
/// ```dart
/// final date = await AppDatePicker.pickDate(context, initialDate: DateTime.now());
/// ```
///
/// ## Time
/// ```dart
/// final time = await AppDatePicker.pickTime(context);
/// ```
///
/// ## Date + Time combined
/// ```dart
/// final dt = await AppDatePicker.pickDateTime(context);
/// ```
///
/// ## Date range
/// ```dart
/// final range = await AppDatePicker.pickDateRange(context);
/// if (range != null) print('${range.start} → ${range.end}');
/// ```
///
/// ## Month/Year only
/// ```dart
/// final date = await AppDatePicker.pickMonthYear(context);
/// ```
class AppDatePicker {
  AppDatePicker._();

  // ── Single Date ─────────────────────────────────────────────────────────────

  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? confirmText,
    String? cancelText,
    SelectableDayPredicate? selectableDayPredicate,
  }) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      helpText: helpText,
      confirmText: confirmText,
      cancelText: cancelText,
      selectableDayPredicate: selectableDayPredicate,
      builder: _themeWrapper,// Force US locale for consistent date formatting in pickers
    );
  }

  // ── Time ────────────────────────────────────────────────────────────────────

  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    TimeOfDay? initialTime,
    bool use24HourFormat = false,
    String? helpText,
    String? confirmText,
    String? cancelText,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText,
      confirmText: confirmText,
      cancelText: cancelText,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(
          alwaysUse24HourFormat: use24HourFormat,
        ),
        child: _themeWrapper(ctx, child),
      ),
    );
  }

  // ── DateTime (date + time combined) ─────────────────────────────────────────

  static Future<DateTime?> pickDateTime(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    TimeOfDay? initialTime,
    bool use24HourFormat = false,
  }) async {
    final date = await pickDate(
      context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (date == null || !context.mounted) return null;

    final time = await pickTime(
      context,
      initialTime: initialTime ??
          (initialDate != null
              ? TimeOfDay.fromDateTime(initialDate)
              : TimeOfDay.now()),
      use24HourFormat: use24HourFormat,
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // ── Date Range ──────────────────────────────────────────────────────────────

  static Future<DateTimeRange?> pickDateRange(
    BuildContext context, {
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? saveText,
  }) async {
    final now = DateTime.now();
    return showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      initialDateRange: initialDateRange ??
          DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
      helpText: helpText ?? 'Select date range',
      saveText: saveText,
      builder: _themeWrapper,
    );
  }

  // ── Month + Year picker (custom bottom-sheet UI) ──────────────────────────

  static Future<DateTime?> pickMonthYear(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => _MonthYearPicker(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(1900),
        lastDate: lastDate ?? DateTime(2100),
      ),
    );
  }

  // ── Theme wrapper ────────────────────────────────────────────────────────────

  static Widget _themeWrapper(BuildContext context, Widget? child) {
    final scheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.xl),
          ),
          headerBackgroundColor: scheme.primary,
          headerForegroundColor: scheme.onPrimary,
          dayStyle: const TextStyle(fontSize: 13),
          todayBorder: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      child: child!,
    );
  }
}

// ─── Month/Year Picker UI ─────────────────────────────────────────────────────

class _MonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _MonthYearPicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<_MonthYearPicker> {
  late int _selectedMonth;
  late int _selectedYear;

  static const _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialDate.month;
    _selectedYear = widget.initialDate.year;
  }

  int get _minYear => widget.firstDate.year;
  int get _maxYear => widget.lastDate.year;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.xl),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.lg,
                vertical: SpacingTokens.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    'Select Month & Year',
                    variant: AppTextVariant.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // Year selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _selectedYear > _minYear
                        ? () => setState(() => _selectedYear--)
                        : null,
                  ),
                  GestureDetector(
                    onTap: _pickYearFromList,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.md,
                        vertical: SpacingTokens.sm,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                      ),
                      child: AppText(
                        '$_selectedYear',
                        variant: AppTextVariant.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _selectedYear < _maxYear
                        ? () => setState(() => _selectedYear++)
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingTokens.sm),

            // Month grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: SpacingTokens.sm,
                crossAxisSpacing: SpacingTokens.sm,
                childAspectRatio: 2.4,
                children: List.generate(12, (index) {
                  final month = index + 1;
                  final isSelected = month == _selectedMonth;
                  final isDisabled = _isMonthDisabled(month);

                  return InkWell(
                    onTap: isDisabled ? null : () => setState(() => _selectedMonth = month),
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                        border: isSelected
                            ? null
                            : Border.all(color: scheme.outline.withOpacity(0.3)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _months[index].substring(0, 3),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? scheme.onPrimary
                              : isDisabled
                                  ? scheme.onSurface.withOpacity(0.3)
                                  : scheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: SpacingTokens.md),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                0,
                SpacingTokens.lg,
                SpacingTokens.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      DateTime(_selectedYear, _selectedMonth),
                    );
                  },
                  child: Text(
                    'Select ${_months[_selectedMonth - 1]} $_selectedYear',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isMonthDisabled(int month) {
    if (_selectedYear == _minYear && month < widget.firstDate.month) return true;
    if (_selectedYear == _maxYear && month > widget.lastDate.month) return true;
    return false;
  }

  Future<void> _pickYearFromList() async {
    final years = List.generate(_maxYear - _minYear + 1, (i) => _minYear + i);
    final picked = await showDialog<int>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusTokens.xl)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360, maxWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(SpacingTokens.md),
                child: AppText('Select Year', variant: AppTextVariant.titleMedium, fontWeight: FontWeight.w600),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: years.length,
                  itemBuilder: (_, i) {
                    final y = years[i];
                    final selected = y == _selectedYear;
                    return ListTile(
                      title: Text(
                        '$y',
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: selected ? Theme.of(context).colorScheme.primary : null,
                        ),
                      ),
                      trailing: selected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 18) : null,
                      onTap: () => Navigator.pop(context, y),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) setState(() => _selectedYear = picked);
  }
}

// ─── AppDateField ─────────────────────────────────────────────────────────────

/// A form field that opens [AppDatePicker.pickDate] on tap.
///
/// ```dart
/// AppDateField(
///   label: 'Date of Birth',
///   onChanged: (date) => setState(() => _dob = date),
///   validator: (v) => v == null ? 'Required' : null,
/// )
/// ```
class AppDateField extends StatefulWidget {
  final String label;
  final String? hint;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;
  final void Function(DateTime?)? onChanged;
  final String? Function(DateTime?)? validator;
  final bool readOnly;
  final bool enabled;
  final IconData prefixIcon;

  const AppDateField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd MMM yyyy',
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon = Icons.calendar_today_outlined,
  });

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  DateTime? _value;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _value = widget.initialValue;
      _controller.text = _format(_value!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(DateTime d) => DateFormat(widget.dateFormat).format(d);

  Future<void> _pick() async {
    if (!widget.enabled || widget.readOnly) return;
    final picked = await AppDatePicker.pickDate(
      context,
      initialDate: _value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      setState(() {
        _value = picked;
        _controller.text = _format(picked);
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _value,
      validator: (_) => widget.validator?.call(_value),
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _controller,
            readOnly: true,
            enabled: widget.enabled,
            onTap: _pick,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint ?? 'Select date',
              prefixIcon: Icon(widget.prefixIcon),
              suffixIcon: _value != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        setState(() {
                          _value = null;
                          _controller.clear();
                        });
                        widget.onChanged?.call(null);
                      },
                    )
                  : const Icon(Icons.arrow_drop_down_rounded),
              errorText: state.errorText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AppDateRangeField ────────────────────────────────────────────────────────

/// Form field for a date range selection.
///
/// ```dart
/// AppDateRangeField(
///   label: 'Stay period',
///   onChanged: (range) => _range = range,
/// )
/// ```
class AppDateRangeField extends StatefulWidget {
  final String label;
  final DateTimeRange? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;
  final void Function(DateTimeRange?)? onChanged;
  final String? Function(DateTimeRange?)? validator;

  const AppDateRangeField({
    super.key,
    required this.label,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd MMM yy',
    this.onChanged,
    this.validator,
  });

  @override
  State<AppDateRangeField> createState() => _AppDateRangeFieldState();
}

class _AppDateRangeFieldState extends State<AppDateRangeField> {
  DateTimeRange? _value;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _value = widget.initialValue;
      _controller.text = _format(_value!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(DateTimeRange r) {
    final fmt = DateFormat(widget.dateFormat);
    return '${fmt.format(r.start)}  →  ${fmt.format(r.end)}';
  }

  Future<void> _pick() async {
    final picked = await AppDatePicker.pickDateRange(
      context,
      initialDateRange: _value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      setState(() {
        _value = picked;
        _controller.text = _format(picked);
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTimeRange>(
      initialValue: _value,
      validator: (_) => widget.validator?.call(_value),
      builder: (state) => TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: _pick,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: 'Select date range',
          prefixIcon: const Icon(Icons.date_range_outlined),
          suffixIcon: _value != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    setState(() {
                      _value = null;
                      _controller.clear();
                    });
                    widget.onChanged?.call(null);
                  },
                )
              : const Icon(Icons.arrow_drop_down_rounded),
          errorText: state.errorText,
        ),
      ),
    );
  }
}

// ─── AppTimeField ─────────────────────────────────────────────────────────────

/// Form field that opens time picker on tap.
class AppTimeField extends StatefulWidget {
  final String label;
  final TimeOfDay? initialValue;
  final void Function(TimeOfDay?)? onChanged;
  final String? Function(TimeOfDay?)? validator;
  final bool use24HourFormat;

  const AppTimeField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.use24HourFormat = false,
  });

  @override
  State<AppTimeField> createState() => _AppTimeFieldState();
}

class _AppTimeFieldState extends State<AppTimeField> {
  TimeOfDay? _value;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _value = widget.initialValue;
      _controller.text = _format(_value!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    return _controller.dispose();
  }

  String _format(TimeOfDay t) {
    if (widget.use24HourFormat) {
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    return '$hour:${t.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _pick() async {
    final picked = await AppDatePicker.pickTime(
      context,
      initialTime: _value,
      use24HourFormat: widget.use24HourFormat,
    );
    if (picked != null) {
      setState(() {
        _value = picked;
        _controller.text = _format(picked);
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      initialValue: _value,
      validator: (_) => widget.validator?.call(_value),
      builder: (state) => TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: _pick,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: 'Select time',
          prefixIcon: const Icon(Icons.access_time_outlined),
          suffixIcon: _value != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    setState(() {
                      _value = null;
                      _controller.clear();
                    });
                    widget.onChanged?.call(null);
                  },
                )
              : const Icon(Icons.arrow_drop_down_rounded),
          errorText: state.errorText,
        ),
      ),
    );
  }
}
