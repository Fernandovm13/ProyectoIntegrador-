import 'package:flutter/material.dart';

class SavedSessionCard extends StatelessWidget {
  final String? token;
  final String? inactivityTime;
  final VoidCallback onClear;

  const SavedSessionCard({
    super.key,
    required this.token,
    required this.inactivityTime,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (token == null && inactivityTime == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(),
            const Divider(),
            _TokenRow(token: token),
            const SizedBox(height: 4),
            _TimeRow(inactivityTime: inactivityTime),
            const SizedBox(height: 8),
            _ClearButton(onClear: onClear),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.lock_outline, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          'Sesión Inactiva Guardada (Encriptada)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}

class _TokenRow extends StatelessWidget {
  final String? token;

  const _TokenRow({required this.token});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Token: $token',
      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String? inactivityTime;

  const _TimeRow({required this.inactivityTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hora: $inactivityTime',
      style: const TextStyle(fontSize: 12),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final VoidCallback onClear;

  const _ClearButton({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onClear,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      label: const Text(
        'Limpiar almacén encriptado',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
