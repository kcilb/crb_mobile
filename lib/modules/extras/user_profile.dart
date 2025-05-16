import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample member data (in a real app, this would come from API/database)
  final Map<String, dynamic> memberProfile = {
    'name': 'John Mwangi',
    'email': 'john.mwangi@example.com',
    'phone': '+254712345678',
    'membershipId': 'MEM-2023-00145',
    'membershipType': 'Premium',
    'joinDate': 'Jan 2018',
    'address': '123 Main St',
    'profilePhoto': 'assets/images/default_photo.png',
  };

  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
          child: Column(
            children: [
              // Profile header section
              Container(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: Column(
                  children: [
                    // Profile photo with border
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(memberProfile['profilePhoto']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      memberProfile['name'],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${memberProfile['membershipType']} Member since ${memberProfile['joinDate']}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _showDetails ? 'Hide Details' : 'View Profile',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile details section
              if (_showDetails)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        Icons.email,
                        'Email',
                        memberProfile['email'],
                      ),
                      _buildDetailItem(
                        Icons.phone,
                        'Phone',
                        memberProfile['phone'],
                      ),
                      _buildDetailItem(
                        Icons.card_membership,
                        'Membership ID',
                        memberProfile['membershipId'],
                      ),
                      _buildDetailItem(
                        Icons.home,
                        'Address',
                        memberProfile['address'],
                      ),
                    ],
                  ),
                ),

              // Profile options list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 16),
                      _buildProfileOption(
                        context,
                        icon: Icons.payment,
                        title: 'Payment Methods',
                        onTap: () => _navigateToPaymentMethods(),
                      ),
                      _buildProfileOption(
                        context,
                        icon: Icons.history,
                        title: 'Activity History',
                        onTap: () => _navigateToActivityHistory(),
                      ),
                      _buildProfileOption(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () => _navigateToSettings(),
                      ),
                      _buildProfileOption(
                        context,
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () => _navigateToHelp(),
                      ),
                      _buildProfileOption(
                        context,
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: _confirmLogout,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.white.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.grey[800]),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: color ?? Colors.grey[800],
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateToEditProfile() {
    // Navigation to edit profile screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Edit Profile')),
              body: const Center(child: Text('Edit Profile Screen')),
            ),
      ),
    );
  }

  void _navigateToPaymentMethods() {
    // Navigation to payment methods screen
  }

  void _navigateToActivityHistory() {
    // Navigation to activity history screen
  }

  void _navigateToSettings() {
    // Navigation to settings screen
  }

  void _navigateToHelp() {
    // Navigation to help screen
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                  // Add actual logout logic here
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
