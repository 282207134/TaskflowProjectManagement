import 'package:flutter/material.dart';

import 'core/store.dart';
import 'core/theme.dart';
import 'features/auth.dart';
import 'features/workspace.dart';
import 'features/tasks.dart';
import 'features/communication.dart';
import 'features/analytics.dart';
import 'features/profile.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class TaskflowApp extends StatelessWidget {
  const TaskflowApp({super.key, required this.store, this.initialRoute = '/'});
  final AppStore store;
  final String initialRoute;
  @override
  Widget build(BuildContext context) => StoreScope(
    store: store,
    child: ListenableBuilder(
      listenable: store,
      builder: (ctx, _) => MaterialApp(
        title: 'Taskflow',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: appTheme(false),
        darkTheme: appTheme(true),
        themeMode: store.dark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: initialRoute,
        onGenerateRoute: (settings) {
          final page = switch (settings.name) {
            '/' => SplashPage(auto: initialRoute == '/'),
            '/splash' => const SplashPage(auto: false),
            '/onboarding' => const OnboardingPage(),
            '/onboarding-2' => const OnboardingPage(second: true),
            '/login' => const AuthPage(),
            '/login-filled' => const AuthPage(filled: true),
            '/signup' => const AuthPage(signup: true),
            '/signup-filled' => const AuthPage(signup: true, filled: true),
            '/forgot' => const RecoveryPage(),
            '/verification' => const RecoveryPage(verify: true),
            '/verification-filled' => const RecoveryPage(
              verify: true,
              filled: true,
            ),
            '/check-email' => const SetupPage(kind: 'email'),
            '/language' => const SetupPage(kind: 'language'),
            '/phone' => const SetupPage(kind: 'phone'),
            '/permissions' => const SetupPage(kind: 'permissions'),
            '/home' => const HomePage(),
            '/projects' => const ProjectsPage(),
            '/calendar' => const ProjectsPage(calendar: true),
            '/project-new' => const ProjectFormPage(),
            '/task-board' => const TasksPage(),
            '/task-list' => const TasksPage(list: true),
            '/task-details' => const TaskDetailsPage(),
            '/date' => const TaskDetailsPage(overlay: 'date'),
            '/time' => const TaskDetailsPage(overlay: 'time'),
            '/task-new' => const TaskFormPage(),
            '/task-edit' => const TaskFormPage(edit: true),
            '/assignees' => AssigneesPage(
              initial:
                  (settings.arguments as List<String>?) ??
                  const ['Alex Smith', 'HR Rumen'],
            ),
            '/messages' => const MessagesPage(),
            '/chat' => ChatPage(
              name: (settings.arguments as String?) ?? 'Michael Morgan',
            ),
            '/video' => const VideoPage(),
            '/notifications' => const NotificationsPage(),
            '/analytics' => const AnalyticsPage(),
            '/monthly' => const AnalyticsPage(monthly: true),
            '/profile' => const ProfilePage(),
            '/profile-edit' => const ProfilePage(edit: true),
            '/menu' => const MenuPage(),
            '/logout' => const MenuPage(logout: true),
            '/settings' => const SettingsPage(),
            '/widgets' => const WidgetsPage(),
            '/privacy' => const InfoPage(privacy: true),
            _ => const InfoPage(),
          };
          return MaterialPageRoute<Object?>(
            settings: settings,
            builder: (_) => page,
          );
        },
        builder: (ctx, child) => ColoredBox(
          color: ctx.isDark ? const Color(0xFF030D1D) : const Color(0xFFF2F5FA),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: child!,
            ),
          ),
        ),
      ),
    ),
  );
}
