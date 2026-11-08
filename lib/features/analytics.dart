import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';
import 'tasks.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key, this.monthly = false});
  final bool monthly;
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: monthly ? 'Monthly Review' : 'Analytics',
      nav: 4,
      action: IconButton(
        tooltip: 'Notifications',
        onPressed: () => Navigator.pushNamed(context, '/notifications'),
        icon: const Icon(Icons.notifications_none_rounded),
      ),
      child: pageList([
        gap(8),
        Text(
          monthly ? 'Monthly Review' : 'Project Summary',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -.7,
          ),
        ),
        if (!monthly) ...[
          gap(8),
          const Text(
            'Let’s Finish Your Project For Today!',
            style: TextStyle(color: muted, fontSize: 14),
          ),
        ],
        gap(28),
        Row(
          children: [
            for (int i = 0; i < (monthly ? 3 : 2); i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i == (monthly ? 2 : 1) ? 0 : 14,
                  ),
                  child: Surface(
                    color: const [purple, teal, pink][i],
                    padding: const EdgeInsets.all(18),
                    onTap: () => Navigator.pushNamed(
                      context,
                      monthly ? '/task-list' : '/monthly',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!monthly)
                              const Icon(
                                Icons.assignment_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                        gap(monthly ? 12 : 38),
                        Text(
                          monthly
                              ? const ['10', '8', '12'][i]
                              : const ['16', '24'][i],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        gap(4),
                        Text(
                          monthly
                              ? const ['To Do', 'Ongoing', 'On Review'][i]
                              : const [
                                  'In Progress Project',
                                  'Project Completed',
                                ][i],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        gap(30),
        if (monthly) ...[
          SectionTitle(
            'Priority Task',
            action: 'See All',
            onTap: () => Navigator.pushNamed(context, '/task-list'),
          ),
          for (int i = 0; i < s.tasks.length; i++)
            TaskRow(item: s.tasks[i], index: i),
        ] else ...[
          SectionTitle(
            'Project Statistics',
            action: 'Monthly',
            onTap: () => Navigator.pushNamed(context, '/monthly'),
          ),
          const SizedBox(height: 224, child: StatisticsChart()),
          gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 3; i++)
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: const [purple, teal, pink][i],
                      size: 10,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      const ['On-Target', 'Task-Target', 'Off-Target'][i],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
            ],
          ),
          gap(30),
          Surface(
            color: context.tint(cream),
            padding: const EdgeInsets.all(16),
            radius: 20,
            child: Row(
              children: [
                Expanded(
                  child: _Metric('Total Working Hour', '24:53:08', '↑ 32%'),
                ),
                Container(width: 1, height: 56, color: context.line),
                const SizedBox(width: 16),
                Expanded(
                  child: _Metric(
                    'Total Task Activity',
                    '${130 + s.tasks.length - 4} Task',
                    '↑ 24%',
                  ),
                ),
              ],
            ),
          ),
          gap(20),
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/monthly'),
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('View Monthly Review'),
          ),
        ],
      ]),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, this.change);
  final String label, value, change;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: muted)),
      gap(10),
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      gap(6),
      Text(change, style: const TextStyle(fontSize: 11, color: teal)),
    ],
  );
}

class StatisticsChart extends StatelessWidget {
  const StatisticsChart({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Weekly project activity: 24, 30, 16, 26, 16, 22, 16 tasks.',
    child: LayoutBuilder(
      builder: (ctx, box) {
        final height = (box.maxHeight - 78).clamp(70.0, 170.0);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 7; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (i == 4)
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: context.tint(lavender),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '● 30 Tasks',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  gap(8),
                  SizedBox(
                    height: height,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 14,
                        height:
                            height *
                            const [.8, 1.0, .52, .86, .52, .74, .52][i],
                        decoration: BoxDecoration(
                          color: purple,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: .65,
                            widthFactor: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: i == 1 || i == 3 ? teal : pink,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  gap(12),
                  Text(
                    const ['S', 'M', 'T', 'W', 'T', 'F', 'S'][i],
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                ],
              ),
          ],
        );
      },
    ),
  );
}

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'App Widgets',
      child: pageList([
        const SectionTitle('Your day, at a glance'),
        const Text(
          'Quick views inspired by the Pixso widget collection.',
          style: TextStyle(color: muted, fontSize: 14),
        ),
        gap(24),
        Surface(
          color: context.tint(lavender),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Hours worked'),
              const Text('Today', style: TextStyle(color: muted)),
              const SizedBox(height: 200, child: StatisticsChart()),
            ],
          ),
        ),
        gap(18),
        Surface(
          onTap: () => Navigator.pushNamed(context, '/task-new'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Add Task', action: '＋'),
              const Text(
                'Recent task',
                style: TextStyle(color: muted, fontSize: 13),
              ),
              gap(12),
              for (final t in s.tasks.take(2))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.task_alt, color: purple),
                  title: Text(t.title, style: const TextStyle(fontSize: 14)),
                ),
            ],
          ),
        ),
        gap(18),
        Surface(
          onTap: () => Navigator.pushNamed(context, '/calendar'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Today’s Projects'),
              for (final p in s.projects.take(2))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.folder_outlined, color: teal),
                  title: Text(p.title, style: const TextStyle(fontSize: 14)),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
