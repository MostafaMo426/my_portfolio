import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/particle_background.dart';
import '../widgets/section_wrapper.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onContact;
  const HeroSection({super.key, required this.onContact});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  static const List<String> _titles = [
    'Flutter Developer & Computer Engineer',
  ];

  int _titleIndex = 0;
  String _displayedSubtitle = '';
  int _charIndex = 0;
  bool _isDeleting = false;
  bool _showCursor = true;
  Timer? _loopTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), _typeNextChar);
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 530),
      (_) {
        if (mounted) setState(() => _showCursor = !_showCursor);
      },
    );
  }

  void _typeNextChar() {
    if (!mounted) return;
    final currentTitle = _titles[_titleIndex];

    if (!_isDeleting) {
      // Typing forward
      if (_charIndex < currentTitle.length) {
        setState(() {
          _displayedSubtitle = currentTitle.substring(0, ++_charIndex);
        });
        _loopTimer = Timer(const Duration(milliseconds: 60), _typeNextChar);
      } else {
        // Pause at complete text for 2.2 seconds before deleting
        _loopTimer = Timer(const Duration(milliseconds: 2200), () {
          if (mounted) {
            setState(() => _isDeleting = true);
            _typeNextChar();
          }
        });
      }
    } else {
      // Deleting / Backspacing character by character
      if (_charIndex > 0) {
        setState(() {
          _displayedSubtitle = currentTitle.substring(0, --_charIndex);
        });
        _loopTimer = Timer(const Duration(milliseconds: 32), _typeNextChar);
      } else {
        // Paused briefly on empty before typing next title
        setState(() {
          _isDeleting = false;
          _titleIndex = (_titleIndex + 1) % _titles.length;
        });
        _loopTimer = Timer(const Duration(milliseconds: 450), _typeNextChar);
      }
    }
  }

  Future<void> _downloadCV() async {
    final uri = Uri.parse('https://pdflink.to/bb5c5602/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _loopTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.background, Color(0xFF070D18)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Radial glow behind name
          Positioned(
            top: size.height * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 600,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.flutterBlueDark.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Particles
          const ParticleBackground(),

          // Content
          SectionWrapper(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? (size.width < 360 ? 16 : 24) : 48,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isMobile ? 60 : 80),

                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppTheme.dartTeal.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(24),
                      color: AppTheme.dartTeal.withValues(alpha: 0.08),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.dartTeal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Available for opportunities',
                          style: TextStyle(
                            color: AppTheme.dartTeal,
                            fontSize: size.width < 360 ? 11 : 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 20),

                  // Name
                  Text(
                    'Mostafa\nMohamed Elsayed',
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                      fontSize: size.width < 360
                          ? 32
                          : (size.width < 600
                              ? 40
                              : (size.width < 1024 ? 54 : 68)),
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: size.width < 600 ? -1 : -2,
                      height: 1.05,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 700.ms, delay: 400.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 16),

                  // Typewriter subtitle
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isMobile
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (b) =>
                              AppTheme.primaryGradient.createShader(b),
                          child: Text(
                            _displayedSubtitle,
                            style: TextStyle(
                              fontSize: size.width < 360
                                  ? 15
                                  : (size.width < 600 ? 18 : 24),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _showCursor ? 1 : 0,
                          duration: const Duration(milliseconds: 100),
                          child: Container(
                            width: 2,
                            height: size.width < 600 ? 20 : 26,
                            margin: const EdgeInsets.only(left: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.flutterBlueLight,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 700.ms),

                  const SizedBox(height: 16),

                  // Short tagline
                  Text(
                    'Building cross-platform experiences — from mobile\nto hardware, BLE to IoT.',
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                      fontSize: size.width < 360 ? 13 : (size.width < 600 ? 14 : 16),
                      color: AppTheme.textSecondary,
                      height: 1.65,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 900.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 36),

                  // CTA buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: isMobile
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    children: [
                      GradientButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        onTap: _downloadCV,
                      ),
                      GradientButton(
                        label: 'Contact Me',
                        icon: Icons.mail_outline_rounded,
                        outlined: true,
                        onTap: widget.onContact,
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1100.ms)
                      .slideY(begin: 0.2, end: 0),

                  SizedBox(height: isMobile ? 40 : 60),
                ],
              ),
            ),
          ),


          // Scroll indicator
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Scroll to explore',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textMuted,
                    size: 22,
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .slideY(
                        begin: 0,
                        end: 0.4,
                        duration: 900.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .slideY(begin: 0.4, end: 0, duration: 900.ms),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 1400.ms),
          ),
        ],
      ),
    );
  }
}
