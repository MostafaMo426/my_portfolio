import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/scroll_aware_widget.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const List<_Skill> _skills = [
    _Skill('Flutter', 1.0, AppTheme.flutterBlueLight),
    _Skill('Dart', 1.0, AppTheme.flutterBlueDark),
    _Skill('BLE / Bluetooth', 1.0, AppTheme.dartTeal),
    _Skill('TCP Sockets', 1.0, Color(0xFF6E40C9)),
    _Skill('Firebase', 1.0, Color(0xFFF57C00)),
    _Skill('REST APIs', 1.0, Color(0xFF2EA043)),
    _Skill('Provider', 1.0, AppTheme.flutterBlueDark),
    _Skill('Git', 1.0, Color(0xFFF05133)),
    _Skill('IoT Integration', 1.0, AppTheme.dartTeal),
    _Skill('.NET / REST', 1.0, Color(0xFF512BD4)),
  ];

  static const List<String> _chips = [
    'Flutter', 'Dart', 'BLE', 'TCP Sockets', 'Firebase',
    'REST APIs', 'Provider', 'Git', 'IoT', 'TinyML',
    'Android', 'iOS', 'Flutter Web', 'Embedded Systems',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobileOrTablet = width < 1025;

    return Container(
      color: AppTheme.surface,
      child: SectionWrapper(
        child: ScrollAwareWidget(
          id: 'about',
          builder: (context, visible) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                const SectionLabel(text: 'ABOUT ME')
                    .animate(target: visible ? 1 : 0)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 20),

                // Heading
                const SectionHeading(text: 'Who am I?')
                    .animate(target: visible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 48),

                if (isMobileOrTablet)
                  _mobileLayout(visible)
                else
                  _desktopLayout(visible),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _desktopLayout(bool visible) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _BioCard(visible: visible),
        ),
        const SizedBox(width: 56),
        Expanded(
          flex: 7,
          child: _SkillBars(skills: _skills, chips: _chips, visible: visible),
        ),
      ],
    );
  }

  Widget _mobileLayout(bool visible) {
    return Column(
      children: [
        _BioCard(visible: visible),
        const SizedBox(height: 40),
        _SkillBars(skills: _skills, chips: _chips, visible: visible),
      ],
    );
  }
}

class _BioCard extends StatelessWidget {
  final bool visible;
  const _BioCard({required this.visible});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20 : 32),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile photo
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.flutterBlueLight.withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
                border: Border.all(
                  color: AppTheme.flutterBlueLight.withValues(alpha: 0.6),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/Me.jpeg',
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
                        size: 56,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ).animate(target: visible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1)),

          const SizedBox(height: 24),

          Text(
            'Computer Engineering graduate from Egypt with a passion for pushing the boundaries of what mobile apps can do.',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
              height: 1.75,
            ),
          ).animate(target: visible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 300.ms),

          const SizedBox(height: 16),

          Text(
            'I specialize in mobile-to-hardware integration — connecting smartphones to embedded systems via BLE and TCP, building IoT pipelines, and delivering polished cross-platform Flutter applications.',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
              height: 1.75,
            ),
          ).animate(target: visible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 400.ms),

          const SizedBox(height: 24),

          // Detail chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _DetailChip(icon: Icons.location_on_outlined, label: 'Egypt'),
              _DetailChip(icon: Icons.school_outlined, label: 'Computer Engineering'),
              _DetailChip(icon: Icons.bluetooth, label: 'BLE Expert'),
              _DetailChip(icon: Icons.devices_other, label: 'IoT'),
            ],
          ).animate(target: visible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 500.ms),
        ],
      ),
    ).animate(target: visible ? 1 : 0)
        .fadeIn(duration: 700.ms, delay: 100.ms)
        .slideX(begin: -0.1, end: 0);
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.flutterBlueDark.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.flutterBlueDark.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.flutterBlueLight),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.flutterBlueLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Skill {
  final String name;
  final double level;
  final Color color;
  const _Skill(this.name, this.level, this.color);
}

class _SkillBars extends StatelessWidget {
  final List<_Skill> skills;
  final List<String> chips;
  final bool visible;

  const _SkillBars({
    required this.skills,
    required this.chips,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Skills',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(skills.length, (i) {
          final s = skills[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _AnimatedSkillBar(
              skill: s,
              visible: visible,
              delay: Duration(milliseconds: 150 + i * 80),
            ),
          );
        }),
        const SizedBox(height: 32),
        const Text(
          'Technologies',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: chips.asMap().entries.map((e) {
            return _TechChip(label: e.value)
                .animate(target: visible ? 1 : 0)
                .fadeIn(
                  duration: 400.ms,
                  delay: Duration(milliseconds: 800 + e.key * 60),
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                );
          }).toList(),
        ),
      ],
    ).animate(target: visible ? 1 : 0)
        .fadeIn(duration: 700.ms, delay: 100.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

class _AnimatedSkillBar extends StatefulWidget {
  final _Skill skill;
  final bool visible;
  final Duration delay;

  const _AnimatedSkillBar({
    required this.skill,
    required this.visible,
    required this.delay,
  });

  @override
  State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<_AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  @override
  void didUpdateWidget(covariant _AnimatedSkillBar old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.skill.level * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.skill.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                color: widget.skill.color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(3),
              ),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) {
                  final targetWidth =
                      constraints.maxWidth * _anim.value * widget.skill.level;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: targetWidth.clamp(0.0, constraints.maxWidth),
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.skill.color,
                            widget.skill.color.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: widget.skill.color.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TechChip extends StatefulWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered
              ? AppTheme.flutterBlueDark.withValues(alpha: 0.2)
              : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? AppTheme.flutterBlueLight.withValues(alpha: 0.6)
                : AppTheme.border,
          ),
          boxShadow: _hovered ? AppTheme.blueGlow : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hovered
                ? AppTheme.flutterBlueLight
                : AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
