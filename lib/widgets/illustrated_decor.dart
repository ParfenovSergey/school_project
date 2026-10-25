import 'package:flutter/material.dart';

import 'story_theme.dart';

/// Ограничение ширины текста, общее для полноэкранной главной и внутренних страниц.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Padding(padding: padding, child: child),
    ),
  );
}

/// Многослойный край облаков рисуется по фактической ширине экрана.
class CloudEdge extends StatelessWidget {
  const CloudEdge({this.height = 100, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: CustomPaint(painter: _CloudPainter()),
      ),
    ),
  );
}

class _CloudPainter extends CustomPainter {
  const _CloudPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cloud = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.68)
      ..cubicTo(w * 0.03, h * 0.45, w * 0.06, h * 0.53, w * 0.09, h * 0.57)
      ..cubicTo(w * 0.1, h * 0.1, w * 0.16, h * 0.1, w * 0.18, h * 0.39)
      ..cubicTo(w * 0.21, h * 0.28, w * 0.25, h * 0.33, w * 0.27, h * 0.5)
      ..cubicTo(w * 0.31, h * 0.06, w * 0.38, h * 0.09, w * 0.4, h * 0.36)
      ..cubicTo(w * 0.45, h * 0.05, w * 0.51, h * 0.18, w * 0.52, h * 0.45)
      ..cubicTo(w * 0.55, h * 0.29, w * 0.6, h * 0.28, w * 0.62, h * 0.45)
      ..cubicTo(w * 0.66, h * 0.02, w * 0.74, h * 0.12, w * 0.75, h * 0.42)
      ..cubicTo(w * 0.79, h * 0.23, w * 0.84, h * 0.33, w * 0.86, h * 0.53)
      ..cubicTo(w * 0.9, h * 0.2, w * 0.95, h * 0.39, w * 0.96, h * 0.6)
      ..quadraticBezierTo(w * 0.99, h * 0.48, w, h * 0.69)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(cloud, Paint()..color = const Color(0xFFB8EBDF));
    canvas.save();
    canvas.translate(0, h * 0.22);
    canvas.drawPath(cloud, Paint()..color = StoryColors.paper);
    canvas.restore();
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.96, w, h * 0.04),
      Paint()..color = StoryColors.paper,
    );
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) => false;
}

/// Небольшая небесная полоса связывает внутренние страницы с главной сценой.
class SkyRibbon extends StatelessWidget {
  const SkyRibbon({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [StoryColors.deepOcean, StoryColors.sky],
      ),
    ),
    child: const CloudEdge(height: 78),
  );
}

/// Декоративные облака и птицы не перекрывают интерактивные элементы.
class SkyOrnaments extends StatelessWidget {
  const SkyOrnaments({super.key});

  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: IgnorePointer(child: CustomPaint(painter: _SkyPainter())),
  );
}

class _SkyPainter extends CustomPainter {
  const _SkyPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    void cloud(double x, double y, double scale) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: scale,
          height: scale * 0.22,
        ),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x - scale * 0.17, y - scale * 0.08),
          width: scale * 0.37,
          height: scale * 0.3,
        ),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x + scale * 0.12, y - scale * 0.13),
          width: scale * 0.45,
          height: scale * 0.37,
        ),
        paint,
      );
    }

    cloud(size.width * 0.02, size.height * 0.56, 150);
    cloud(size.width * 0.96, size.height * 0.31, 120);
    final birds = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final x = size.width * 0.7 + i * 24;
      final y = 36.0 + (i % 2) * 14;
      canvas.drawPath(
        Path()
          ..moveTo(x - 10, y + 4)
          ..quadraticBezierTo(x - 4, y - 6, x, y)
          ..quadraticBezierTo(x + 6, y - 6, x + 13, y + 2),
        birds,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SkyPainter oldDelegate) => false;
}

/// Листья в подвале остаются чёткими на любом масштабе без растрового фона.
class BotanicalTrim extends StatelessWidget {
  const BotanicalTrim({super.key});

  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: CustomPaint(painter: _LeavesPainter()),
      ),
    ),
  );
}

class _LeavesPainter extends CustomPainter {
  const _LeavesPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    void leaf(double x, double angle, double length, Color color) {
      canvas.save();
      canvas.translate(x, size.height + 5);
      canvas.rotate(angle);
      final width = length * 0.22;
      final path = Path()
        ..moveTo(0, 0)
        ..cubicTo(-width, -length * 0.32, -width, -length * 0.85, 0, -length)
        ..cubicTo(width, -length * 0.85, width, -length * 0.32, 0, 0);
      canvas.drawPath(path, Paint()..color = color);
      canvas.restore();
    }

    const positions = [0.015, 0.07, 0.14, 0.23, 0.77, 0.86, 0.93, 0.985];
    for (var i = 0; i < positions.length; i++) {
      final x = positions[i] * size.width;
      leaf(x, -0.7, 65.0 + (i % 3) * 12, const Color(0xFFB7D25B));
      leaf(x + 12, 0.55, 80.0 + (i % 2) * 18, StoryColors.leaf);
      leaf(x + 6, -0.1, 48.0 + (i % 3) * 16, const Color(0xFF5E923F));
    }
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..quadraticBezierTo(
          size.width * 0.25,
          size.height - 18,
          size.width * 0.5,
          size.height - 4,
        )
        ..quadraticBezierTo(
          size.width * 0.75,
          size.height - 16,
          size.width,
          size.height,
        )
        ..close(),
      Paint()..color = const Color(0xFFEAF4E0),
    );
  }

  @override
  bool shouldRepaint(covariant _LeavesPainter oldDelegate) => false;
}

/// Иллюстрация необязательна: при отсутствии файла остаётся законченная композиция.
class StoryArtwork extends StatelessWidget {
  const StoryArtwork({
    required this.asset,
    required this.height,
    this.hero = false,
    super.key,
  });

  final String? asset;
  final double height;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Icon(
        Icons.explore_outlined,
        size: hero ? 120 : 72,
        color: hero
            ? Colors.white.withValues(alpha: 0.6)
            : StoryColors.ocean.withValues(alpha: 0.5),
      ),
    );
    return ExcludeSemantics(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: asset == null
            ? fallback
            : Image.asset(
                asset!,
                fit: hero ? BoxFit.contain : BoxFit.cover,
                filterQuality: FilterQuality.high,
                excludeFromSemantics: true,
                errorBuilder: (context, error, stack) => fallback,
              ),
      ),
    );
  }
}
