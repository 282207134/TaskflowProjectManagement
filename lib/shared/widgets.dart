import 'package:flutter/material.dart';

import '../core/theme.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.index = 0,
    this.size = 48,
    this.online = false,
  });
  final int index;
  final double size;
  final bool online;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size * .35),
          child: Image.asset(
            'assets/images/avatar-${index % 6}.png',
            width: size,
            height: size,
          ),
        ),
        if (online)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF35B44A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class AvatarStack extends StatelessWidget {
  const AvatarStack({super.key, this.count = 2});
  final int count;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 100,
    height: 36,
    child: Stack(
      children: [
        for (int i = 0; i < 3; i++)
          Positioned(
            left: i * 21.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Avatar(index: i + 2, size: 30),
            ),
          ),
        Positioned(
          left: 63,
          child: CircleAvatar(
            radius: 17,
            backgroundColor: pink,
            child: Text(
              '+$count',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(22),
    this.radius = 28,
    this.onTap,
  });
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: color ?? Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: context.line),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -.5,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              action!,
              style: const TextStyle(color: purple, fontSize: 14),
            ),
          ),
      ],
    ),
  );
}

class Segments extends StatelessWidget {
  const Segments({
    super.key,
    required this.labels,
    required this.value,
    required this.onChanged,
  });
  final List<String> labels;
  final int value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Surface(
    radius: 24,
    padding: const EdgeInsets.all(4),
    child: Row(
      children: [
        for (int i = 0; i < labels.length; i++)
          Expanded(
            child: Material(
              color: value == i ? purple : Colors.transparent,
              borderRadius: BorderRadius.circular(21),
              child: InkWell(
                borderRadius: BorderRadius.circular(21),
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 19),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: value == i ? Colors.white : muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class ProgressLine extends StatelessWidget {
  const ProgressLine(this.value, {super.key, this.color = purple});
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: LinearProgressIndicator(
      value: value,
      minHeight: 7,
      color: color,
      backgroundColor: context.tint(const Color(0xFFF2F8FA)),
    ),
  );
}

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.bottom,
    this.nav = -1,
    this.leading,
  });
  final String title;
  final Widget child;
  final Widget? action, bottom, leading;
  final int nav;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      leadingWidth: title == 'HOME' ? 92 : null,
      leading:
          leading ??
          IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
      actions: [?action, const SizedBox(width: 20)],
    ),
    body: child,
    bottomNavigationBar: bottom != null
        ? SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
              child: bottom,
            ),
          )
        : nav >= 0
        ? BottomNav(index: nav)
        : null,
  );
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .035),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < 5; i++)
              i == 2
                  ? IconButton.filled(
                      tooltip: 'Create',
                      style: IconButton.styleFrom(
                        backgroundColor: purple,
                        fixedSize: const Size(60, 60),
                      ),
                      onPressed: () => showCreateMenu(context),
                      icon: const Icon(
                        Icons.add,
                        size: 36,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      tooltip: const [
                        'Home',
                        'Projects',
                        '',
                        'Messages',
                        'Analytics',
                      ][i],
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        const [
                          '/home',
                          '/projects',
                          '',
                          '/messages',
                          '/analytics',
                        ][i],
                        (_) => false,
                      ),
                      icon: Icon(
                        const [
                          Icons.home_outlined,
                          Icons.assignment_outlined,
                          Icons.add,
                          Icons.chat_bubble_outline_rounded,
                          Icons.stacked_bar_chart_rounded,
                        ][i],
                        size: 29,
                        color: index == i ? purple : muted,
                      ),
                    ),
          ],
        ),
      ),
    ),
  );
}

void showCreateMenu(BuildContext context) => showModalBottomSheet(
  context: context,
  builder: (ctx) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SectionTitle('Create something great'),
          ListTile(
            leading: const Icon(Icons.folder_outlined, color: purple),
            title: const Text('Create New Project'),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/project-new');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_task, color: teal),
            title: const Text('Create Task'),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/task-new');
            },
          ),
        ],
      ),
    ),
  ),
);
void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
Widget pageList(
  List<Widget> children, {
  EdgeInsets padding = const EdgeInsets.fromLTRB(28, 16, 28, 24),
}) => ListView(padding: padding, children: children);
Widget gap([double height = 24]) => SizedBox(height: height);
Widget label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Text(text, style: const TextStyle(color: muted, fontSize: 15)),
);

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.hint = 'Search...',
    required this.onChanged,
  });
  final String hint;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search, size: 26),
      suffixIcon: const Icon(Icons.tune, size: 22, color: muted),
    ),
  );
}
