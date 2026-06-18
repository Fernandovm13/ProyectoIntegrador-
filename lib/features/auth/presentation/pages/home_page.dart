import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/security/fcm_service.dart';
import 'login_page.dart';
import 'sensitive_data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = true;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _loadSensitiveData();
    FcmService.onWipeTriggered.addListener(_onWipeReceived);
  }

  @override
  void dispose() {
    FcmService.onWipeTriggered.removeListener(_onWipeReceived);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onWipeReceived() {
    if (mounted) {
      setState(() {
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _addressController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Datos eliminados remotamente por orden de FCM!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadSensitiveData() async {
    final data = await SecureStorageService.getSensitiveUserData();
    final hasSensitiveData = data.values.any((value) => value != null);
    if (!hasSensitiveData) {
      await SecureStorageService.populateSensitiveUserData();
    }

    final token = await FcmService.getDeviceToken();
    final updatedData = await SecureStorageService.getSensitiveUserData();

    if (!mounted) return;

    setState(() {
      _fcmToken = token;
      _nameController.text = updatedData['fullname'] ?? '';
      _emailController.text = updatedData['email'] ?? '';
      _phoneController.text = updatedData['phone'] ?? '';
      _addressController.text = updatedData['address'] ?? '';
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Inicio - Perfil Seguro'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Cerrar Sesión',
          onPressed: _handleLogout,
        ),
        actions: [
          if (_fcmToken != null)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copiar Token FCM',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _fcmToken!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token FCM copiado al portapapeles')),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Información Sensible Guardada',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Número Telefónico',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Dirección Física',
                      prefixIcon: Icon(Icons.home),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SensitiveDataPage()),
                      );
                    },
                    icon: const Icon(Icons.security),
                    label: const Text('Ir a Procesador de Datos'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}