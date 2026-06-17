import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/security/screen_protection_service.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/security/fcm_service.dart';
import '../../../../core/security/usb_debugging_service.dart';

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
  bool _isBlocked = false;
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
    final isUsbDebuggingEnabled = await UsbDebuggingService.isUsbDebuggingEnabled();
    if (isUsbDebuggingEnabled) {
      if (mounted) {
        setState(() {
          _isBlocked = true;
          _isLoading = false;
        });
        _showBlockingDialog();
      }
      return;
    }


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

  void _showBlockingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.security, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Bloqueo de Seguridad'),
                ),
              ],
            ),
            content: const Text(
              'Se ha detectado que la Depuración USB está activa. '
              'Por políticas de seguridad de la aplicación, debe desactivar esta opción en los ajustes del sistema para poder continuar.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Cerrar Aplicación', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
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
    if (_isBlocked) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, size: 80, color: Colors.redAccent),
                SizedBox(height: 16),
                Text(
                  'Entorno no seguro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'La aplicación está bloqueada por políticas de seguridad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
    }

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