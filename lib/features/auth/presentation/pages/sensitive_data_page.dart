import 'package:flutter/material.dart';
import '../../../../core/security/sensitive_data_processor.dart';

class SensitiveDataPage extends StatefulWidget {
  const SensitiveDataPage({super.key});

  @override
  State<SensitiveDataPage> createState() => _SensitiveDataPageState();
}

class _SensitiveDataPageState extends State<SensitiveDataPage> {
  final _inputController = TextEditingController();
  String _processedResult = "";
  String _deprocessedResult = "";

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _processData() {
    setState(() {
      _processedResult = SensitiveDataProcessor.process(_inputController.text);
      _deprocessedResult = "";
    });
  }

  void _deprocessData() {
    if (_processedResult.isNotEmpty) {
      setState(() {
        _deprocessedResult = SensitiveDataProcessor.deprocess(_processedResult);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procesador de Datos Sensibles'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.enhanced_encryption,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Procesamiento Seguro de PII',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa datos sensibles para simular su procesamiento de seguridad.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Información Sensible (ej. PIN, Tarjeta)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _processData,
                    icon: const Icon(Icons.lock),
                    label: const Text('Procesar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deprocessData,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Deshacer'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_processedResult.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Resultado Procesado (Base64):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  _processedResult,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
                ),
              ),
            ],
            if (_deprocessedResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Resultado Revertido (Original):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: SelectableText(
                  _deprocessedResult,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
