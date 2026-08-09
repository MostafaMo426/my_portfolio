import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A floating particle that drifts upward with a subtle wobble.
class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double wobble;
  double wobbleSpeed;
  String symbol;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.wobble,
    required this.wobbleSpeed,
    required this.symbol,
  });
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _rng = Random();
  int _currentParticleCount = 45;

  final List<String> _symbols = [
    '◆', '●', '{}', '<>', '/>', '()', '=>', '∞', '⬡',
    'Dart', 'void', '..', '??', '&&', '||',
  ];

  @override
  void initState() {
    super.initState();
    _particles = List.generate(45, (_) => _randomParticle(init: true));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick)..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    final targetCount = width < 600 ? 16 : (width < 1024 ? 28 : 45);
    if (targetCount != _currentParticleCount) {
      _currentParticleCount = targetCount;
      if (_particles.length > targetCount) {
        _particles = _particles.sublist(0, targetCount);
      } else if (_particles.length < targetCount) {
        _particles.addAll(List.generate(
            targetCount - _particles.length, (_) => _randomParticle(init: true)));
      }
    }
  }

  Particle _randomParticle({bool init = false}) {
    final y = init ? _rng.nextDouble() : 1.05;
    return Particle(
      x: _rng.nextDouble(),
      y: y,
      size: _rng.nextDouble() * 10 + 6,
      speed: _rng.nextDouble() * 0.0008 + 0.0003,
      opacity: _rng.nextDouble() * 0.35 + 0.08,
      wobble: _rng.nextDouble() * 2 * pi,
      wobbleSpeed: _rng.nextDouble() * 0.02 + 0.005,
      symbol: _symbols[_rng.nextInt(_symbols.length)],
    );
  }

  void _tick() {
    setState(() {
      for (int i = 0; i < _particles.length; i++) {
        final p = _particles[i];
        p.y -= p.speed;
        p.wobble += p.wobbleSpeed;
        if (p.y < -0.1) {
          _particles[i] = _randomParticle();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(_particles),
      child: const SizedBox.expand(),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final double cx = p.x * size.width + sin(p.wobble) * 18;
      final double cy = p.y * size.height;

      final isCode = p.symbol.length > 1 ||
          ['{}', '<>', '/>', '()', '=>', '..', '??', '&&', '||', 'Dart', 'void'].contains(p.symbol);

      if (isCode) {
        // Draw as text
        final tp = TextPainter(
          text: TextSpan(
            text: p.symbol,
            style: TextStyle(
              color: AppTheme.flutterBlueLight.withValues(alpha: p.opacity),
              fontSize: p.size,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
      } else {
        // Draw as circle
        final paint = Paint()
          ..color = (p.symbol == '●'
              ? AppTheme.dartTeal
              : AppTheme.flutterBlueLight)
              .withValues(alpha: p.opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(cx, cy), p.size / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}
