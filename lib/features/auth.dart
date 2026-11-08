import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.auto = true});
  final bool auto;
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (widget.auto) {
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            StoreScope.of(context).signedIn ? '/home' : '/onboarding',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: purple,
    body: Center(
      child: Text(
        'Task Flow',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
    ),
  );
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.second = false});
  final bool second;
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late int step = widget.second ? 1 : 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 16),
        child: FilledButton(
          onPressed: () {
            if (step == 0) {
              setState(() => step = 1);
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          child: const Text('Next'),
        ),
      ),
    ),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (ctx, box) => ListView(
          children: [
            SizedBox(
              height: box.maxHeight * .62,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/onboarding${step == 1 ? '-2' : ''}.png',
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    right: 12,
                    top: 0,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text('Skip'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step == 0
                        ? 'Manage Your\nDaily Tasks With'
                        : 'Manage Your\nProject Easily With',
                    style: const TextStyle(
                      fontSize: 32,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    step == 0 ? 'Must List' : 'Task Flow',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: purple,
                      letterSpacing: -1,
                    ),
                  ),
                  gap(12),
                  const Text(
                    'Make Your Project Or Task On Track\nEasily And Seamlessly',
                    style: TextStyle(fontSize: 14, color: muted, height: 1.6),
                  ),
                  gap(22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 2; i++)
                        Container(
                          margin: const EdgeInsets.all(3),
                          width: step == i ? 32 : 10,
                          height: 8,
                          decoration: BoxDecoration(
                            color: step == i ? purple : lavender,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  gap(12),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.signup = false, this.filled = false});
  final bool signup, filled;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  late final TextEditingController email, password, name;
  bool hidden = true;
  @override
  void initState() {
    super.initState();
    email = TextEditingController(
      text: widget.filled ? 'info@onixlab.net' : '',
    );
    password = TextEditingController(text: widget.filled ? 'taskflow2026' : '');
    name = TextEditingController(text: widget.filled ? 'Onixlab Studio' : '');
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) {
      return;
    }
    final s = StoreScope.of(context);
    s.email = email.text.trim();
    if (widget.signup) {
      s.name = name.text.trim();
      await s.save();
      if (mounted) {
        Navigator.pushNamed(context, '/check-email');
      }
    } else {
      s.signedIn = true;
      await s.save();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: '',
    child: LayoutBuilder(
      builder: (ctx, box) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight - 44),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gap(widget.signup ? 12 : 24),
                Text(
                  widget.signup ? 'Create An Account' : 'Hello Again!',
                  textAlign: widget.signup ? TextAlign.left : TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.signup ? 26 : 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
                if (!widget.signup) ...[
                  gap(12),
                  const Text(
                    'Welcome Back, You’ve Been\nMissed',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 14, height: 1.5),
                  ),
                ],
                gap(widget.signup ? 40 : 54),
                if (widget.signup) ...[
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: 'Your Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                  gap(22),
                ],
                TextFormField(
                  key: const Key('email'),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline, size: 22),
                  ),
                  validator: (v) =>
                      v == null ||
                          !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(v.trim())
                      ? 'Enter a valid email'
                      : null,
                ),
                gap(22),
                TextFormField(
                  key: const Key('password'),
                  controller: password,
                  obscureText: hidden,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 22),
                    suffixIcon: IconButton(
                      tooltip: 'Show password',
                      onPressed: () => setState(() => hidden = !hidden),
                      icon: Icon(
                        hidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 22,
                        color: muted,
                      ),
                    ),
                  ),
                  validator: (v) =>
                      (v?.length ?? 0) < 6 ? 'Use at least 6 characters' : null,
                ),
                if (!widget.signup)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot'),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: context.foreground,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                gap(widget.signup ? 34 : 6),
                FilledButton(
                  onPressed: submit,
                  child: Text(widget.signup ? 'Sign Up' : 'Sign In'),
                ),
                gap(24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: context.foreground,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                gap(24),
                for (final provider in ['Google', 'Apple'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Surface(
                      radius: 22,
                      padding: const EdgeInsets.all(16),
                      onTap: () => toast(
                        context,
                        '$provider sign-in requires a connected authentication service.',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider == 'Google'
                              ? const Text(
                                  'G',
                                  style: TextStyle(
                                    color: Color(0xFF4285F4),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Icon(
                                  Icons.apple,
                                  size: 25,
                                  color: context.foreground,
                                ),
                          const SizedBox(width: 18),
                          Text(
                            'Sign In With $provider',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    widget.signup ? '/login' : '/signup',
                  ),
                  child: Text(
                    widget.signup
                        ? 'Already have an account? Sign In'
                        : 'Create an account',
                  ),
                ),
                gap(22),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'By sign in, I accept the ',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/privacy'),
                      child: const Text(
                        'Terms of Service and Community\nGuidelines and have read Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: purple, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                gap(12),
                const Text(
                  'Local demo · no online authentication',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key, this.verify = false, this.filled = false});
  final bool verify, filled;
  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  late final List<TextEditingController> digits = List.generate(
    5,
    (i) => TextEditingController(text: widget.filled ? '75824'[i] : ''),
  );
  @override
  void dispose() {
    email.dispose();
    for (final c in digits) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: widget.verify ? 'Verification Code' : 'Forgot Password',
    bottom: FilledButton(
      onPressed: () async {
        if (!form.currentState!.validate()) {
          return;
        }
        if (widget.verify) {
          if (digits.map((e) => e.text).join() != '75824') {
            toast(context, 'Demo code is 75824');
            return;
          }
          final s = StoreScope.of(context);
          s.signedIn = true;
          await s.save();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }
        } else {
          Navigator.pushNamed(context, '/verification');
        }
      },
      child: Text(widget.verify ? 'Verify' : 'Send Email'),
    ),
    child: Form(
      key: form,
      child: pageList([
        gap(30),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.line),
            ),
            child: CircleAvatar(
              radius: 58,
              backgroundColor: context.tint(const Color(0xFFF2F8FA)),
              child: const CircleAvatar(
                radius: 36,
                backgroundColor: purple,
                child: Icon(
                  Icons.phonelink_lock,
                  size: 34,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        gap(38),
        Text(
          widget.verify ? 'Verification Code' : 'Forgot Password',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        gap(16),
        Text(
          widget.verify
              ? 'We have to send the verification to your email onix****@mail.com'
              : 'Please Enter The Email Address Associated With Your Account',
          textAlign: TextAlign.center,
          style: const TextStyle(color: muted, fontSize: 15, height: 1.5),
        ),
        gap(46),
        if (widget.verify) ...[
          Row(
            children: [
              for (int i = 0; i < 5; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == 4 ? 0 : 12),
                    child: TextFormField(
                      controller: digits[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(vertical: 19),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 4) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => v?.isEmpty == true ? '•' : null,
                    ),
                  ),
                ),
            ],
          ),
          gap(20),
          TextButton(
            onPressed: () => toast(
              context,
              'Demo code: 75824. Email delivery is not connected.',
            ),
            child: const Text('Resend Code'),
          ),
        ] else
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            validator: (v) =>
                v?.contains('@') != true ? 'Enter a valid email' : null,
          ),
        gap(16),
        const Text(
          'Demo verification code: 75824',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ]),
    ),
  );
}

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.kind});
  final String kind;
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String query = '';
  final phone = TextEditingController(text: '+880-1601-804-097');
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    final kind = widget.kind;
    return AppPage(
      title: switch (kind) {
        'email' => 'Check Email',
        'phone' => 'Phone Number',
        'permissions' => 'Face ID Details',
        _ => 'Language',
      },
      action: IconButton(
        tooltip: 'Close',
        onPressed: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
        icon: const Icon(Icons.close),
      ),
      bottom: FilledButton(
        onPressed: () async {
          if (kind == 'phone' &&
              phone.text.replaceAll(RegExp(r'\D'), '').length < 7) {
            toast(context, 'Enter a valid phone number');
            return;
          }
          await s.save();
          if (!context.mounted) {
            return;
          }
          Navigator.pushNamed(context, switch (kind) {
            'email' => '/language',
            'language' => '/phone',
            'phone' => '/permissions',
            _ => '/home',
          });
        },
        child: Text(kind == 'email' ? 'I’ve verified my Email' : 'Continue'),
      ),
      child: pageList([
        if (kind == 'language') ...[
          SearchBox(
            hint: 'Search Language here',
            onChanged: (v) => setState(() => query = v),
          ),
          gap(20),
          for (final l in [
            'English (US)',
            'English (UK)',
            'English (IND)',
            'Bangla (BD)',
            'Arabic',
            'Spanish',
            'Chinese',
            'Portuguese',
          ].where((l) => l.toLowerCase().contains(query.toLowerCase())))
            Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  title: Text(l),
                  trailing: Icon(
                    s.language == l
                        ? Icons.check_circle_outline
                        : Icons.circle_outlined,
                    color: s.language == l ? purple : muted,
                  ),
                  onTap: () {
                    s.language = l;
                    s.save();
                  },
                ),
                const Divider(height: 1),
              ],
            ),
        ] else if (kind == 'email') ...[
          gap(20),
          const SectionTitle('Please check your\nemail'),
          Text(
            'Before you continue, Verify the email we sent\nto ${s.email}',
            style: const TextStyle(color: muted, fontSize: 15, height: 1.7),
          ),
          gap(60),
          const Center(
            child: Icon(
              Icons.mark_email_read_outlined,
              color: purple,
              size: 190,
            ),
          ),
          gap(30),
          TextButton(
            onPressed: () => toast(
              context,
              'Email delivery is not connected in this local demo.',
            ),
            child: const Text('Send the email again'),
          ),
        ] else if (kind == 'phone') ...[
          gap(20),
          const SectionTitle('What’s your number?'),
          gap(20),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          gap(),
          const Text(
            'Phone verification is a demo step.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ] else ...[
          gap(20),
          const SectionTitle('Next, Let’s set up some\npermissions'),
          gap(26),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Get Notifications',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'We only send them for things like price alerts and trade confirmations.',
                style: TextStyle(color: muted, fontSize: 14),
              ),
            ),
            value: s.notifications,
            onChanged: (v) {
              s.notifications = v;
              s.save();
            },
          ),
          gap(),
          const Divider(),
          gap(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Log in with Face ID',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Access your account quickly and securely.',
                style: TextStyle(color: muted, fontSize: 14),
              ),
            ),
            value: s.faceId,
            onChanged: (v) {
              s.faceId = v;
              s.save();
            },
          ),
          gap(30),
          const Text(
            'Preferences only. This demo does not request system notification or biometric permissions.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ]),
    );
  }
}
