import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AUTHORIZATION GUARD:
    // Even if someone reaches this screen, we check the role again.
    // (Hiding a button is not enough!)
    if (!AuthService.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, size: 64, color: Colors.red),
              SizedBox(height: 12),
              Text('You are not allowed to see this page.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(leading: Icon(Icons.people), title: Text('Manage Users')),
          ListTile(leading: Icon(Icons.bar_chart), title: Text('View Reports')),
          ListTile(leading: Icon(Icons.settings), title: Text('App Settings')),
        ],
      ),
    );
  }
}
