import 'dart:async';

import 'package:flutter/material.dart';

class AppFeedback {
  AppFeedback._();

  static final ValueNotifier<String?> message = ValueNotifier<String?>(null);
  static Timer? _timer;

  static void show(String text) {
    _timer?.cancel();
    message.value = text;
    _timer = Timer(const Duration(seconds: 2), () {
      message.value = null;
    });
  }
}

class AppFeedbackOverlay extends StatelessWidget {
  const AppFeedbackOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: AppFeedback.message,
      builder: (context, text, _) {
        if (text == null) return const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;
        return IgnorePointer(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: .82, end: 1),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) => Transform.scale(
                scale: scale,
                child: child,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 330),
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary,
                        scheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: .30),
                        blurRadius: 26,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class App3DCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? encouragement;
  final BorderRadius borderRadius;

  const App3DCard({
    super.key,
    required this.child,
    required this.onTap,
    this.encouragement,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  @override
  State<App3DCard> createState() => _App3DCardState();
}

class _App3DCardState extends State<App3DCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _tap() {
    if (widget.encouragement != null) {
      AppFeedback.show(widget.encouragement!);
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final depth = _pressed ? 2.0 : 7.0;

    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: _tap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _pressed ? 5 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: .20),
                blurRadius: depth + 3,
                offset: Offset(0, depth),
              ),
            ],
          ),
          child: Material(
            color: Theme.of(context).cardColor,
            elevation: _pressed ? 1 : 3,
            shadowColor: scheme.shadow.withValues(alpha: .25),
            shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
            clipBehavior: Clip.antiAlias,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
