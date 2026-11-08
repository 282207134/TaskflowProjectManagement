import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/app.dart';
import 'package:taskflow/core/store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Local data and appearance survive a store reload', () async {
    final store = await AppStore.load();
    store.projects.add(WorkItem(title: 'Persisted project', priority: 'High'));
    store.messages.add('Hello team');
    store.dark = true;
    await store.save();
    final reloaded = await AppStore.load();
    expect(reloaded.projects.last.title, 'Persisted project');
    expect(reloaded.messages.single, 'Hello team');
    expect(reloaded.dark, isTrue);
    expect(
      reloaded.preferences.getString('taskflow.v1'),
      isNot(contains('password')),
    );
  });
  test('Task completion and dates remain isolated and persist', () async {
    final store = await AppStore.load();
    store.selectedTask = store.tasks.first;
    store.completed.add('Create Design System');
    store.dueDate = DateTime(2026, 11, 20);
    await store.save();
    store.selectedTask = store.tasks[1];
    expect(store.completed, isEmpty);
    expect(store.dueDate, DateTime(2023, 7, 14));
    final restored = await AppStore.load();
    expect(restored.tasks.first.completed, contains('Create Design System'));
    expect(restored.tasks.first.dueDate, DateTime(2026, 11, 20));
  });
  testWidgets('Project form validates, creates and displays a project', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(428, 926);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = await AppStore.load();
    await tester.pumpWidget(
      TaskflowApp(store: store, initialRoute: '/project-new'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Project'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a project name'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('project-name')),
      'Mobile release',
    );
    await tester.tap(find.text('Create Project'));
    await tester.pumpAndSettle();
    expect(store.projects.first.title, 'Mobile release');
    expect(find.text('Mobile release'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
