import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hello, ${user.name} 👋',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: ${user.email}'),
            Text('Role: ${user.role}'),
            const SizedBox(height: 32),

            // Everyone can see this
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('My Profile'),
                subtitle: Text('Every logged-in user can see this'),
              ),
            ),

            // AUTHORIZATION: only admins see this button
            if (AuthService.isAdmin)
              Card(
                color: Colors.amber.shade100,
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Admin Panel'),
                  subtitle: const Text('Only admins can see this'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminScreen()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
