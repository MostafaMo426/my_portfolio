import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'theme/app_theme.dart';
import 'widgets/nav_bar.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/projects_section.dart';
import 'sections/connect_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';

void main() {
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 100);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mostafa Mohamed Elsayed | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();

  // Section keys for scroll navigation (About, Projects, Connect, Contact)
  final List<GlobalKey> _sectionKeys = List.generate(4, (_) => GlobalKey());

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. Hero
                HeroSection(
                  onContact: () => _scrollToSection(3),
                ),

                // 2. About
                KeyedSubtree(
                  key: _sectionKeys[0],
                  child: const AboutSection(),
                ),

                // 3. Projects
                KeyedSubtree(
                  key: _sectionKeys[1],
                  child: const ProjectsSection(),
                ),

                // 4. Connect
                KeyedSubtree(
                  key: _sectionKeys[2],
                  child: const ConnectSection(),
                ),

                // 5. Contact
                KeyedSubtree(
                  key: _sectionKeys[3],
                  child: const ContactSection(),
                ),

                // 6. Footer
                const FooterSection(),
              ],
            ),
          ),

          // ── Sticky NavBar ────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              scrollController: _scrollController,
              sectionKeys: _sectionKeys,
            ),
          ),
        ],
      ),
    );
  }
}
