import 'package:flutter/material.dart';

import '../widgets/home_body.dart';
import 'inactivity_wrapper.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return InactivityWrapper(
      timeout: const Duration(seconds: 15),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
          actions: [_LogoutButton()],
        ),
        body: const HomeBody(),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      },
    );
  }
}