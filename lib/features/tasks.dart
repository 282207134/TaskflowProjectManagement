import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';
import 'workspace.dart';

String shortDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year.toString().substring(2)}';

Future<DateTime?> showAppDatePicker(BuildContext context, {DateTime? initial}) {
  var selected = initial ?? StoreScope.of(context).dueDate;
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                const Text(
                  'Select Date',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, DateTime.now()),
                  child: const Text('Today'),
                ),
              ],
            ),
            CalendarDatePicker(
              initialDate: selected,
              firstDate: DateTime(2020),
              lastDate: DateTime(2040),
              onDateChanged: (v) => selected = v,
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: const Text('Select Date'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<TimeOfDay?> showAppTimePicker(
  BuildContext context, {
  TimeOfDay? initial,
}) {
  var selected = initial ?? StoreScope.of(context).dueTime;
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 220,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: context.isDark
                      ? Brightness.dark
                      : Brightness.light,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    2023,
                    2,
                    14,
                    selected.hour,
                    selected.minute,
                  ),
                  onDateTimeChanged: (v) =>
                      selected = TimeOfDay.fromDateTime(v),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    ),
  );
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, this.list = false});
  final bool list;
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late int tab = widget.list ? 1 : 0;
  bool searching = false;
  String query = '';
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    final tasks = s.tasks
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return AppPage(
      title: tab == 0 ? 'Tasks Board' : 'Task List',
      action: IconButton(
        tooltip: 'Search',
        onPressed: () => setState(() => searching = !searching),
        icon: const Icon(Icons.search, size: 28),
      ),
      child: pageList([
        Segments(
          labels: const ['Board', 'List'],
          value: tab,
          onChanged: (i) => setState(() => tab = i),
        ),
        gap(24),
        if (searching) ...[
          SearchBox(onChanged: (v) => setState(() => query = v)),
          gap(),
        ],
        if (tab == 0) ...[
          for (int i = 0; i < tasks.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: ProjectCard(
                item: tasks[i],
                color: const [teal, pink, purple][i % 3],
                onTap: () {
                  s.selectedTask = tasks[i];
                  Navigator.pushNamed(context, '/task-details');
                },
              ),
            ),
        ] else ...[
          for (final status in ['In Progress', 'Completed']) ...[
            Row(
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: context.tint(lavender),
                  child: Text(
                    '${status == 'In Progress' ? tasks.where((e) => e.status != 'Completed').length : tasks.where((e) => e.status == 'Completed').length}',
                    style: TextStyle(fontSize: 13, color: context.foreground),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Add task',
                  onPressed: () => Navigator.pushNamed(context, '/task-new'),
                  icon: const Icon(Icons.add_circle_outline, color: purple),
                ),
              ],
            ),
            gap(16),
            for (final item in tasks.where(
              (e) => status == 'In Progress'
                  ? e.status != 'Completed'
                  : e.status == 'Completed',
            ))
              TaskRow(item: item, index: s.tasks.indexOf(item), avatars: true),
            gap(12),
          ],
        ],
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Text('No tasks found. Try another search.'),
          ),
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/task-new'),
          icon: const Icon(Icons.add),
          label: const Text('Add New Task'),
        ),
      ]),
    );
  }
}

