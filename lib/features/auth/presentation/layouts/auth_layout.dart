import 'package:boilerplate/core/responsive/responsive_builder.dart';
import 'package:boilerplate/shared/layouts/app_scaffold_wrapper.dart';
import 'package:boilerplate/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';

/// Layout for all auth pages (login, register, forgot password).
///
/// Pass [logoSection] as an [AppLogo] from the shared design system.
///
/// Responsive behaviour:
/// - Mobile  : single-column — logo above form.
/// - Tablet/Desktop : two-column — logo panel left, form panel right.
class AuthLayout extends StatelessWidget {
  final Widget formSection;
  final Widget? logoSection;
  final Color? backgroundColor;

  const AuthLayout({
    super.key,
    required this.formSection,
    this.logoSection,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      mobile: _MobileAuthLayout(
        formSection: formSection,
        logoSection: logoSection,
        backgroundColor: backgroundColor,
      ),
      tablet: _TabletAuthLayout(
        formSection: formSection,
        logoSection: logoSection,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

// ── Mobile layout ──────────────────────────────────────────────────────────────

class _MobileAuthLayout extends StatelessWidget {
  final Widget formSection;
  final Widget? logoSection;
  final Color? backgroundColor;

  const _MobileAuthLayout({
    required this.formSection,
    this.logoSection,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppSpacer(48),
              if (logoSection != null) ...[
                logoSection!,
                const AppSpacer(40),
              ],
              formSection,
              const AppSpacer(40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tablet / Desktop layout ────────────────────────────────────────────────────

class _TabletAuthLayout extends StatelessWidget {
  final Widget formSection;
  final Widget? logoSection;
  final Color? backgroundColor;

  const _TabletAuthLayout({
    required this.formSection,
    this.logoSection,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffoldWrapper(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          // Left panel — decorative with logo
          Expanded(
            flex: 5,
            child: ColoredBox(
              color: scheme.primaryContainer,
              child: Center(
                child: logoSection ??
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          size: 80,
                          color: scheme.primary,
                        ),
                        const AppSpacer.lg(),
                        AppText(
                          'Enterprise App',
                          variant: AppTextVariant.headlineMedium,
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
              ),
            ),
          ),
          // Right panel — form
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: formSection,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
