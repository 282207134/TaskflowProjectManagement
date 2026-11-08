import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkItem {
  WorkItem({
    required this.title,
    this.description = '',
    this.progress = .0,
    this.priority = 'Medium',
    this.status = 'Ongoing',
    this.date = 'Feb 14 - 24',
    this.hours = '08 Hours',
    this.members = const ['Alex Smith', 'HR Rumen'],
    List<String>? subtasks,
    Set<String>? completed,
    DateTime? dueDate,
    TimeOfDay? dueTime,
  }) : subtasks = subtasks ?? ['Create Design System', 'Create Wireframe'],
       completed = completed ?? {},
       dueDate = dueDate ?? DateTime(2023, 7, 14),
       dueTime = dueTime ?? const TimeOfDay(hour: 17, minute: 0);
  String title, description, priority, status, date, hours;
  double progress;
  List<String> members;
  List<String> subtasks;
  Set<String> completed;
  DateTime dueDate;
  TimeOfDay dueTime;
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'progress': progress,
    'priority': priority,
    'status': status,
    'date': date,
    'hours': hours,
    'members': members,
    'subtasks': subtasks,
    'completed': completed.toList(),
    'dueDate': dueDate.toIso8601String(),
    'hour': dueTime.hour,
    'minute': dueTime.minute,
  };
  factory WorkItem.fromJson(Map<String, dynamic> j) => WorkItem(
    title: j['title'] as String,
    description: j['description'] as String? ?? '',
    progress: (j['progress'] as num? ?? 0).toDouble(),
    priority: j['priority'] as String? ?? 'Medium',
    status: j['status'] as String? ?? 'Ongoing',
    date: j['date'] as String? ?? 'Feb 14 - 24',
    hours: j['hours'] as String? ?? '08 Hours',
    members: (j['members'] as List?)?.cast<String>() ?? [],
    subtasks: (j['subtasks'] as List?)?.cast<String>(),
    completed: (j['completed'] as List?)?.cast<String>().toSet(),
    dueDate: DateTime.tryParse(j['dueDate'] as String? ?? ''),
    dueTime: TimeOfDay(
      hour: j['hour'] as int? ?? 17,
      minute: j['minute'] as int? ?? 0,
    ),
  );
}

const descriptionText =
    'Design a simple application with clean layout and color’s based on client’s brand guidelines.';
const memberNames = [
  'Alex Smith',
  'Tawfiqul Emon',
  'Al Nadir',
  'HR Rumen',
  'Angelina',
  'Shyed Hossen',
];

/// Observable local data. Never persists credentials or authentication tokens.
class AppStore extends ChangeNotifier {
  AppStore(this.preferences);
  final SharedPreferences preferences;
  bool dark = false, signedIn = false, notifications = false, faceId = true;
  String name = 'Alex Smith',
      company = 'Onixlab Studio',
      email = 'info@onixlab.net',
      language = 'English (US)';
  List<WorkItem> projects = [
    WorkItem(title: 'Working on Task Manager Application', progress: .62),
    WorkItem(
      title: 'NFT Web Design Application',
      progress: .70,
      status: 'Paused',
    ),
    WorkItem(title: 'Fintech App Design', progress: .46),
  ];
  List<WorkItem> tasks = [
    WorkItem(
      title: 'Creating App Design',
      description: 'Creating App Design',
      progress: .5,
    ),
    WorkItem(
      title: 'Meeting With Alex Client',
      description: '09:30 AM - 12:00 AM',
      progress: .8,
    ),
    WorkItem(
      title: 'User Flow Research',
      description: '24 User In One Day',
      progress: .7,
    ),
    WorkItem(
      title: 'Fintech Project',
      description: '11:00 PM Till Drop',
      progress: 1,
      status: 'Completed',
    ),
  ];
  List<String> messages = [];
  WorkItem details = WorkItem(
    title: 'Smart Home App',
    progress: .65,
    description: descriptionText,
    members: const ['Alex Smith', 'Angelina'],
  );
  WorkItem? selectedTask;
  WorkItem get activeTask => selectedTask ?? details;
  List<String> get subtasks => activeTask.subtasks;
  Set<String> get completed => activeTask.completed;
  DateTime get dueDate => activeTask.dueDate;
  set dueDate(DateTime value) => activeTask.dueDate = value;
  TimeOfDay get dueTime => activeTask.dueTime;
  set dueTime(TimeOfDay value) => activeTask.dueTime = value;
  bool unread = true;

  static Future<AppStore> load() async {
    final s = AppStore(await SharedPreferences.getInstance());
    try {
      final raw = s.preferences.getString('taskflow.v1');
      if (raw != null) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        s.dark = j['dark'] == true;
        s.signedIn = j['signedIn'] == true;
        s.name = j['name'] as String? ?? s.name;
        s.company = j['company'] as String? ?? s.company;
        s.email = j['email'] as String? ?? s.email;
        s.language = j['language'] as String? ?? s.language;
        s.notifications = j['notifications'] == true;
        s.faceId = j['faceId'] != false;
        if (j['projects'] is List) {
          s.projects = (j['projects'] as List)
              .map((e) => WorkItem.fromJson(e))
              .toList();
        }
        if (j['tasks'] is List) {
          s.tasks = (j['tasks'] as List)
              .map((e) => WorkItem.fromJson(e))
              .toList();
        }
        s.messages = (j['messages'] as List?)?.cast<String>() ?? [];
        if (j['details'] is Map<String, dynamic>) {
          s.details = WorkItem.fromJson(j['details']);
        }
        s.unread = j['unread'] != false;
      }
    } on FormatException {
      /* Fall back to reference data if a snapshot is damaged. */
    }
    return s;
  }

  Future<void> save() async {
    notifyListeners();
    final ok = await preferences.setString(
      'taskflow.v1',
      jsonEncode({
        'dark': dark,
        'signedIn': signedIn,
        'name': name,
        'company': company,
        'email': email,
        'language': language,
        'notifications': notifications,
        'faceId': faceId,
        'projects': projects.map((e) => e.toJson()).toList(),
        'tasks': tasks.map((e) => e.toJson()).toList(),
        'messages': messages,
        'details': details.toJson(),
        'unread': unread,
      }),
    );
    if (!ok) {
      throw StateError('Could not save Taskflow data.');
    }
  }

  void setDark(bool value) {
    dark = value;
    save();
  }
}

class StoreScope extends InheritedNotifier<AppStore> {
  const StoreScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
