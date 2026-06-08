import 'package:flutter/material.dart';

import '../../../../core/security/fake_gps_service.dart';
import '../../../../core/security/screen_protection_service.dart';

import '../widgets/gps_blocked_screen.dart';
import '../widgets/login_form.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  bool _isLoading = true;
  bool _fakeGpsDetected = false;

  @override
  void initState() {
    super.initState();
    _initializeSecurity();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    ScreenProtectionService.disable();
    super.dispose();
  }

  Future<void> _initializeSecurity() async {
    await ScreenProtectionService.enable();

    final isFakeGps = await FakeGpsService.isFakeGpsEnabled();

    if (!mounted) return;

    setState(() {
      _fakeGpsDetected = isFakeGps;
      _isLoading = false;
    });
  }

  void _login() {
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Llena usuario y contraseña')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_fakeGpsDetected) {
      return const GpsBlockedScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: LoginForm(
                userController: _userController,
                passController: _passController,
                onLogin: _login,
              ),
            ),
          ),
        ),
      ),
    );
  }
}