import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:taskflow/app.dart';
import 'package:taskflow/core/store.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('All Pixso screens, both themes, and core interactions', (
    tester,
  ) async {
    final prefsStore = await AppStore.load();
    await prefsStore.preferences.clear();
    final store = await AppStore.load();
    final captureKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: TaskflowApp(store: store, initialRoute: '/home'),
      ),
    );
    await tester.pumpAndSettle();
    binding.reportData = {'screenshots': <Map<String, dynamic>>[]};
    Future<void> capture(String name) async {
      await tester.pump(const Duration(milliseconds: 150));
      final boundary =
          captureKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final frame = await boundary.toImage(pixelRatio: 2);
      final png = await frame.toByteData(format: ui.ImageByteFormat.png);
      frame.dispose();
      (binding.reportData!['screenshots'] as List).add({
        'screenshotName': name,
        'bytes': png!.buffer.asUint8List().toList(),
      });
    }

    Future<void> go(String route) async {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: route);
    }

    const routes = [
      'splash',
      'onboarding',
      'onboarding-2',
      'login',
      'login-filled',
      'signup',
      'signup-filled',
      'forgot',
      'verification',
      'verification-filled',
      'check-email',
      'language',
      'phone',
      'permissions',
      'home',
      'notifications',
      'projects',
      'calendar',
      'project-new',
      'task-board',
      'task-list',
      'task-details',
      'date',
      'time',
      'task-new',
      'task-edit',
      'assignees',
      'messages',
      'chat',
      'video',
      'analytics',
      'monthly',
      'profile',
      'profile-edit',
      'menu',
      'logout',
      'settings',
      'widgets',
      'privacy',
      'help',
    ];
    for (final dark in [false, true]) {
      store.setDark(dark);
      await tester.pumpAndSettle();
      for (final route in routes) {
        debugPrint('Capturing ${dark ? 'dark' : 'light'}/$route');
        await go('/$route');
        await capture('${dark ? 'dark' : 'light'}/$route');
      }
    }
    store.setDark(false);
    await go('/login-filled');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(store.signedIn, isTrue);
    await go('/project-new');
    await tester.enterText(
      find.byKey(const Key('project-name')),
      'Release planning',
    );
    await tester.tap(find.text('Create Project'));
    await tester.pumpAndSettle();
    expect(store.projects.first.title, 'Release planning');
    expect(find.text('Release planning'), findsOneWidget);
    await go('/task-new');
    await tester.enterText(
      find.byKey(const Key('task-name')),
      'Review mobile screens',
    );
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();
    expect(store.tasks.first.title, 'Review mobile screens');
    await tester.tap(find.text('Review mobile screens'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Design System'));
    await tester.pumpAndSettle();
    expect(store.completed.contains('Create Design System'), isTrue);
    await tester.tap(find.text('Edit Task').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('task-name')),
      'Review mobile screens - done',
    );
    await tester.tap(find.text('Save Task'));
    await tester.pumpAndSettle();
    expect(store.tasks.first.title, 'Review mobile screens - done');
    await go('/chat');
    await tester.enterText(
      find.byKey(const Key('message-input')),
      'Screens look great.',
    );
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(store.messages.last, 'Screens look great.');
    final reloaded = await AppStore.load();
    expect(reloaded.tasks.first.title, 'Review mobile screens - done');
    expect(reloaded.projects.first.title, 'Release planning');
    expect(reloaded.messages.last, 'Screens look great.');
    await go('/logout');
    await tester.tap(find.text('Log Out').last);
    await tester.pumpAndSettle();
    expect(find.text('Hello Again!'), findsOneWidget);
    expect(store.signedIn, isFalse);
    // Leave the preview with the clean reference dataset, without test entries.
    await store.preferences.clear();
    await tester.pumpWidget(
      TaskflowApp(store: await AppStore.load(), initialRoute: '/home'),
    );
    await go('/home');
  });
}
