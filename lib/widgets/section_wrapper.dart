import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Constrains content to a max-width and adds responsive horizontal padding.
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;
  final Color? background;

  const SectionWrapper({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 1200,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double hPad = width < 600
        ? 20
        : width < 1024
            ? 48
            : 80;

    return Container(
      color: background,
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: hPad, vertical: 80),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Gradient section label chip shown above section headings.
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.blueGlow,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

/// A section heading with an accent underline.
class SectionHeading extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const SectionHeading({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

/// Animated gradient button with hover glow.
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool outlined;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: widget.outlined
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hovered
                        ? AppTheme.flutterBlueLight
                        : AppTheme.border,
                    width: 1.5,
                  ),
                  color: _hovered
                      ? AppTheme.flutterBlueLight.withValues(alpha: 0.1)
                      : Colors.transparent,
                )
              : BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _hovered ? AppTheme.blueGlow : [],
                ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.outlined
                      ? (_hovered
                          ? AppTheme.flutterBlueLight
                          : AppTheme.textSecondary)
                      : Colors.white,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.outlined
                      ? (_hovered
                          ? AppTheme.flutterBlueLight
                          : AppTheme.textSecondary)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
