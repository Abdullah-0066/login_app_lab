import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. Check the form fields first. Stop if something is wrong.
    if (!_formKey.currentState!.validate()) return;

    // 2. Show loading spinner.
    setState(() => _loading = true);

    // 3. AUTHENTICATION: ask the service "is this person who they say?"
    final success = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return; // screen was closed while we waited
    setState(() => _loading = false);

    // 4. Go to Home, or show an error.
    if (success) {
      // pushReplacement: the Back button will NOT return to login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.lock_outline, size: 72, color: Colors.indigo),
                const SizedBox(height: 12),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // EMAIL FIELD
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null; // null = no error
                  },
                ),
                const SizedBox(height: 16),

                // PASSWORD FIELD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _hidePassword = !_hidePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    if (value.length < 4) return 'Password must be at least 4 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // LOGIN BUTTON (or spinner while loading)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton(
                          onPressed: _login,
                          child: const Text('Login', style: TextStyle(fontSize: 16)),
                        ),
                ),
                const SizedBox(height: 24),

                // Hint for the demo
                const Text(
                  'Demo accounts (password: 1234)\nadmin@test.com  •  abdullah@test.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
