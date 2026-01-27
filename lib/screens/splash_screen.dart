import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Futuristic Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neonPurple.withValues(alpha: 0.15),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(duration: 3.seconds, curve: Curves.easeInOut)
             .blur(begin: const Offset(50, 50), end: const Offset(100, 100)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neonGreen.withValues(alpha: 0.1),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(duration: 4.seconds, curve: Curves.easeInOut)
             .blur(begin: const Offset(40, 40), end: const Offset(80, 80)),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AI Generated Logo with Hyper-Modern Frame
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonPurple.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/splash_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .animate()
                .scale(duration: 1200.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 1000.ms)
                .shimmer(delay: 1500.ms, duration: 2000.ms, color: Colors.white.withValues(alpha: 0.1)),
                
                const SizedBox(height: 48),
                
                Text(
                  'CLUB FINDER',
                  style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                    fontSize: 36,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: AppTheme.neonPurple.withValues(alpha: 0.8),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 1000.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
                
                const SizedBox(height: 12),
                
                // Futuristic Loading Bar
                Container(
                  width: 150,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 0,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppTheme.neonGreen,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonGreen.withValues(alpha: 0.5),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ).animate().custom(
                        duration: 3000.ms,
                        builder: (context, value, child) => SizedBox(
                          width: 150 * value,
                          child: child,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 1200.ms),
                
                const SizedBox(height: 24),
                
                Text(
                  'SYSTEMS INITIALIZING...',
                  style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neonGreen.withValues(alpha: 0.7),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 1000.ms)
                .then()
                .fadeOut(duration: 1000.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
