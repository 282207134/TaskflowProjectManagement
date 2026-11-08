import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String query = '';
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Message',
    nav: 3,
    action: IconButton(
      tooltip: 'New message',
      onPressed: () => Navigator.pushNamed(context, '/chat'),
      icon: const Icon(Icons.more_vert),
    ),
    child: pageList([
      SearchBox(onChanged: (v) => setState(() => query = v)),
      gap(28),
      const SectionTitle('Online Member'),
      SizedBox(
        height: 108,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          separatorBuilder: (_, _) => const SizedBox(width: 18),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/chat',
              arguments: memberNames[i],
            ),
            child: Column(
              children: [
                Avatar(index: i, size: 64, online: true),
                gap(10),
                Text(
                  memberNames[i].split(' ').first,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      gap(20),
      for (final i in [1, 2, 3, 5, 0].where(
        (i) => memberNames[i].toLowerCase().contains(query.toLowerCase()),
      ))
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              '/chat',
              arguments: memberNames[i],
            ),
            child: Row(
              children: [
                Avatar(index: i, size: 56, online: true),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberNames[i],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      gap(8),
                      Text(
                        const [
                          'Hello! How Is The Progress?',
                          'Sending The File Right Now',
                          'Can You Confirm Deadline?',
                          'I Haven’t Completed The Work',
                          '',
                          'Voice Message (0:24)',
                        ][i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Column(
                  children: [
                    if (i == 0 || i == 3)
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFF35B44A),
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    gap(5),
                    Text(
                      '${20 + i * 2} min',
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ]),
  );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.name = 'Michael Morgan'});
  final String name;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final message = TextEditingController(), scroll = ScrollController();
  bool playing = false;
  @override
  void dispose() {
    message.dispose();
    scroll.dispose();
    super.dispose();
  }

  void send() {
    if (message.text.trim().isEmpty) {
      return;
    }
    final s = StoreScope.of(context);
    s.messages.add(message.text.trim());
    s.save();
    message.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Avatar(index: 2, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(color: Color(0xFF35B44A), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Video call demo',
            onPressed: () => Navigator.pushNamed(context, '/video'),
            icon: const Icon(Icons.videocam_outlined, color: muted),
          ),
          IconButton(
            tooltip: 'Call demo',
            onPressed: () => toast(
              context,
              'Voice calling requires a connected calling service.',
            ),
            icon: const Icon(Icons.phone_outlined, color: muted),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        controller: scroll,
        padding: const EdgeInsets.all(24),
        children: [
          gap(16),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 250,
              child: Surface(
                radius: 22,
                padding: const EdgeInsets.all(18),
                child: const Text(
                  'Can You help Me To Do Something With My Landing Page?\n\nThank You 👍',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
          gap(8),
          const Text('08:24', style: TextStyle(color: muted, fontSize: 12)),
          gap(36),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Wait I’ll Send Video soon',
              style: TextStyle(fontSize: 14),
            ),
          ),
          gap(20),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 290,
              child: Surface(
                color: purple,
                padding: const EdgeInsets.all(12),
                radius: 28,
                onTap: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Design preview'),
                    content: Image.asset('assets/images/chat-preview.png'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/chat-preview.png'),
                        ),
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.play_arrow_outlined, color: ink),
                        ),
                      ],
                    ),
                    gap(12),
                    const Text(
                      'I Think This Is Will Help You 😊',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          gap(8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('07:20', style: TextStyle(color: muted, fontSize: 12)),
          ),
          gap(28),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 250,
              child: Surface(
                padding: const EdgeInsets.all(12),
                radius: 20,
                onTap: () {
                  setState(() => playing = !playing);
                  toast(context, 'Audio preview · no recording is attached.');
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: context.tint(lavender),
                      child: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        color: purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < 24; i++)
                            Container(
                              width: 2,
                              height: 8 + (i * 13 % 23).toDouble(),
                              color: i < 15 ? purple : lavender,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          gap(8),
          const Text('10:40', style: TextStyle(color: muted, fontSize: 12)),
          for (final m in s.messages) ...[
            gap(18),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 285),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(m, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
          gap(10),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            12 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('message-input'),
                  controller: message,
                  onSubmitted: (_) => send(),
                  decoration: const InputDecoration(
                    hintText: 'Type Here...',
                    suffixIcon: Icon(Icons.attach_file, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                tooltip: 'Send message',
                style: IconButton.styleFrom(
                  backgroundColor: purple,
                  fixedSize: const Size(52, 52),
                ),
                onPressed: send,
                icon: const Icon(Icons.send_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool mic = true, camera = true;
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Video call',
    bottom: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Chat',
          onPressed: () => Navigator.pushNamed(context, '/chat'),
          icon: const Icon(Icons.chat_bubble_outline),
        ),
        IconButton(
          tooltip: 'Call information',
          onPressed: () => toast(
            context,
            'Local call preview. No live camera or microphone is used.',
          ),
          icon: const Icon(Icons.more_horiz),
        ),
        IconButton.filled(
          tooltip: 'Toggle camera',
          style: IconButton.styleFrom(
            backgroundColor: ink,
            fixedSize: const Size(56, 56),
          ),
          onPressed: () => setState(() => camera = !camera),
          icon: Icon(
            camera ? Icons.videocam_outlined : Icons.videocam_off_outlined,
            color: Colors.white,
          ),
        ),
        IconButton.filled(
          tooltip: 'Toggle microphone',
          style: IconButton.styleFrom(
            backgroundColor: purple,
            fixedSize: const Size(56, 56),
          ),
          onPressed: () => setState(() => mic = !mic),
          icon: Icon(
            mic ? Icons.mic_none : Icons.mic_off_outlined,
            color: Colors.white,
          ),
        ),
        IconButton.filled(
          tooltip: 'End call',
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFFE6C6B),
            fixedSize: const Size(56, 56),
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ],
    ),
    child: pageList([
      Align(
        alignment: Alignment.centerLeft,
        child: Surface(
          radius: 20,
          padding: const EdgeInsets.all(16),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month_outlined, color: muted, size: 20),
              SizedBox(width: 10),
              Text(
                '4:24 PM To 8:40 PM',
                style: TextStyle(color: muted, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      gap(24),
      const Text(
        'Finix Website Devs',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
      gap(6),
      const Text(
        'Discuss landing page development project',
        style: TextStyle(color: muted, fontSize: 13),
      ),
      gap(18),
      AspectRatio(
        aspectRatio: 381 / 333,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              camera
                  ? Image.asset(
                      'assets/images/call-main.png',
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: ink,
                      child: const Center(child: Avatar(size: 100)),
                    ),
              const Positioned(
                left: 18,
                bottom: 18,
                child: Text(
                  'Angelina Lerry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      gap(14),
      Row(
        children: [
          for (int i = 1; i < 4; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == 3 ? 0 : 12),
                child: AspectRatio(
                  aspectRatio: 112 / 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/call-$i.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 8,
                          bottom: 10,
                          child: Text(
                            const [
                              '',
                              'Alex Smith',
                              'Angelina .k',
                              'Smith. G',
                            ][i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      gap(14),
      const Text(
        'Demo call · preview only',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted, fontSize: 11),
      ),
    ]),
  );
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'Notifications',
      nav: 0,
      action: IconButton(
        tooltip: 'Mark all read',
        onPressed: () {
          s.unread = false;
          s.save();
        },
        icon: const Icon(Icons.done_all, color: purple),
      ),
      child: pageList([
        for (int i = 0; i < 5; i++)
          InkWell(
            onTap: () {
              s.unread = false;
              s.save();
              Navigator.pushNamed(context, '/task-details');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Avatar(index: i == 0 ? 3 : i, size: 48),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i == 2 ? 'Tawfiqul Emon' : 'Finix App Ui Kit',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        gap(8),
                        Text(
                          const [
                            'HR Rumen commented',
                            'Al Nadir mentioned you in the ‘Component’ subtask',
                            'mentioned you in a comment on Finix App Task',
                            'Al Nadir mentioned you in the ‘Component’ subtask',
                            'Shyed Hossain assigned you on Dashboard Design',
                          ][i],
                          style: const TextStyle(color: muted, fontSize: 13),
                        ),
                        if (i == 0) ...[
                          gap(8),
                          const Text(
                            '@nadir  Completed the Ui, please check',
                            style: TextStyle(color: purple, fontSize: 12),
                          ),
                        ],
                        if (i == 2) ...[
                          gap(12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/chat-preview.png',
                              height: 95,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        gap(12),
                        Text(
                          i < 2
                              ? '${i == 0 ? '12 min' : '4 hours'} ago'
                              : 'Yesterday at 12:30 PM',
                          style: const TextStyle(color: muted, fontSize: 11),
                        ),
                        gap(18),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                  if (s.unread && i == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: Icon(
                        Icons.circle,
                        color: Color(0xFF35B44A),
                        size: 10,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ]),
    );
  }
}
