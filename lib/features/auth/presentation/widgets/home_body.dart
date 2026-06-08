import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SessionIcon(),
            SizedBox(height: 16),
            _SessionTitle(),
            SizedBox(height: 12),
            _SessionMessage(),
          ],
        ),
      ),
    );
  }
}

class _SessionIcon extends StatelessWidget {
  const _SessionIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.check_circle_outline,
      size: 80,
      color: Colors.green,
    );
  }
}

class _SessionTitle extends StatelessWidget {
  const _SessionTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sesión Iniciada Correctamente',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SessionMessage extends StatelessWidget {
  const _SessionMessage();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Bienvenido. Tu sesión se cerrará automáticamente '
      'si no hay actividad por un periodo de tiempo.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    );
  }
}
