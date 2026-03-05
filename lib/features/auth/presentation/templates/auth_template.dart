import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/core/ui/design_system/organisms/app_scaffold_wrapper.dart';
import 'package:flutter/material.dart';

/// Template layout halaman auth — menggunakan [AppScaffoldWrapper] agar
/// konsisten dengan scaffold system yang ada di design system.
///
/// - Mobile  : single-column, logo di atas form
/// - Tablet/Desktop : two-column, logo panel kiri, form panel kanan
class AuthTemplate extends StatelessWidget {
  final Widget formSection;
  final Widget? logoSection;
  final Color? backgroundColor;

  const AuthTemplate({
    super.key,
    required this.formSection,
    this.logoSection,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isTablet || context.isDesktop) {
      return _TabletAuthLayout(
        formSection: formSection,
        logoSection: logoSection,
        backgroundColor: backgroundColor,
      );
    }
    return _MobileAuthLayout(
      formSection: formSection,
      logoSection: logoSection,
      backgroundColor: backgroundColor,
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
    // AppScaffoldWrapper tanpa navigationItems → pure Scaffold tanpa nav bar,
    // cocok untuk halaman auth yang memang tidak perlu navigasi bawah.
    return AppScaffoldWrapper(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 48),
              if (logoSection != null) ...[
                logoSection!,
                const SizedBox(height: 40),
              ],
              formSection,
              const SizedBox(height: 40),
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
    return AppScaffoldWrapper(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          // Panel kiri — dekoratif dengan logo
          Expanded(
            flex: 5,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Center(
                child: logoSection ??
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Enterprise App',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
          // Panel kanan — form
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
