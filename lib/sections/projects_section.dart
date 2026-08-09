import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/scroll_aware_widget.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const List<_ProjectData> _projects = [
    _ProjectData(
      title: 'Weave',
      subtitle: 'Off-Grid P2P Chat App',
      description:
          'Nov 2025 – Dec 2025. A fully offline peer-to-peer chat app using a serverless Cluster Topology — '
          'no internet, SIM card, or router required. Uses a 2-phase hybrid protocol: BLE for low-power device '
          'discovery, automatically upgraded to Wi-Fi Direct (SoftAP) for high-speed data transfer up to 80 m range.',
      techStack: ['Flutter', 'Dart', 'Nearby Connections API', 'BLE', 'Wi-Fi Direct', 'P2P'],
      githubUrl: 'https://github.com/MostafaMo426/Weave',
      gradientColors: [Color(0xFF6E40C9), Color(0xFFB067F5)],
      icon: Icons.hub_outlined,
      badge: null,
    ),
    _ProjectData(
      title: 'Lanco',
      subtitle: 'LAN Offline P2P Chat',
      description:
          'A fully offline, LAN-based peer-to-peer messaging application built with Flutter. '
          'No internet required — devices discover and communicate directly over your local network using TCP sockets. '
          'Features real-time messaging, file transfer, and device discovery.',
      techStack: ['Flutter', 'Dart', 'TCP Sockets', 'LAN', 'P2P'],
      githubUrl: 'https://github.com/MostafaMo426/Lanco',
      gradientColors: [Color(0xFF0175C2), Color(0xFF54C5F8)],
      icon: Icons.chat_bubble_outline_rounded,
      badge: null,
    ),
    _ProjectData(
      title: 'EdgeVoice',
      subtitle: 'AI Smart Home App',
      description:
          'Graduation project (Grade: A+). A Flutter-based smart home application powered by on-device AI. '
          'Uses BLE to communicate with embedded microcontrollers running TinyML models for voice/gesture recognition. '
          'Integrates with a .NET REST API backend for device management and automation rules.',
      techStack: ['Flutter', 'BLE', 'TinyML', '.NET', 'REST API', 'IoT'],
      githubUrl: 'https://github.com/MostafaMo426/EdgeVoice',
      gradientColors: [Color(0xFF00B4AB), Color(0xFF0080FF)],
      icon: Icons.home_outlined,
      badge: 'A+',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: ScrollAwareWidget(
        id: 'projects',
        builder: (context, visible) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: 'PROJECTS')
                  .animate(target: visible ? 1 : 0)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 20),

              const SectionHeading(text: 'What I\'ve built')
                  .animate(target: visible ? 1 : 0)
                  .fadeIn(duration: 600.ms, delay: 100.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 12),

              Text(
                'A selection of projects that showcase my expertise in Flutter, '
                'hardware integration, and real-world problem solving.',
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
                    // Mobile: 1 full-width card
                    return Column(
                      children: _projects.asMap().entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _ProjectCard(
                            project: e.value,
                            visible: visible,
                            delay: Duration(milliseconds: 200 + e.key * 100),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (maxWidth < 1000) {
                    // Tablet: 2 cards per row
                    final cardWidth = (maxWidth - 24) / 2;
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: _projects.asMap().entries.map((e) {
                        return SizedBox(
                          width: cardWidth,
                          child: _ProjectCard(
                            project: e.value,
                            visible: visible,
                            delay: Duration(milliseconds: 200 + e.key * 100),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    // Desktop: 3 cards per row
                    final cardWidth = (maxWidth - 48) / 3;
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: _projects.asMap().entries.map((e) {
                        return SizedBox(
                          width: cardWidth,
                          child: _ProjectCard(
                            project: e.value,
                            visible: visible,
                            delay: Duration(milliseconds: 200 + e.key * 120),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),

              const SizedBox(height: 48),

              // ── View All Projects button ──────────────────────
              Center(
                child: _ViewAllProjectsButton(visible: visible),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String subtitle;
  final String description;
  final List<String> techStack;
  final String githubUrl;
  final List<Color> gradientColors;
  final IconData icon;
  final String? badge;

  const _ProjectData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techStack,
    required this.githubUrl,
    required this.gradientColors,
    required this.icon,
    required this.badge,
  });
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  final bool visible;
  final Duration delay;

  const _ProjectCard({
    required this.project,
    required this.visible,
    required this.delay,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _hoverCtrl;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _elevation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  void _setHover(bool v) {
    setState(() => _hovered = v);
    if (v) {
      _hoverCtrl.forward();
    } else {
      _hoverCtrl.reverse();
    }
  }

  Future<void> _openGitHub() async {
    final uri = Uri.parse(widget.project.githubUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return AnimatedBuilder(
      animation: _elevation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, -6 * _elevation.value),
          child: child,
        );
      },
      child: MouseRegion(
        onEnter: (_) => _setHover(true),
        onExit: (_) => _setHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppTheme.cardGradient,
            border: Border.all(
              color: _hovered
                  ? p.gradientColors[0].withValues(alpha: 0.6)
                  : AppTheme.border,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: p.gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ]
                : AppTheme.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image area
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: p.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                            ),
                            itemBuilder: (_, __) => Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            itemCount: 64,
                          ),
                        ),
                      ),
                      Center(
                        child: AnimatedScale(
                          scale: _hovered ? 1.12 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            p.icon,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ),
                      if (p.badge != null)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFF5A623).withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  'Grade: ${p.badge}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.subtitle,
                        style: TextStyle(
                          color: p.gradientColors[0],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        p.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: p.techStack.map((t) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: p.gradientColors[0].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: p.gradientColors[0].withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                color: p.gradientColors[0],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _openGitHub,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: p.gradientColors),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        p.gradientColors[0].withValues(alpha: 0.35),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.code_rounded,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'View on GitHub',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
        .slideY(begin: 0.15, end: 0);
  }
}

// ── View All Projects on GitHub button ─────────────────────────────────────

class _ViewAllProjectsButton extends StatefulWidget {
  final bool visible;
  const _ViewAllProjectsButton({required this.visible});

  @override
  State<_ViewAllProjectsButton> createState() => _ViewAllProjectsButtonState();
}

class _ViewAllProjectsButtonState extends State<_ViewAllProjectsButton> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse('https://github.com/MostafaMo426');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered
                  ? AppTheme.flutterBlueLight
                  : AppTheme.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
            color: _hovered
                ? AppTheme.flutterBlueDark.withValues(alpha: 0.15)
                : AppTheme.surfaceElevated,
            boxShadow: _hovered ? AppTheme.blueGlow : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                size: 20,
                color: _hovered
                    ? AppTheme.flutterBlueLight
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 10),
              Text(
                'View All Projects on GitHub',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _hovered
                      ? AppTheme.flutterBlueLight
                      : AppTheme.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(left: _hovered ? 4.0 : 0.0),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _hovered
                      ? AppTheme.flutterBlueLight
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(target: widget.visible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: 700.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
