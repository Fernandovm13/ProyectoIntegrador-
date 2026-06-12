import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/security/screen_protection_service.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/security/fcm_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = true;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeSecurityAndData();
    FcmService.onWipeTriggered.addListener(_onWipeReceived);
  }

  @override
  void dispose() {
    FcmService.onWipeTriggered.removeListener(_onWipeReceived);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    ScreenProtectionService.disable();
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

  Future<void> _initializeSecurityAndData() async {
    await ScreenProtectionService.enable();
    
    final data = await SecureStorageService.getSensitiveUserData();
    final hasSensitiveData = data.values.any((value) => value != null);
    if (!hasSensitiveData) {
      await SecureStorageService.populateSensitiveUserData();
    }

    await _loadDataAndToken();

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadDataAndToken() async {
    final token = await FcmService.getDeviceToken();
    final data = await SecureStorageService.getSensitiveUserData();
    
    if (!mounted) return;
    setState(() {
      _fcmToken = token;
      _nameController.text = data['fullname'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
    });
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
        title: const Text('Datos de Usuario'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Número Telefónico',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección Física',
                      prefixIcon: Icon(Icons.home),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await SecureStorageService.populateSensitiveUserData();
                      await _loadDataAndToken();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Campos rellenados automáticamente')),
                      );
                    },
                    child: const Text('Rellenar'),
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