import 'package:app_lojinha/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: FormResetPassword(),
      ),
    );
  }
}

class FormResetPassword extends StatefulWidget {
  const FormResetPassword({super.key});

  @override
  State<FormResetPassword> createState() => _FormResetPasswordState();
}

class _FormResetPasswordState extends State<FormResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    String? error;
    try {
      error = await (auth as dynamic).resetPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text,
      ) as String?;
    } on NoSuchMethodError {
      error = 'Método resetPassword não implementado no AuthProvider';
    }

    if (error == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) => v!.contains('@') ? null : 'E-mail inválido',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
                validator: (v) => v!.length >= 6 ? null : 'Senha deve conter ao menos 6 caracteres',
              ),
              const SizedBox(height: 20),
              auth.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Redefinir Senha'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

