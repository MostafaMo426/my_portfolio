import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/section_wrapper.dart';
import '../widgets/scroll_aware_widget.dart';

enum FormStateStatus { idle, loading, success, error }

@JS('emailjs.send')
external JSPromise _send(String serviceId, String templateId, JSObject templateParams);

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  
  FormStateStatus _status = FormStateStatus.idle;
  String? _errorMessage;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendEmailJS() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final subject = _subjectCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    final templateParams = {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    }.jsify() as JSObject;

    await _send('service_lvq850c', 'template_ms2skan', templateParams).toDart;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    setState(() {
      _status = FormStateStatus.loading;
      _errorMessage = null;
    });

    try {
      await _sendEmailJS();

      if (!mounted) return;
      setState(() {
        _status = FormStateStatus.success;
      });

      _nameCtrl.clear();
      _emailCtrl.clear();
      _subjectCtrl.clear();
      _messageCtrl.clear();
      _formKey.currentState?.reset();

      // Reset to default after 3 seconds
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _status = FormStateStatus.idle;
          });
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = FormStateStatus.error;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobileOrTablet = width < 1025;

    return SectionWrapper(
      child: ScrollAwareWidget(
        id: 'contact',
        builder: (context, visible) {
          return isMobileOrTablet
              ? _buildMobile(context, visible)
              : _buildDesktop(context, visible);
        },
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, bool visible) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: _InfoPanel(visible: visible),
        ),
        const SizedBox(width: 64),
        Expanded(
          flex: 6,
          child: _FormPanel(
            formKey: _formKey,
            nameCtrl: _nameCtrl,
            emailCtrl: _emailCtrl,
            subjectCtrl: _subjectCtrl,
            messageCtrl: _messageCtrl,
            status: _status,
            errorMessage: _errorMessage,
            onSubmit: _submit,
            visible: visible,
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, bool visible) {
    return Column(
      children: [
        _InfoPanel(visible: visible),
        const SizedBox(height: 40),
        _FormPanel(
          formKey: _formKey,
          nameCtrl: _nameCtrl,
          emailCtrl: _emailCtrl,
          subjectCtrl: _subjectCtrl,
          messageCtrl: _messageCtrl,
          status: _status,
          errorMessage: _errorMessage,
          onSubmit: _submit,
          visible: visible,
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final bool visible;
  const _InfoPanel({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'CONTACT')
            .animate(target: visible ? 1 : 0)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 20),

        const SectionHeading(text: 'Say hello 👋')
            .animate(target: visible ? 1 : 0)
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 24),

        const Text(
          'Have a project or an opportunity? I\'d love to hear from you. '
          'Fill out the form and I\'ll get back to you as soon as possible.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.75,
          ),
        ).animate(target: visible ? 1 : 0)
            .fadeIn(duration: 600.ms, delay: 200.ms),

        const SizedBox(height: 32),

        _contactDetail(
          icon: Icons.email_outlined,
          label: 'Email',
          value: 'safymo81@gmail.com',
          visible: visible,
          delay: const Duration(milliseconds: 300),
        ),

        const SizedBox(height: 16),

        _contactDetail(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: 'Egypt 🇪🇬',
          visible: visible,
          delay: const Duration(milliseconds: 400),
        ),
      ],
    );
  }

  Widget _contactDetail({
    required IconData icon,
    required String label,
    required String value,
    required bool visible,
    required Duration delay,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.blueGlow,
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ).animate(target: visible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: delay)
        .slideX(begin: -0.1, end: 0);
  }
}

class _FormPanel extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;
  final FormStateStatus status;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final bool visible;

  const _FormPanel({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
    required this.status,
    required this.errorMessage,
    required this.onSubmit,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isSmall ? 20 : 36),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            _GlowField(
              controller: nameCtrl,
              label: 'Your Name',
              hint: 'Mostafa Mohamed',
              icon: Icons.person_outline_rounded,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ).animate(target: visible ? 1 : 0)
                .fadeIn(duration: 600.ms, delay: 150.ms)
                .slideY(begin: 0.15, end: 0),

            const SizedBox(height: 20),

            // Email Field
            _GlowField(
              controller: emailCtrl,
              label: 'Your Email Address',
              hint: 'name@example.com',
              icon: Icons.email_outlined,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ).animate(target: visible ? 1 : 0)
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.15, end: 0),

            const SizedBox(height: 20),

            // Subject Field
            _GlowField(
              controller: subjectCtrl,
              label: 'Subject',
              hint: 'Project collaboration / Opportunity...',
              icon: Icons.subject_rounded,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ).animate(target: visible ? 1 : 0)
                .fadeIn(duration: 600.ms, delay: 250.ms)
                .slideY(begin: 0.15, end: 0),

            const SizedBox(height: 20),

            // Message Field (min 10 chars)
            _GlowField(
              controller: messageCtrl,
              label: 'Message',
              hint: 'Tell me about your project...',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter a message';
                }
                if (v.trim().length < 10) {
                  return 'Message must be at least 10 characters';
                }
                return null;
              },
            ).animate(target: visible ? 1 : 0)
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideY(begin: 0.15, end: 0),

            if (errorMessage != null && status == FormStateStatus.error) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ],

            const SizedBox(height: 28),

            // Submit Button
            _SendButton(
              status: status,
              onTap: onSubmit,
            ).animate(target: visible ? 1 : 0)
                .fadeIn(duration: 600.ms, delay: 350.ms)
                .slideY(begin: 0.15, end: 0),
          ],
        ),
      ),
    )
        .animate(target: visible ? 1 : 0)
        .fadeIn(duration: 700.ms, delay: 150.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

class _GlowField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _GlowField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<_GlowField> createState() => _GlowFieldState();
}

class _GlowFieldState extends State<_GlowField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _focused ? AppTheme.blueGlow : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        validator: widget.validator,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: Icon(
            widget.icon,
            size: 18,
            color: _focused
                ? AppTheme.flutterBlueLight
                : AppTheme.textMuted,
          ),
          filled: true,
          fillColor: AppTheme.surfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: AppTheme.flutterBlueLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          labelStyle: TextStyle(
            color: _focused
                ? AppTheme.flutterBlueLight
                : AppTheme.textMuted,
            fontSize: 13,
          ),
          hintStyle: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  final FormStateStatus status;
  final VoidCallback onTap;

  const _SendButton({
    required this.status,
    required this.onTap,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.status == FormStateStatus.loading;
    final isSuccess = widget.status == FormStateStatus.success;

    Color buttonColor1 = AppTheme.flutterBlueDark;
    Color buttonColor2 = AppTheme.flutterBlueLight;

    if (isSuccess) {
      buttonColor1 = const Color(0xFF128C7E);
      buttonColor2 = const Color(0xFF25D366);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: (isLoading || isSuccess)
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (isLoading || isSuccess) ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [buttonColor1, buttonColor2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered && !isLoading ? AppTheme.blueGlow : [],
          ),
          child: Center(
            child: _buildContent(isLoading, isSuccess),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isLoading, bool isSuccess) {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.2,
        ),
      );
    }

    if (isSuccess) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Text(
            'Message Sent! 🎉',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      );
    }

    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.send_rounded, color: Colors.white, size: 18),
        SizedBox(width: 10),
        Text(
          'Send Message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

