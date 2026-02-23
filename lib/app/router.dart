import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/features/auth/screens/login_screen.dart';
import 'package:code_mentor/features/auth/screens/signup_screen.dart';
import 'package:code_mentor/features/auth/screens/onboarding_screen.dart';
import 'package:code_mentor/features/home/screens/home_screen.dart';
import 'package:code_mentor/features/catalog/screens/catalog_screen.dart';
import 'package:code_mentor/features/catalog/screens/track_detail_screen.dart';
import 'package:code_mentor/features/catalog/screens/module_detail_screen.dart';
import 'package:code_mentor/features/catalog/screens/lesson_screen.dart';
import 'package:code_mentor/features/practice/screens/practice_screen.dart';
import 'package:code_mentor/features/quiz/screens/quiz_screen.dart';
import 'package:code_mentor/features/progress/screens/progress_screen.dart';
import 'package:code_mentor/features/profile/screens/profile_screen.dart';
import 'package:code_mentor/features/premium/screens/premium_screen.dart';
import 'package:code_mentor/features/admin/screens/admin_screen.dart';

// Bottom navigation destinations for the shell.
final _shellDestinations = [
  const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home'),
  const NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'Catalog'),
  const NavigationDestination(
      icon: Icon(Icons.bar_chart_outlined),
      selectedIcon: Icon(Icons.bar_chart),
      label: 'Progress'),
  const NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile'),
];

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: _shellDestinations,
      ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated =
      ValueNotifier<bool>(ref.read(isAuthenticatedProvider));

  ref.listen(isAuthenticatedProvider, (_, next) {
    isAuthenticated.value = next;
  });

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: isAuthenticated,
    redirect: (context, state) {
      final authenticated = isAuthenticated.value;
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      final onboarding =
          state.matchedLocation == '/onboarding';

      if (!authenticated && !loggingIn && !onboarding) {
        return '/login';
      }
      if (authenticated && loggingIn) return '/';
      return null;
    },
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),

      // Detail routes (outside shell – full-screen)
      GoRoute(
        path: '/track/:trackId',
        builder: (_, state) => TrackDetailScreen(
            trackId: state.pathParameters['trackId']!),
      ),
      GoRoute(
        path: '/module/:moduleId',
        builder: (_, state) => ModuleDetailScreen(
            moduleId: state.pathParameters['moduleId']!),
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (_, state) => LessonScreen(
            lessonId: state.pathParameters['lessonId']!),
      ),
      GoRoute(
        path: '/practice/:lessonId',
        builder: (_, state) => PracticeScreen(
            lessonId: state.pathParameters['lessonId']!),
      ),
      GoRoute(
        path: '/quiz/:moduleId',
        builder: (_, state) => QuizScreen(
            moduleId: state.pathParameters['moduleId']!),
      ),
      GoRoute(
        path: '/premium',
        builder: (_, __) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/admin',
        redirect: (context, state) {
          // Admin check is done inside the screen; router just
          // forwards. If needed, ref.read(isAdminProvider) can guard
          // here, but since ref is captured above, keep it simple.
          return null;
        },
        builder: (_, __) => const AdminScreen(),
      ),

      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/catalog',
              builder: (_, __) => const CatalogScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/progress',
              builder: (_, __) => const ProgressScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