class TaskRow extends StatelessWidget {
  const TaskRow({
    super.key,
    required this.item,
    required this.index,
    this.avatars = false,
  });
  final WorkItem item;
  final int index;
  final bool avatars;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      StoreScope.of(context).selectedTask = item;
      Navigator.pushNamed(context, '/task-details');
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Feb', style: TextStyle(color: muted, fontSize: 13)),
                gap(4),
                Text(
                  '${[14, 19, 22, 12][index % 4]}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                gap(6),
                Text(
                  item.description,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                if (avatars) ...[gap(8), const AvatarStack()],
                gap(12),
                Row(
                  children: [
                    Expanded(
                      child: ProgressLine(
                        item.progress,
                        color: index.isEven ? pink : purple,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      '${(item.progress * 100).round()}%',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key, this.overlay});
  final String? overlay;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.overlay != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.overlay == 'date') {
          pickDate();
        } else {
          pickTime();
        }
      });
    }
  }

  Future<void> pickDate() async {
    final s = StoreScope.of(context);
    final d = await showAppDatePicker(context);
    if (d != null) {
      s.dueDate = d;
      await s.save();
    }
  }

  Future<void> pickTime() async {
    final s = StoreScope.of(context);
    final d = await showAppTimePicker(context);
    if (d != null) {
      s.dueTime = d;
      await s.save();
    }
  }

  void addSubtask() {
    final field = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: field,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Subtask name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (field.text.trim().isNotEmpty) {
                Navigator.pop(ctx, field.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ).then((v) {
      field.dispose();
      if (v != null && mounted) {
        final s = StoreScope.of(context);
        s.subtasks.add(v);
        s.save();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context), item = s.activeTask;
    final progress = s.subtasks.isNotEmpty && s.completed.isNotEmpty
        ? s.completed.length / s.subtasks.length
        : item.progress;
    return AppPage(
      title: 'Task Details',
      action: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'time') {
            pickTime();
          } else {
            Navigator.pushNamed(context, '/task-edit');
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit Task')),
          PopupMenuItem(value: 'time', child: Text('Set time')),
        ],
      ),
      bottom: FilledButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/task-edit'),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Edit Task'),
      ),
      child: pageList([
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 32,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -.7,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.tint(lavender),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Text(
                'Progress:${(progress * 100).round()}%',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        gap(28),
        const SectionTitle('Description'),
        Text(
          item.description.isNotEmpty ? item.description : descriptionText,
          style: const TextStyle(color: muted, fontSize: 15, height: 1.6),
        ),
        gap(30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Assigned To'),
                  for (final m in item.members)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Avatar(index: m == 'Alex Smith' ? 0 : 3, size: 30),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              m,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Due Date'),
                  InkWell(
                    onTap: pickDate,
                    child: Text(
                      s.dueDate == DateTime(2023, 7, 14)
                          ? 'Fri, 14 July 2023'
                          : shortDate(s.dueDate),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  gap(10),
                  InkWell(
                    onTap: pickTime,
                    child: Text(
                      s.dueTime.format(context),
                      style: const TextStyle(color: muted, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        gap(16),
        SectionTitle('Subtasks', action: 'Add Subtask', onTap: addSubtask),
        for (int i = 0; i < s.subtasks.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Surface(
              color: i == 0 ? purple : null,
              radius: 24,
              padding: const EdgeInsets.fromLTRB(22, 14, 10, 14),
              onTap: () {
                s.completed.contains(s.subtasks[i])
                    ? s.completed.remove(s.subtasks[i])
                    : s.completed.add(s.subtasks[i]);
                {
                  item.progress = s.completed.length / s.subtasks.length;
                }
                s.save();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.subtasks[i],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: i == 0 ? Colors.white : context.foreground,
                            decoration: s.completed.contains(s.subtasks[i])
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        gap(5),
                        Text(
                          i == 0 ? '24 Hours' : '08 Hours',
                          style: TextStyle(
                            color: i == 0 ? Colors.white70 : muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    shape: const CircleBorder(),
                    side: BorderSide(
                      color: i == 0 ? Colors.white : lavender,
                      width: 2,
                    ),
                    activeColor: i == 0 ? teal : purple,
                    value: s.completed.contains(s.subtasks[i]),
                    onChanged: (v) {
                      v == true
                          ? s.completed.add(s.subtasks[i])
                          : s.completed.remove(s.subtasks[i]);
                      {
                        item.progress = s.completed.length / s.subtasks.length;
                      }
                      s.save();
                    },
                  ),
                ],
              ),
            ),
          ),
        gap(10),
        const SectionTitle('Attachment'),
        Wrap(
          spacing: 12,
          children: [
            ActionChip(
              avatar: const Icon(
                Icons.menu_book_outlined,
                size: 19,
                color: pink,
              ),
              label: const Text('Brandbook'),
              backgroundColor: context.tint(blush),
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Brandbook'),
                  content: const Text(
                    'Taskflow design foundations\n\nPrimary #8581FF\nSecondary #75BFCF\nText #031637\n\nUse clear hierarchy, soft surfaces and generous spacing.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
            ActionChip(
              avatar: const Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: teal,
              ),
              label: const Text('Comments'),
              backgroundColor: context.tint(cream),
              onPressed: () => Navigator.pushNamed(context, '/chat'),
            ),
          ],
        ),
      ]),
    );
  }
}

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key, this.edit = false});
  final bool edit;
  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final form = GlobalKey<FormState>();
  late final TextEditingController title, description;
  bool ready = false;
  int board = 0;
  String date = 'Feb 14 - 24', hours = '08 Hours';
  List<String> members = ['Alex Smith', 'HR Rumen'];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!ready) {
      final item = widget.edit ? StoreScope.of(context).activeTask : null;
      title = TextEditingController(
        text: widget.edit
            ? item?.title ?? 'Smart Home App'
            : 'Fintech App Design',
      );
      description = TextEditingController(
        text: item?.description.isNotEmpty == true
            ? item!.description
            : descriptionText,
      );
      members = List.of(item?.members ?? members);
      date = item?.date ?? date;
      hours = item?.hours ?? hours;
      board = const [
        'Ongoing',
        'Working',
        'Completed',
      ].indexOf(item?.status ?? 'Ongoing').clamp(0, 2);
      ready = true;
    }
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: widget.edit ? 'Edit Task' : 'Add New Sub Task',
    bottom: FilledButton(
      onPressed: () async {
        if (!form.currentState!.validate()) {
          return;
        }
        final s = StoreScope.of(context);
        final item = widget.edit ? s.activeTask : null;
        if (item != null) {
          item.title = title.text.trim();
          item.description = description.text.trim();
          item.members = List.of(members);
          item.status = const ['Ongoing', 'Working', 'Completed'][board];
          item.date = date;
          item.hours = hours;
          if (board == 2) {
            item.progress = 1;
          }
        } else {
          s.tasks.insert(
            0,
            WorkItem(
              title: title.text.trim(),
              description: description.text.trim(),
              date: date,
              hours: hours,
              members: List.of(members),
              status: const ['Ongoing', 'Working', 'Completed'][board],
              progress: board == 2 ? 1 : 0,
            ),
          );
        }
        await s.save();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/task-list',
            (_) => false,
          );
        }
      },
      child: Text(widget.edit ? 'Save Task' : 'Create Task'),
    ),
    child: Form(
      key: form,
      child: pageList([
        label('Title'),
        TextFormField(
          key: const Key('task-name'),
          controller: title,
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 4),
          ),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a task title' : null,
        ),
        gap(16),
        const Divider(),
        gap(16),
        label('Team Member'),
        Row(
          children: [
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Avatar(index: i, size: 44),
              ),
            IconButton.filled(
              tooltip: 'Assign members',
              onPressed: chooseMembers,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: purple),
            ),
          ],
        ),
        gap(24),
        SectionTitle('Assigned To', action: '⊕', onTap: chooseMembers),
        Wrap(
          spacing: 10,
          children: members
              .map(
                (e) => InputChip(
                  label: Text(e),
                  onDeleted: () => setState(() => members.remove(e)),
                  backgroundColor: context.tint(
                    e == 'Alex Smith' ? cream : blush,
                  ),
                ),
              )
              .toList(),
        ),
        gap(24),
        const SectionTitle('Timeline'),
        Wrap(
          spacing: 10,
          children: [
            ActionChip(
              label: Text('$date ⌄'),
              backgroundColor: context.tint(const Color(0xFFCDF7FF)),
              onPressed: () async {
                final d = await showAppDatePicker(context);
                if (d != null && mounted) {
                  setState(() => date = shortDate(d));
                }
              },
            ),
            ActionChip(
              label: Text('$hours ⌄'),
              backgroundColor: context.tint(lavender),
              onPressed: () async {
                final t = await showAppTimePicker(context);
                if (t != null && context.mounted) {
                  setState(() => hours = t.format(context));
                }
              },
            ),
          ],
        ),
        gap(24),
        const SectionTitle('Description'),
        TextFormField(
          controller: description,
          maxLines: 3,
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: const TextStyle(fontSize: 14, color: muted, height: 1.5),
        ),
        gap(24),
        label('Board'),
        Segments(
          labels: const ['Ongoing', 'Working', 'Completed'],
          value: board,
          onChanged: (i) => setState(() => board = i),
        ),
      ]),
    ),
  );
  Future<void> chooseMembers() async {
    final r = await Navigator.pushNamed(
      context,
      '/assignees',
      arguments: members,
    );
    if (r is List<String>) {
      setState(() => members = r);
    }
  }
}

