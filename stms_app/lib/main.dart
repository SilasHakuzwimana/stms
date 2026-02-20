import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stms_app/screens/login_screen.dart';
import 'package:stms_app/screens/register_screen.dart';
import 'package:stms_app/screens/dashboard_screen.dart';
import 'package:stms_app/screens/forgot_password_screen.dart';
import 'package:stms_app/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.bg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const StmsApp());
}

class StmsApp extends StatelessWidget {
  const StmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}

// ── Home / Landing Screen ─────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      // ── KEY FIX: SingleChildScrollView prevents overflow on small screens ──
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                // Ensure content fills at least the full viewport height
                // so the layout feels like a true landing screen on tall phones
                // while scrolling gracefully on short ones.
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),

                      // ── Brand mark ────────────────────────────────────────
                      const _BrandMark(),

                      // Flexible gap — shrinks on short screens
                      const Spacer(),

                      // ── Hero text ─────────────────────────────────────────
                      const SectionLabel('STUDENT TASK MANAGEMENT'),
                      const SizedBox(height: 12),
                      const Text(
                        'Stay on top of\nevery deadline.',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Organise assignments, track progress, and '
                        'never miss a submission — all in one place.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Feature pills ─────────────────────────────────────
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FeaturePill(Icons.task_alt_rounded, 'Task Tracking'),
                          _FeaturePill(Icons.schedule_rounded, 'Deadlines'),
                          _FeaturePill(Icons.school_rounded, 'Multi-course'),
                          _FeaturePill(Icons.bar_chart_rounded, 'Progress'),
                        ],
                      ),

                      const Spacer(),

                      // ── CTA buttons ───────────────────────────────────────
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Sign In',
                        onTap: () => Navigator.pushNamed(context, '/login'),
                      ),
                      const SizedBox(height: 12),
                      _OutlineButton(
                        label: 'Create Account',
                        onTap: () => Navigator.pushNamed(context, '/register'),
                      ),

                      const SizedBox(height: 28),

                      // ── Footer ────────────────────────────────────────────
                      Center(
                        child: Text(
                          'STMS v1.0  ·  Academic Edition',
                          style: TextStyle(
                            color: AppColors.muted.withOpacity(0.5),
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Brand mark ────────────────────────────────────────────────────────────────
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(Icons.bolt_rounded, color: AppColors.bg, size: 26),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'iSTMS',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 3.5,
              ),
            ),
            Text(
              'STMS Platform',
              style: TextStyle(
                color: AppColors.muted.withOpacity(0.8),
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gold.withOpacity(0.3)),
          ),
          child: const Text(
            'v1.0',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Feature pill ──────────────────────────────────────────────────────────────
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Outline button ────────────────────────────────────────────────────────────
class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _OutlineButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
