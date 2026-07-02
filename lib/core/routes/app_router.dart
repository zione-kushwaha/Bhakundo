import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/booking/presentation/pages/court_detail_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/matchmaking/presentation/pages/matchmaking_page.dart';
import '../../features/team_management/presentation/pages/team_management_page.dart';

// Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    // Navigate to Login/Dashboard after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withValues(alpha: 0.05),
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/app/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.sports_soccer, size: 60, color: theme.primaryColor);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'BHAKUNDO',
                style: theme.textTheme.displayMedium?.copyWith(
                  letterSpacing: 2.0,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Futsal. Roster. Matchmaking.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  letterSpacing: 0.5,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DashboardPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/booking',
            builder: (context, state) => const BookingPage(),
          ),
          GoRoute(
            path: '/matchmaking',
            builder: (context, state) => const MatchmakingPage(),
          ),
          GoRoute(
            path: '/team',
            builder: (context, state) => const TeamManagementPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Profile Screen (Coming Soon)')),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/court-detail/:courtId',
        builder: (context, state) {
          final courtId = state.pathParameters['courtId'] ?? '';
          return CourtDetailPage(courtId: courtId);
        },
      ),
    ],
  );
}
