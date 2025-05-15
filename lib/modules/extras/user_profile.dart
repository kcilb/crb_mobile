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
          _buildProfileOption(
            context,
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Add logout functionality here
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Logged out")));
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
