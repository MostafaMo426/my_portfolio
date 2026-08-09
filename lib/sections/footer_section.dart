import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      color: const Color(0xFF080D14),
      child: Column(
        children: [
          Container(height: 1, color: AppTheme.border),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 48,
              vertical: 32,
            ),
            child: Column(
              children: [
                // Footer logo
                ShaderMask(
                  shaderCallback: (b) =>
                      AppTheme.primaryGradient.createShader(b),
                  child: const Text(
                    'M</>',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: 'Built with Flutter '),
                      const TextSpan(
                        text: '💙',
                        style: TextStyle(fontSize: 14),
                      ),
                      const TextSpan(text: ' by '),
                      const TextSpan(
                        text: 'Mostafa Mohamed Elsayed',
                        style: TextStyle(
                          color: AppTheme.flutterBlueLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' · $year'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Flutter Developer & Computer Engineer · Egypt',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
