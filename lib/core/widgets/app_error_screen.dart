import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class AppErrorScreen extends StatefulWidget {
  const AppErrorScreen({super.key, required this.details});

  final FlutterErrorDetails details;

  @override
  State<AppErrorScreen> createState() => _AppErrorScreenState();
}

class _AppErrorScreenState extends State<AppErrorScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    log('Flutter Error: ${widget.details}', error: widget.details.exception);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ColorsManager.surfaceColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Subtle top accent bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorsManager.errorLight, ColorsManager.errorDark],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Oops image with subtle shadow
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.errorLight.withValues(
                                  alpha: 0.12,
                                ),
                                blurRadius: 40,
                                spreadRadius: 8,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            AssetsManager.oopsImage,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          LocaleKeys.oopsTitle,
                          style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w800,
                            color: ColorsManager.primaryColor,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Subtitle
                        Text(
                          LocaleKeys.oopsSubtitle,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: ColorsManager.grayText,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // Error pill badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.errorLight.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorsManager.errorLight.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 16,
                                color: ColorsManager.errorDark,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.details.exceptionAsString(),
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: ColorsManager.errorDark,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Retry button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  ColorsManager.primaryColor,
                                  ColorsManager.accentTextColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorsManager.primaryColor.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                // Rebuild from the error boundary
                                (context as Element).markNeedsBuild();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    LocaleKeys.back,
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
