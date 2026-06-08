import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController passController;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.userController,
    required this.passController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _LoginTitle(),
        const SizedBox(height: 24),
        _UsernameField(controller: userController),
        const SizedBox(height: 16),
        _PasswordField(controller: passController),
        const SizedBox(height: 24),
        _LoginButton(onPressed: onLogin),
      ],
    );
  }
}

class _LoginTitle extends StatelessWidget {
  const _LoginTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Iniciar sesión',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Usuario',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Entrar'),
      ),
    );
  }
}
