import 'dart:async';
import 'package:flutter/material.dart';

class AppFeedback {
  AppFeedback._();
  static final ValueNotifier<String?> message = ValueNotifier<String?>(null);
  static Timer? _timer;
  static void show(String text) {
    _timer?.cancel();
    message.value = text;
    _timer = Timer(const Duration(seconds: 2), () => message.value = null);
  }
}

class AppFeedbackOverlay extends StatelessWidget {
  const AppFeedbackOverlay({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
        valueListenable: AppFeedback.message,
        builder: (context, text, _) {
          if (text == null) return const SizedBox.shrink();
          return IgnorePointer(child: Center(child: TweenAnimationBuilder<double>(
            tween: Tween(begin: .78, end: 1), duration: const Duration(milliseconds: 300), curve: Curves.easeOutBack,
            builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              margin: const EdgeInsets.symmetric(horizontal: 26),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFFE94F9B), Color(0xFFFF8A3D)]),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: .38), width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF8E5CF6).withValues(alpha: .42), blurRadius: 28, offset: const Offset(0, 12)),
                  BoxShadow(color: const Color(0xFFE94F9B).withValues(alpha: .18), blurRadius: 50),
                ],
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Text('✨', style: TextStyle(fontSize: 30)), SizedBox(width: 12),
                Flexible(child: _FeedbackText()),
              ]),
            ),
          )));
        },
      );
}

class _FeedbackText extends StatelessWidget {
  const _FeedbackText();
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
        valueListenable: AppFeedback.message,
        builder: (_, text, __) => Text(text ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.25)),
      );
}

class App3DCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? encouragement;
  final BorderRadius borderRadius;
  const App3DCard({super.key, required this.child, required this.onTap, this.encouragement, this.borderRadius = const BorderRadius.all(Radius.circular(24))});
  @override State<App3DCard> createState() => _App3DCardState();
}

class _App3DCardState extends State<App3DCard> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final depth = pressed ? 2.0 : 8.0;
    void tap() { if (widget.encouragement != null) AppFeedback.show(widget.encouragement!); widget.onTap(); }
    return Semantics(button: true, child: GestureDetector(
      onTap: tap,
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        transform: Matrix4.translationValues(0, pressed ? 4 : 0, 0),
        decoration: BoxDecoration(borderRadius: widget.borderRadius, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .25), blurRadius: pressed ? 5 : 13, offset: Offset(0, depth))]),
        child: Material(color: Theme.of(context).cardColor, elevation: pressed ? 1 : 5, shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: .18), shape: RoundedRectangleBorder(borderRadius: widget.borderRadius), clipBehavior: Clip.antiAlias, child: widget.child),
      ),
    ));
  }
}
