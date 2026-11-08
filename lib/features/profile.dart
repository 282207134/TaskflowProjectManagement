import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

Future<void> showLogout(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 4, 28, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Out?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            gap(12),
            const Text(
              'Are you sure want to log out?',
              style: TextStyle(color: muted),
            ),
            gap(36),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 60),
                      side: BorderSide(color: context.line),
                    ),
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel', style: TextStyle(color: muted)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  if (result == true && context.mounted) {
    final s = StoreScope.of(context);
    s.signedIn = false;
    await s.save();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.logout = false});
  final bool logout;
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    if (widget.logout) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLogout(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 20, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Avatar(size: 72),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -.6,
                                ),
                              ),
                              gap(6),
                              const Text(
                                'UI/UX Designer',
                                style: TextStyle(color: muted, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    gap(30),
                    const Divider(),
                    gap(20),
                    Expanded(
                      child: ListView(
                        children: [
                          for (int i = 0; i < 8; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Material(
                                color: i == 3 ? purple : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  leading: Icon(
                                    const [
                                      Icons.home_outlined,
                                      Icons.calendar_month_outlined,
                                      Icons.settings_outlined,
                                      Icons.person_outline,
                                      Icons.info_outline,
                                      Icons.widgets_outlined,
                                      Icons.dark_mode_outlined,
                                      Icons.logout,
                                    ][i],
                                    color: i == 3
                                        ? Colors.white
                                        : i == 7
                                        ? const Color(0xFFFE6C6B)
                                        : muted,
                                  ),
                                  title: Text(
                                    const [
                                      'Home',
                                      'Calendar',
                                      'Settings',
                                      'Profile',
                                      'Help & Support',
                                      'App Widgets',
                                      'Appearance',
                                      'Log Out',
                                    ][i],
                                    style: TextStyle(
                                      color: i == 3
                                          ? Colors.white
                                          : i == 7
                                          ? const Color(0xFFFE6C6B)
                                          : context.foreground,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onTap: () {
                                    if (i == 7) {
                                      showLogout(context);
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        const [
                                          '/home',
                                          '/calendar',
                                          '/settings',
                                          '/profile',
                                          '/help',
                                          '/widgets',
                                          '/settings',
                                        ][i],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        for (final label in ['G', '●', 'f'])
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: CircleAvatar(
                              backgroundColor: context.tint(
                                const Color(0xFFF2F8FA),
                              ),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: purple,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.only(top: 42, bottom: 32),
                  decoration: BoxDecoration(
                    color: context.tint(lavender),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.chevron_left, color: purple),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.edit = false});
  final bool edit;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final form = GlobalKey<FormState>();
  late TextEditingController name, company, email;
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final s = StoreScope.of(context);
      name = TextEditingController(text: s.name);
      company = TextEditingController(text: s.company);
      email = TextEditingController(text: s.email);
      initialized = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    company.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: widget.edit ? 'Edit Profile' : 'Profile',
      nav: widget.edit ? -1 : 0,
      action: widget.edit
          ? null
          : IconButton(
              tooltip: 'Log Out',
              onPressed: () => showLogout(context),
              icon: const Icon(Icons.logout),
            ),
      bottom: widget.edit
          ? FilledButton(
              onPressed: () async {
                if (!form.currentState!.validate()) {
                  return;
                }
                s.name = name.text.trim();
                s.company = company.text.trim();
                s.email = email.text.trim();
                await s.save();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            )
          : null,
      child: Form(
        key: form,
        child: pageList([
          gap(24),
          const Center(child: Avatar(size: 124)),
          gap(18),
          if (widget.edit)
            TextFormField(
              controller: name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter your name' : null,
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit Profile',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/profile-edit'),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              ],
            ),
          gap(28),
          if (widget.edit) ...[
            TextFormField(
              controller: company,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'Company',
              ),
            ),
            gap(20),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'Email',
              ),
              validator: (v) =>
                  v?.contains('@') != true ? 'Enter a valid email' : null,
            ),
            gap(20),
            const Text(
              'Passwords are managed by your authentication provider. No password is stored in this demo.',
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ] else ...[
            for (int i = 0; i < 6; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Surface(
                  radius: 22,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    const [
                      '/profile-edit',
                      '/profile-edit',
                      '/forgot',
                      '/task-list',
                      '/privacy',
                      '/settings',
                    ][i],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        const [
                          Icons.person_outline,
                          Icons.mail_outline,
                          Icons.lock_outline,
                          Icons.assignment_outlined,
                          Icons.verified_user_outlined,
                          Icons.settings_outlined,
                        ][i],
                        size: 22,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          [
                            s.company,
                            s.email,
                            'Password',
                            'Task List',
                            'Privacy And Policy',
                            'Settings',
                          ][i],
                          style: const TextStyle(color: muted, fontSize: 14),
                        ),
                      ),
                      if (i == 2)
                        const Icon(
                          Icons.visibility_off_outlined,
                          color: muted,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ]),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'Settings',
      child: pageList([
        const SectionTitle('Make Taskflow yours'),
        gap(12),
        Surface(
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.dark_mode_outlined, color: purple),
                title: const Text('Dark Mode'),
                subtitle: const Text(
                  'Use the Pixso dark palette',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                value: s.dark,
                onChanged: s.setDark,
              ),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notifications'),
                subtitle: const Text(
                  'Save notification preference',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                value: s.notifications,
                onChanged: (v) {
                  s.notifications = v;
                  s.save();
                },
              ),
            ],
          ),
        ),
        gap(),
        for (final row in [
          ('Language', s.language, '/language'),
          ('Profile', s.name, '/profile-edit'),
          ('App Widgets', 'Quick project views', '/widgets'),
          ('Help & Support', 'About this demo', '/help'),
        ])
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            title: Text(row.$1),
            subtitle: Text(
              row.$2,
              style: const TextStyle(color: muted, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, row.$3),
          ),
        gap(20),
        const Text(
          'Taskflow 1.0.0 · Flutter\nYour changes are saved on this device.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ]),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, this.privacy = false});
  final bool privacy;
  @override
  Widget build(BuildContext context) => AppPage(
    title: privacy ? 'Privacy And Policy' : 'Help & Support',
    child: pageList([
      Icon(
        privacy ? Icons.verified_user_outlined : Icons.support_agent,
        color: purple,
        size: 70,
      ),
      gap(24),
      SectionTitle(
        privacy ? 'Your data stays on your device' : 'Welcome to Taskflow',
      ),
      Text(
        privacy
            ? 'Taskflow is a local UI demonstration. Project, task, profile and message changes are stored locally using SharedPreferences. Passwords are never persisted. The app does not send messages, emails or video to a server.\n\nLanguage and permission controls save preferences; they do not activate system permissions. Uninstalling the app removes the local data.'
            : 'Use the bottom bar to move between Home, Projects, Messages and Analytics. Tap + to create a project or task. Open tasks to assign members, change dates, complete subtasks or edit details.\n\nChange appearance from Settings. Your work is saved on this device.\n\nLogin, verification, calling and media playback are demonstration flows. For a live service, connect an authentication provider, API and calling SDK.\n\nDemo verification code: 75824',
        style: const TextStyle(color: muted, fontSize: 16, height: 1.8),
      ),
      gap(30),
      FilledButton(
        onPressed: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
        child: const Text('Back to Home'),
      ),
    ]),
  );
}
