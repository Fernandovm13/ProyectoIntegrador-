import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/security/secure_storage_service.dart';
import 'login_page.dart';

class InactivityWrapper extends StatefulWidget {
  final Widget child;
  final Duration timeout;

  const InactivityWrapper({
    super.key,
    required this.child,
    this.timeout = const Duration(seconds: 15),
  });

  @override
  State<InactivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<InactivityWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, _handleInactivity);
  }

  void _handleInactivity() async {
    final timestamp = DateTime.now().toIso8601String();
    // Save mock token and the inactivity timestamp in the secure storage
    await SecureStorageService.saveSessionData(
      'secure_token_session_inactive_777',
      timestamp,
    );

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tu sesión fue cerrada por inactividad.'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _handleInteraction() {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handleInteraction(),
      onPointerMove: (_) => _handleInteraction(),
      onPointerUp: (_) => _handleInteraction(),
      child: widget.child,
    );
  }
}
