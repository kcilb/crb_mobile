import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 50,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "John Mwangi",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              "Member since Jan 2018",
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          _buildPasswordOption(
            context,
            color: Colors.pink.shade200,
            title: 'Repeated Passwords',
            subtitle: '1 out of 8 weblogins',
            onTap: () {},
          ),
          _buildPasswordOption(
            context,
            color: Colors.blue.shade300,
            title: 'Weak Passwords',
            subtitle: '2 out of 6 weblogins',
            onTap: () {},
          ),
          _buildPasswordOption(
            context,
            color: Colors.orange.shade300,
            title: 'Old Passwords',
            subtitle: '4 out of 10 weblogins',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordOption(
    BuildContext context, {
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.3),
            child: Center(
              child: Text(
                title.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onTap, child: const Text('Edit')),
        ],
      ),
    );
  }
}
