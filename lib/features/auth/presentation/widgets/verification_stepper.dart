import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/utils/account_type.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';

enum VerificationStepState { completed, active, inactive }

class VerificationStepper extends StatefulWidget {
  final int currentStep;
  final AccountType? accountType;

  const VerificationStepper({
    super.key,
    required this.currentStep,
    this.accountType,
  });

  @override
  State<VerificationStepper> createState() => _VerificationStepperState();
}

class _VerificationStepperState extends State<VerificationStepper> {
  final _scrollController = ScrollController();

  List<String> get steps => [
        'Verifikasi ${widget.accountType == AccountType.personal ? 'KTP' : 'NPWP'}',
        'Verifikasi Wajah',
        'Informasi Alamat',
        'Informasi Data Bank',
        'Review Informasi Data',
      ];

  late final List<GlobalKey> _stepKeys = List.generate(
    steps.length,
    (_) => GlobalKey(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => _scrollToActive());
  }

  @override
  void didUpdateWidget(VerificationStepper old) {
    super.didUpdateWidget(old);
    if (old.currentStep != widget.currentStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) async => _scrollToActive());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToActive() async {
    if (!_scrollController.hasClients) return;

    final key = _stepKeys[widget.currentStep];
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final scrollBox = _scrollController.position.context.storageContext.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;

    final localOffset = box.localToGlobal(Offset.zero, ancestor: scrollBox);
    final targetOffset = (_scrollController.offset + localOffset.dx).clamp(0.0, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.md,
        vertical: Spacings.sm,
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              return _StepConnector(isCompleted: widget.currentStep > i ~/ 2);
            }
            final idx = i ~/ 2;
            return _StepItem(
              key: _stepKeys[idx],
              index: idx,
              label: steps[idx],
              state: idx < widget.currentStep
                  ? VerificationStepState.completed
                  : idx == widget.currentStep
                      ? VerificationStepState.active
                      : VerificationStepState.inactive,
            );
          }),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int index;
  final String label;
  final VerificationStepState state;

  const _StepItem({
    super.key,
    required this.index,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = state == VerificationStepState.active;
    final isCompleted = state == VerificationStepState.completed;
    final isInactive = state == VerificationStepState.inactive;

    final circleColor = isInactive ? Colors.grey.shade300 : AppColors.primary500;
    final textColor = isInactive ? Colors.grey.shade400 : Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, size: 13, color: Colors.white)
              : AppText(
                  '${index + 1}',
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.bold,
                  color: isInactive ? Colors.grey.shade500 : Colors.white,
                ),
        ),
        const AppSpacer.sm(horizontal: true),
        AppText(
          label,
          variant: AppTextVariant.labelMedium,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: textColor,
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: isCompleted ? AppColors.primary500 : Colors.grey.shade300,
    );
  }
}
