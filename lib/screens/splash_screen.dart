
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

const Color electricBlue = Color(0xFF168BFF);
const Color backgroundColor = Color(0xFF080B12);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutBack,
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _introController.forward();

    _navigationTimer = Timer(
      const Duration(seconds: 4),
      _openHomeScreen,
    );
  }

  void _openHomeScreen() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.25),
            radius: 1.1,
            colors: [
              Color(0xFF12233B),
              Color(0xFF080B12),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated target logo
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final glow = 0.25 +
                            (_pulseController.value * 0.45);

                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: electricBlue.withValues(
                                  alpha: glow,
                                ),
                                blurRadius:
                                    20 + _pulseController.value * 18,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: const TargetLogo(size: 124),
                    ),

                    const SizedBox(height: 32),

                    // AIMTRACK wordmark
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'AIM',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'TRACK',
                            style: TextStyle(color: electricBlue),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'PRECISION  •  FOCUS  •  PROGRESS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF92A6BE),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 76),

                    // Loading indicator
                    const SizedBox(
                      width: 165,
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: Color(0xFF253044),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          electricBlue,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'PREPARING YOUR NEXT SESSION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF71849B),
                        fontSize: 9,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TargetLogo extends StatelessWidget {
  final double size;

  const TargetLogo({
    super.key,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: TargetPainter(),
      ),
    );
  }
}

class TargetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final unit = size.width / 120;

    Paint ringPaint(Color color, double width) {
      return Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * unit;
    }

    canvas.drawCircle(
      center,
      47 * unit,
      ringPaint(const Color(0xFF25384D), 1.5),
    );

    canvas.drawCircle(
      center,
      35 * unit,
      ringPaint(electricBlue, 2.5),
    );

    canvas.drawCircle(
      center,
      22 * unit,
      ringPaint(electricBlue, 2),
    );

    final markPaint = Paint()
      ..color = electricBlue
      ..strokeWidth = 2.5 * unit
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final innerRadius = 40 * unit;
      final outerRadius = 55 * unit;

      final start = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );

      final end = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );

      canvas.drawLine(start, end, markPaint);
    }

    canvas.drawCircle(
      center,
      5 * unit,
      Paint()..color = electricBlue,
    );

    final accentPaint = Paint()
      ..color = const Color(0xFF5AB4FF)
      ..strokeWidth = 3 * unit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final accentPath = Path()
      ..moveTo(
        center.dx + 17 * unit,
        center.dy - 17 * unit,
      )
      ..lineTo(
        center.dx + 39 * unit,
        center.dy - 39 * unit,
      )
      ..lineTo(
        center.dx + 25 * unit,
        center.dy - 39 * unit,
      )
      ..moveTo(
        center.dx + 39 * unit,
        center.dy - 39 * unit,
      )
      ..lineTo(
        center.dx + 39 * unit,
        center.dy - 25 * unit,
      );

    canvas.drawPath(accentPath, accentPaint);
  }

  @override
  bool shouldRepaint(covariant TargetPainter oldDelegate) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AIMTRACK',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to AimTrack',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: electricBlue,
          ),
        ),
      ),
    );
  }
}