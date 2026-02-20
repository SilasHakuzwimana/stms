import 'package:flutter/material.dart';
import 'package:stms_app/app_theme.dart';

// ── Forgot Password Screen ────────────────────────────────────────────────────
// Three-step flow:
//   Step 1 — Enter email → request reset code
//   Step 2 — Enter 6-digit OTP
//   Step 3 — Enter new password + confirm

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  int _step = 1; // 1 = email, 2 = OTP, 3 = new password

  // Controllers
  final _emailCtrl = TextEditingController();
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpFocuses = List.generate(6, (_) => FocusNode());
  final _newPassCtrl = TextEditingController();
  final _confPassCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  int _resendSeconds = 0;

  // Animation
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _otpFocuses) f.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Step transitions ──────────────────────────────────────────────────────
  void _goToStep(int step) {
    _animCtrl.reverse().then((_) {
      setState(() => _step = step);
      _animCtrl.forward();
    });
  }

  // ── Step 1: send reset code ────────────────────────────────────────────────
  void _sendCode() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _resendSeconds = 60;
      });
      _startResendTimer();
      _goToStep(2);
    });
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendSeconds--);
      return _resendSeconds > 0;
    });
  }

  void _resendCode() {
    if (_resendSeconds > 0) return;
    setState(() {
      _resendSeconds = 60;
      for (final c in _otpCtrls) c.clear();
    });
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('New code sent'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Step 2: verify OTP ─────────────────────────────────────────────────────
  void _verifyOtp() {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter the full 6-digit code'),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _goToStep(3);
    });
  }

  // ── Step 3: reset password ─────────────────────────────────────────────────
  void _resetPassword() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password reset successfully'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    });
  }

  // ── Password strength ──────────────────────────────────────────────────────
  double _strength(String p) {
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (p.length >= 12) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.2;
    if (p.contains(RegExp(r'[0-9]'))) s += 0.15;
    if (p.contains(RegExp(r'[^A-Za-z0-9]'))) s += 0.15;
    return s.clamp(0, 1);
  }

  Color _strengthColor(double s) {
    if (s < 0.4) return AppColors.red;
    if (s < 0.7) return AppColors.gold;
    return AppColors.green;
  }

  String _strengthLabel(double s) {
    if (s == 0) return '';
    if (s < 0.4) return 'Weak';
    if (s < 0.7) return 'Fair';
    if (s < 0.9) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(showBack: true),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Progress stepper ───────────────────────────────────
                  _StepProgress(current: _step, total: 3),
                  const SizedBox(height: 32),

                  // ── Step content ───────────────────────────────────────
                  if (_step == 1) _buildEmailStep(),
                  if (_step == 2) _buildOtpStep(),
                  if (_step == 3) _buildNewPasswordStep(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // STEP 1 — Email
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepIcon(icon: Icons.mark_email_unread_rounded, color: AppColors.gold),
        const SizedBox(height: 20),
        const SectionLabel('FORGOT PASSWORD'),
        const SizedBox(height: 8),
        const Text(
          'Reset your\npassword',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Enter the email address linked to your account. We'll send you a reset code.",
          style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 32),
        _Card(
          child: AppTextField(
            controller: _emailCtrl,
            label: 'Email address',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          label: 'Send Reset Code',
          isLoading: _isLoading,
          onTap: _sendCode,
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RichText(
              text: const TextSpan(
                text: 'Remembered it?  ',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // STEP 2 — OTP
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepIcon(icon: Icons.key_rounded, color: AppColors.blue),
        const SizedBox(height: 20),
        const SectionLabel('VERIFICATION'),
        const SizedBox(height: 8),
        const Text(
          'Enter the\nreset code',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: 'A 6-digit code was sent to  ',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              height: 1.6,
            ),
            children: [
              TextSpan(
                text: _emailCtrl.text,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (i) => _OtpBox(
              controller: _otpCtrls[i],
              focusNode: _otpFocuses[i],
              onChanged: (val) {
                if (val.isNotEmpty && i < 5) {
                  _otpFocuses[i + 1].requestFocus();
                } else if (val.isEmpty && i > 0) {
                  _otpFocuses[i - 1].requestFocus();
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Resend row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _goToStep(1),
              child: const Text(
                '← Wrong email?',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ),
            GestureDetector(
              onTap: _resendCode,
              child: Text(
                _resendSeconds > 0
                    ? 'Resend in ${_resendSeconds}s'
                    : 'Resend code',
                style: TextStyle(
                  color: _resendSeconds > 0 ? AppColors.muted : AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),
        AppButton(
          label: 'Verify Code',
          isLoading: _isLoading,
          onTap: _verifyOtp,
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // STEP 3 — New password
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildNewPasswordStep() {
    final pass = _newPassCtrl.text;
    final strength = _strength(pass);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepIcon(icon: Icons.lock_reset_rounded, color: AppColors.green),
        const SizedBox(height: 20),
        const SectionLabel('NEW PASSWORD'),
        const SizedBox(height: 8),
        const Text(
          'Create a new\npassword',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Make it strong — at least 8 characters with a mix of letters, numbers, and symbols.',
          style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 32),
        _Card(
          child: Column(
            children: [
              StatefulBuilder(
                builder:
                    (_, setInner) => AppTextField(
                      controller: _newPassCtrl,
                      label: 'New password',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscureNew,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Password is required';
                        if (v.length < 8)
                          return 'Must be at least 8 characters';
                        return null;
                      },
                      suffixWidget: IconButton(
                        icon: Icon(
                          _obscureNew
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.muted,
                          size: 18,
                        ),
                        onPressed:
                            () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
              ),

              // Strength bar
              if (pass.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: strength,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation(
                            _strengthColor(strength),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _strengthLabel(strength),
                      style: TextStyle(
                        color: _strengthColor(strength),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),
              AppTextField(
                controller: _confPassCtrl,
                label: 'Confirm new password',
                icon: Icons.lock_outline_rounded,
                obscure: _obscureConfirm,
                validator: (v) {
                  if (v != _newPassCtrl.text) return 'Passwords do not match';
                  return null;
                },
                suffixWidget: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.muted,
                    size: 18,
                  ),
                  onPressed:
                      () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Requirements checklist
        _PasswordRules(password: _newPassCtrl.text),
        const SizedBox(height: 24),

        AppButton(
          label: 'Reset Password',
          isLoading: _isLoading,
          onTap: _resetPassword,
        ),
      ],
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _StepProgress extends StatelessWidget {
  final int current;
  final int total;
  const _StepProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(total, (i) {
            final done = i + 1 < current;
            final active = i + 1 == current;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color:
                      done
                          ? AppColors.gold
                          : active
                          ? AppColors.gold
                          : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Step $current of $total',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _StepIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.card,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _PasswordRules extends StatelessWidget {
  final String password;
  const _PasswordRules({required this.password});

  @override
  Widget build(BuildContext context) {
    final rules = [
      ('At least 8 characters', password.length >= 8),
      ('Contains uppercase letter', password.contains(RegExp(r'[A-Z]'))),
      ('Contains a number', password.contains(RegExp(r'[0-9]'))),
      ('Contains a symbol', password.contains(RegExp(r'[^A-Za-z0-9]'))),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('PASSWORD REQUIREMENTS'),
          const SizedBox(height: 10),
          ...rules.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    r.$2
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 14,
                    color: r.$2 ? AppColors.green : AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    r.$1,
                    style: TextStyle(
                      color: r.$2 ? AppColors.text : AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
