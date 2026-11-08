import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';
import 'tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int status = 0;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return AppPage(
      title: 'HOME',
      nav: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          tooltip: 'Open menu',
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pushNamed(context, '/menu'),
          icon: const Avatar(size: 56),
        ),
      ),
      action: IconButton(
        tooltip: 'Notifications',
        onPressed: () => Navigator.pushNamed(context, '/notifications'),
        icon: const Icon(Icons.notifications_none_rounded, size: 32),
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 22, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi ${store.name.split(' ').first}!',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.2,
                          height: 1.2,
                        ),
                      ),
                      const Text(
                        'Good afternoon',
                        style: TextStyle(
                          fontSize: 36,
                          letterSpacing: -1.4,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.tint(lavender),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: IconButton(
                    tooltip: 'Search tasks',
                    padding: const EdgeInsets.all(18),
                    onPressed: () => Navigator.pushNamed(context, '/task-list'),
                    icon: const Icon(Icons.search, size: 28),
                  ),
                ),
              ],
            ),
          ),
          gap(38),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(
                    flex: i == 1 ? 14 : 10,
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
                      child: Material(
                        color: status == i
                            ? purple
                            : context.tint(i == 1 ? blush : cream),
                        borderRadius: BorderRadius.circular(22),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => setState(() => status = i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Text(
                              const ['To do', 'In Progress', 'Done'][i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: status == i ? Colors.white : muted,
                                fontSize: 16,
                                fontWeight: status == i
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          gap(38),
          SizedBox(
            height: 256,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              scrollDirection: Axis.horizontal,
              itemCount: status == 2 ? 1 : 2,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (c, i) => _HeroCard(index: i, status: status),
            ),
          ),
          gap(26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                SectionTitle(
                  'Recent Projects',
                  action: 'View All',
                  onTap: () => Navigator.pushNamed(context, '/projects'),
                ),
                for (int i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Surface(
                      padding: const EdgeInsets.all(14),
                      radius: 24,
                      onTap: () => Navigator.pushNamed(context, '/task-board'),
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 60,
                            decoration: BoxDecoration(
                              color: i == 0 ? pink : teal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              i == 0
                                  ? Icons.lightbulb_outline
                                  : Icons.layers_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  i == 0
                                      ? 'Finix User Research'
                                      : 'Finkey Website Dev.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                gap(4),
                                Text(
                                  i == 0
                                      ? '12 Dec - 8 Jan'
                                      : '11:00 AM - 2:55 AM',
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.index, required this.status});
  final int index, status;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 238,
    child: Material(
      color: index == 0 ? purple : teal,
      borderRadius: BorderRadius.circular(30),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          StoreScope.of(context).selectedTask = null;
          Navigator.pushNamed(context, '/task-details');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(0xFFFFCFB7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      index == 0 ? 'HIGH' : 'MEDIUM',
                      style: TextStyle(
                        fontSize: 11,
                        color: index == 0 ? ink : teal,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: .15),
                    child: const Icon(
                      Icons.north_east,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                status == 2
                    ? 'Fintech App ✓'
                    : index == 0
                    ? 'Fintech\nApp'
                    : 'Smart Home\nApp',
                style: const TextStyle(
                  fontSize: 31,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -.8,
                ),
              ),
              gap(15),
              Text(
                index == 0 ? '16 Dec - 18 Jan' : '15 Dec - 10 Jan',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              gap(16),
              Row(
                children: [
                  const Expanded(child: AvatarStack(count: 4)),
                  SizedBox(
                    width: 88,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: status == 2
                            ? 1
                            : status == 1
                            ? 0.65
                            : 0.42,
                        color: Colors.white,
                        backgroundColor: Colors.white24,
                        minHeight: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key, this.calendar = false});
  final bool calendar;
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late int tab = widget.calendar ? 1 : 0;
  int day = 12;
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'Project',
      nav: 1,
      action: PopupMenuButton<String>(
        onSelected: (v) => Navigator.pushNamed(context, v),
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: '/project-new',
            child: Text('Create New Project'),
          ),
          PopupMenuItem(value: '/task-board', child: Text('Tasks Board')),
        ],
      ),
      child: pageList([
        Segments(
          labels: const ['My Works', 'Calendar'],
          value: tab,
          onChanged: (i) => setState(() => tab = i),
        ),
        gap(30),
        if (tab == 0) ...[
          for (int i = 0; i < s.projects.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: ProjectCard(
                item: s.projects[i],
                color: const [pink, teal, purple][i % 3],
                onTap: () => Navigator.pushNamed(context, '/task-board'),
              ),
            ),
        ] else ...[
          Row(
            children: [
              for (int i = 10; i < 15; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Surface(
                      radius: 22,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      color: day == i ? purple : null,
                      onTap: () => setState(() => day = i),
                      child: Column(
                        children: [
                          Text(
                            '$i',
                            style: TextStyle(
                              color: day == i
                                  ? Colors.white
                                  : context.foreground,
                            ),
                          ),
                          gap(4),
                          Text(
                            const ['Sat', 'Sun', 'Mon', 'Tue', 'Wed'][i - 10],
                            style: TextStyle(
                              color: day == i
                                  ? Colors.white
                                  : context.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          gap(34),
          const Text(
            'Hey Alex',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
            ),
          ),
          gap(8),
          Text(
            '${day == 12 ? 12 : day - 8} Tasks for today ${const ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday'][day - 10]}',
            style: const TextStyle(color: muted, fontSize: 14),
          ),
          gap(28),
          for (int i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      const [
                        '9:00\nAM',
                        '10:20\nAM',
                        '11:30\nAM',
                        '1:30\nPM',
                      ][i],
                      style: const TextStyle(color: muted, fontSize: 14),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const [pink, Color(0xFFFFD58D), purple, teal][i],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Surface(
                      color: context.tint(
                        const [blush, cream, lavender, Color(0xFFCDF7FF)][i],
                      ),
                      radius: 20,
                      padding: const EdgeInsets.all(18),
                      onTap: () =>
                          Navigator.pushNamed(context, '/task-details'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            const [
                              'Daily Work',
                              'New UI Kit for the app',
                              'Lunch Break',
                              'Call With Client',
                            ][i],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          gap(10),
                          Text(
                            const [
                              'To discuss with team all work processes for the day.',
                              'To collect all assets that continues a set of design elements such as components.',
                              '12:25 - 1:25 AM',
                              'Discuss the next milestone',
                            ][i],
                            style: const TextStyle(color: muted, fontSize: 13),
                          ),
                          gap(8),
                          if (i < 2)
                            Text(
                              i == 0 ? '9:00 - 10:20 AM' : '10:20 - 12:35 AM',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ]),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.item,
    required this.color,
    required this.onTap,
  });
  final WorkItem item;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Surface(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status == 'Paused'
                      ? 'Project is paused'
                      : 'Project in progress',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (v) {
                if (v == 'tasks') {
                  onTap();
                } else {
                  item.status = item.status == 'Paused' ? 'Ongoing' : 'Paused';
                  StoreScope.of(context).save();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'tasks', child: Text('View tasks')),
                PopupMenuItem(value: 'pause', child: Text('Pause / Resume')),
              ],
            ),
          ],
        ),
        gap(12),
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 20,
            height: 1.35,
            fontWeight: FontWeight.w600,
            letterSpacing: -.5,
          ),
        ),
        gap(18),
        label('Progress'),
        Row(
          children: [
            Expanded(child: ProgressLine(item.progress, color: color)),
            const SizedBox(width: 22),
            Text(
              '${(item.progress * 100).round()}%',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        gap(20),
        Row(
          children: [
            const AvatarStack(),
            const Spacer(),
            Flexible(
              flex: 4,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: const [
                    Icon(Icons.chat_bubble_outline, size: 16),
                    Text(' 2   ', style: TextStyle(fontSize: 13)),
                    Icon(Icons.note_add_outlined, size: 18),
                    Text(' 5   ', style: TextStyle(fontSize: 13)),
                    Icon(Icons.schedule, size: 18),
                    Text(' 7 days', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});
  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController(), description = TextEditingController();
  int priority = 1;
  DateTime? start, end;
  TimeOfDay? from, to;
  List<String> members = ['Alex Smith', 'HR Rumen'];
  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> pickDate(bool first) async {
    final d = await showAppDatePicker(context, initial: first ? start : end);
    if (d != null && mounted) {
      setState(() {
        if (first) {
          start = d;
        } else {
          end = d;
        }
      });
    }
  }

  Future<void> pickTime(bool first) async {
    final d = await showAppTimePicker(context, initial: first ? from : to);
    if (d != null && mounted) {
      setState(() {
        if (first) {
          from = d;
        } else {
          to = d;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Create New Project',
    bottom: FilledButton(
      onPressed: () async {
        if (!form.currentState!.validate()) {
          return;
        }
        if (start != null && end != null && end!.isBefore(start!)) {
          toast(context, 'End date must follow the start date');
          return;
        }
        final s = StoreScope.of(context);
        s.projects.insert(
          0,
          WorkItem(
            title: title.text.trim(),
            description: description.text.trim(),
            priority: const ['Low', 'Medium', 'High'][priority],
            members: List.of(members),
            date: start == null
                ? 'Not scheduled'
                : '${shortDate(start!)} - ${shortDate(end ?? start!)}',
            hours: from == null
                ? '08 Hours'
                : '${from!.format(context)} - ${(to ?? from!).format(context)}',
          ),
        );
        await s.save();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/projects', (_) => false);
        }
      },
      child: const Text('Create Project'),
    ),
    child: Form(
      key: form,
      child: pageList([
        const SectionTitle('Project Name'),
        TextFormField(
          key: const Key('project-name'),
          controller: title,
          decoration: const InputDecoration(hintText: 'Enter Project Name'),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a project name' : null,
        ),
        gap(),
        const SectionTitle('Description'),
        TextFormField(
          controller: description,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write Description Type Here...',
          ),
        ),
        gap(),
        const SectionTitle('Project Date'),
        Row(
          children: [
            Expanded(
              child: _PickerButton(
                start == null ? 'DD-MM-YY' : shortDate(start!),
                Icons.calendar_month_outlined,
                () => pickDate(true),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12), child: Text('To')),
            Expanded(
              child: _PickerButton(
                end == null ? 'DD-MM-YY' : shortDate(end!),
                Icons.calendar_month_outlined,
                () => pickDate(false),
              ),
            ),
          ],
        ),
        gap(),
        const SectionTitle('Project Time'),
        Row(
          children: [
            Expanded(
              child: _PickerButton(
                from?.format(context) ?? 'HH-MM',
                Icons.schedule,
                () => pickTime(true),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12), child: Text('To')),
            Expanded(
              child: _PickerButton(
                to?.format(context) ?? 'HH-MM',
                Icons.schedule,
                () => pickTime(false),
              ),
            ),
          ],
        ),
        gap(),
        const SectionTitle('Priority'),
        Segments(
          labels: const ['Low', 'Medium', 'High'],
          value: priority,
          onChanged: (i) => setState(() => priority = i),
        ),
        gap(),
        SectionTitle(
          'Invite Member',
          action: '⊕',
          onTap: () async {
            final r = await Navigator.pushNamed(
              context,
              '/assignees',
              arguments: members,
            );
            if (r is List<String>) {
              setState(() => members = r);
            }
          },
        ),
        Wrap(
          spacing: 10,
          children: members
              .map(
                (m) => InputChip(
                  label: Text(m),
                  backgroundColor: context.tint(blush),
                  onDeleted: () => setState(() => members.remove(m)),
                ),
              )
              .toList(),
        ),
      ]),
    ),
  );
}

class _PickerButton extends StatelessWidget {
  const _PickerButton(this.text, this.icon, this.onTap);
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Surface(
    radius: 20,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, size: 19),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}
