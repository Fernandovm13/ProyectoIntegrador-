import 'package:flutter/material.dart';

import '../../../../core/security/fake_gps_service.dart';
import '../../../../core/security/screen_protection_service.dart';

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

  Future<void> _initializeSecurity() async {

    await ScreenProtectionService.enable();

    final isFakeGps =
    await FakeGpsService.isFakeGpsEnabled();

    if (!mounted) return;

    setState(() {

      _fakeGpsDetected = isFakeGps;

      _isLoading = false;

    });
  }

  @override
  void dispose() {

    _userController.dispose();

    _passController.dispose();

    ScreenProtectionService.disable();

    super.dispose();
  }

  void _login() {

    final user = _userController.text.trim();

    final pass = _passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Llena usuario y contraseña',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_fakeGpsDetected) {

      return const Scaffold(

        body: Center(

          child: Padding(

            padding: EdgeInsets.all(24),

            child: Column(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.location_off,
                  size: 100,
                  color: Colors.red,
                ),

                SizedBox(height: 24),

                Text(

                  'Validación de Seguridad',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                SizedBox(height: 16),

                Text(

                  'La aplicación requiere acceso a la ubicación real. '
                      'No se puede continuar si los permisos están denegados, '
                      'si el GPS está apagado o si se detecta una ubicación '
                      'simulada (Fake GPS) activa.',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Center(

            child: ConstrainedBox(

              constraints: const BoxConstraints(
                maxWidth: 420,
              ),

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  const Text(

                    'Iniciar sesión',

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(

                    controller: _userController,

                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(

                    controller: _passController,

                    obscureText: true,

                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed: _login,

                      child: const Text('Entrar'),
                    ),
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