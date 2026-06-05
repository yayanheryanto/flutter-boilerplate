import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WheelDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const WheelDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<WheelDatePicker> createState() => _WheelDatePickerState();
}

class _WheelDatePickerState extends State<WheelDatePicker> {
  late int day;
  late int month;
  late int year;

  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  final months = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();

    day = widget.initialDate.day;
    month = widget.initialDate.month;
    year = widget.initialDate.year;

    dayController = FixedExtentScrollController(
      initialItem: day - 1,
    );

    monthController = FixedExtentScrollController(
      initialItem: month - 1,
    );

    yearController = FixedExtentScrollController(
      initialItem: year - widget.firstDate.year,
    );
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _validateDay() {
    final maxDay = getDaysInMonth(year, month);

    if (day > maxDay) {
      day = maxDay;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (dayController.hasClients) {
          await dayController.animateToItem(
            day - 1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDay = getDaysInMonth(year, month);

    return Container(
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 30.w,
            height: 0.7.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 30,
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tanggal Lahir',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      bottom: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    /// DAY
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: dayController,
                        itemExtent: 42,
                        useMagnifier: true,
                        magnification: 1.05,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            day = index + 1;
                          });
                        },
                        children: List.generate(
                          maxDay,
                          (index) => Center(
                            child: Text('${index + 1}'),
                          ),
                        ),
                      ),
                    ),

                    /// MONTH
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: monthController,
                        itemExtent: 42,
                        useMagnifier: true,
                        magnification: 1.05,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            month = index + 1;
                            _validateDay();
                          });
                        },
                        children: months
                            .map(
                              (e) => Center(
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    /// YEAR
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: yearController,
                        itemExtent: 42,
                        useMagnifier: true,
                        magnification: 1.05,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            year = widget.firstDate.year + index;
                            _validateDay();
                          });
                        },
                        children: List.generate(
                          widget.lastDate.year - widget.firstDate.year + 1,
                          (index) => Center(
                            child: Text(
                              '${widget.firstDate.year + index}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  DateTime(
                    year,
                    month,
                    day,
                  ),
                );
              },
              child: const Text(
                'Mulai Verifikasi KTP',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
