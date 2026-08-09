import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/scroll_aware_widget.dart';

class ConnectSection extends StatelessWidget {
  const ConnectSection({super.key});

  static const List<_LinkData> _links = [
    _LinkData(
      label: 'GitHub',
      handle: '@MostafaMo426',
      description: 'Explore my open-source projects',
      url: 'https://github.com/MostafaMo426',
      gradientColors: [Color(0xFFEA6045), Color(0xFFF78166)],
      iconData: Icons.code_rounded,
    ),
    _LinkData(
      label: 'LinkedIn',
      handle: 'mostafa-mohamed-00435b332',
      description: 'Connect professionally',
      url: 'https://www.linkedin.com/in/mostafa-mohamed-00435b332/',
      gradientColors: [Color(0xFF0A66C2), Color(0xFF378FE9)],
      iconData: Icons.business_center_outlined,
    ),
    _LinkData(
      label: 'WhatsApp',
      handle: '+20 120 485 2902',
      description: 'Message me directly',
      url: 'https://wa.me/201204852902',
      gradientColors: [Color(0xFF128C7E), Color(0xFF25D366)],
      iconData: Icons.chat_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      child: SectionWrapper(
        child: ScrollAwareWidget(
          id: 'connect',
          builder: (context, visible) {
            return Column(
              children: [
                const SectionLabel(text: 'CONNECT')
                    .animate(target: visible ? 1 : 0)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 20),

                const SectionHeading(
                  text: 'Let\'s work together',
                  textAlign: TextAlign.center,
                )
                    .animate(target: visible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 12),

                Text(
                  'Whether you have a project in mind, want to collaborate,\nor just want to say hello — reach out!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ).animate(target: visible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 56),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    if (maxWidth < 600) {
                      return Column(
                        children: _links.asMap().entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _LinkCard(
                              data: e.value,
                              visible: visible,
                              delay: Duration(milliseconds: 200 + e.key * 100),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (maxWidth < 1000) {
                      final cardWidth = (maxWidth - 20) / 2;
                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: _links.asMap().entries.map((e) {
                          return SizedBox(
                            width: cardWidth,
                            child: _LinkCard(
                              data: e.value,
                              visible: visible,
                              delay: Duration(milliseconds: 200 + e.key * 100),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Row(
                        children: _links.asMap().entries.map((e) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: e.key < _links.length - 1 ? 20 : 0),
                              child: _LinkCard(
                                data: e.value,
                                visible: visible,
                                delay:
                                    Duration(milliseconds: 200 + e.key * 100),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LinkData {
  final String label;
  final String handle;
  final String description;
  final String url;
  final List<Color> gradientColors;
  final IconData iconData;

  const _LinkData({
    required this.label,
    required this.handle,
    required this.description,
    required this.url,
    required this.gradientColors,
    required this.iconData,
  });
}

class _LinkCard extends StatefulWidget {
  final _LinkData data;
  final bool visible;
  final Duration delay;

  const _LinkCard({
    required this.data,
    required this.visible,
    required this.delay,
  });

  @override
  State<_LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<_LinkCard> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.data.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedSlide(
          offset: Offset(0, _hovered ? -0.04 : 0),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: d.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppTheme.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? d.gradientColors[0].withValues(alpha: 0.6)
                  : AppTheme.border,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: d.gradientColors[0].withValues(alpha: 0.4),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ]
                : AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hovered
                        ? Colors.white.withValues(alpha: 0.3)
                        : AppTheme.border,
                  ),
                ),
                child: Icon(
                  d.iconData,
                  size: 28,
                  color: _hovered ? Colors.white : d.gradientColors[0],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                d.label,
                style: TextStyle(
                  color: _hovered ? Colors.white : AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                d.handle,
                style: TextStyle(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.8)
                      : d.gradientColors[0],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                d.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.75)
                      : AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.2)
                      : d.gradientColors[0].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _hovered
                        ? Colors.white.withValues(alpha: 0.4)
                        : d.gradientColors[0].withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Visit',
                      style: TextStyle(
                        color: _hovered ? Colors.white : d.gradientColors[0],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: _hovered ? Colors.white : d.gradientColors[0],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    )
        .animate(target: widget.visible ? 1 : 0)
        .fadeIn(duration: 700.ms, delay: widget.delay)
        .slideY(begin: 0.2, end: 0);
  }
}
