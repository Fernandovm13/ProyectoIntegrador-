import 'package:flutter/material.dart';

class GpsBlockedScreen extends StatelessWidget {
  const GpsBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BlockedIcon(),
              SizedBox(height: 24),
              _BlockedTitle(),
              SizedBox(height: 16),
              _BlockedMessage(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockedIcon extends StatelessWidget {
  const _BlockedIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_off,
      size: 100,
      color: Colors.red,
    );
  }
}

class _BlockedTitle extends StatelessWidget {
  const _BlockedTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Validación de Seguridad',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}

class _BlockedMessage extends StatelessWidget {
  const _BlockedMessage();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'La aplicación requiere acceso a la ubicación real. '
      'No se puede continuar si los permisos están denegados, '
      'si el GPS está apagado o si se detecta una ubicación '
      'simulada (Fake GPS) activa.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18),
    );
  }
}
