import 'package:flutter/material.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});
  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            Color(0xFF181C26),
            Color(0xFF202532),
            Color(0xFF181C26),
          ],
          stops: const [0.3, 0.5, 0.7],
          transform: _Slide(_c.value),
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}

class _Slide extends GradientTransform {
  const _Slide(this.t);
  final double t;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    // Сдвиг от -1.5 до +1.5 размера: блик полностью заходит
    // и полностью уходит за край, поэтому цикл замыкается без рывка.
    final shift = -1.5 + 3.0 * t;
    return Matrix4.translationValues(
      bounds.width * shift,
      bounds.height * shift,
      0,
    );
  }
}