import 'package:flutter/material.dart';
import 'package:friecca/onboarding/onboarding1.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class Responsive {
  static double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) return 0.85;
    if (width < 480) return 0.95;
    if (width < 600) return 1.0;
    if (width < 900) return 1.15;
    return 1.3;
  }

  static double clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

/* =========================
   SPLASH SCREEN - Auto Navigate to Onboarding After 3 Seconds
========================= */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Start animations
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Navigate to Onboarding1Screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Onboarding1Screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = Responsive.scale(context);

    final logoSize = Responsive.clamp(
      math.min(size.width, size.height) * 0.28,
      120,
      220,
    );
    final iconSize = logoSize * 0.48;

    final titleSize = Responsive.clamp(42 * scale, 36, 68);
    final subtitleSize = Responsive.clamp(20 * scale, 18, 32);
    final taglineSize = Responsive.clamp(14 * scale, 12, 20);
    final smallFont = Responsive.clamp(10 * scale, 9, 14);

    final spacingLarge = Responsive.clamp(size.height * 0.05, 24, 60);
    final spacingMedium = Responsive.clamp(size.height * 0.03, 16, 40);
    final dividerWidth = Responsive.clamp(size.width * 0.16, 60, 120);
    final dotSize = Responsive.clamp(10 * scale, 8, 14);
    final dotMargin = Responsive.clamp(6 * scale, 4, 10);
    final footerBottom = Responsive.clamp(size.height * 0.045, 20, 50);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FBFF), Colors.white, Color(0xFFF0F7FF)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScaleTransition(
                              scale: _pulseAnimation,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0066FF)
                                          .withOpacity(0.3),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: logoSize,
                                  height: logoSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0066FF),
                                        Color(0xFF0052CC),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.medical_services_rounded,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacingLarge),
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                              ).createShader(bounds),
                              child: Text(
                                'Friecca',
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Shader makes it gradient
                                ),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Pharmacy',
                              style: TextStyle(
                                fontSize: subtitleSize,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF0066FF),
                              ),
                            ),
                            SizedBox(height: spacingMedium),
                            Container(
                              width: dividerWidth,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0066FF), Color(0xFF00CCFF)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: spacingMedium),
                            Text(
                              'Professional healthcare,\npersonalized for you.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: taglineSize,
                                height: 1.5,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: dotSize * 1.4,
                            child: AnimatedBuilder(
                              animation: _dotsController,
                              builder: (_, __) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (index) {
                                    final delay = index * 0.2;
                                    final value = (_dotsController.value - delay)
                                        .clamp(0.0, 1.0);
                                    final scale =
                                        0.5 + math.sin(value * math.pi) * 0.5;

                                    return Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: dotMargin),
                                        width: dotSize,
                                        height: dotSize,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF0066FF),
                                              Color(0xFF00CCFF),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: footerBottom),
                          Text(
                            'FRIECCA PHARMACY LTD',
                            style: TextStyle(
                              fontSize: smallFont,
                              letterSpacing: 2.5,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: footerBottom),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}