class AssigneesPage extends StatefulWidget {
  const AssigneesPage({
    super.key,
    this.initial = const ['Alex Smith', 'HR Rumen'],
  });
  final List<String> initial;
  @override
  State<AssigneesPage> createState() => _AssigneesPageState();
}

class _AssigneesPageState extends State<AssigneesPage> {
  String query = '';
  late Set<String> selected = widget.initial.toSet();
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Assign To',
    bottom: FilledButton(
      onPressed: () => Navigator.pop(context, selected.toList()),
      child: Text('Assign ${selected.length} Members'),
    ),
    child: pageList([
      SearchBox(
        hint: 'Name Or Email',
        onChanged: (v) => setState(() => query = v),
      ),
      gap(34),
      const SectionTitle('Recently Assign'),
      for (final m
          in ['Angelina', 'Alex Smith', 'HR Rumen', 'Tawfiqul Emon'].where(
            (e) => '$e ${e.replaceAll(' ', '').toLowerCase()}@gmail.com'
                .toLowerCase()
                .contains(query.toLowerCase()),
          ))
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          leading: Avatar(index: memberNames.indexOf(m).clamp(0, 5), size: 46),
          title: Text(m, style: const TextStyle(fontSize: 17)),
          subtitle: Text(
            '${m.replaceAll(' ', '').toLowerCase()}@gmail.com',
            style: const TextStyle(fontSize: 12, color: muted),
          ),
          trailing: Icon(
            selected.contains(m) ? Icons.check_circle : Icons.circle_outlined,
            color: selected.contains(m) ? purple : muted,
          ),
          onTap: () => setState(() {
            selected.contains(m) ? selected.remove(m) : selected.add(m);
          }),
        ),
    ]),
  );
}
