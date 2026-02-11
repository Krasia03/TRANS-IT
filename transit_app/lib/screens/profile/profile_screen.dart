import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final user = auth.user;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'User',
                          style: AppTheme.headingMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: AppTheme.bodyMedium,
                        ),
                        if (user?.phone != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            user!.phone!,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            // Edit profile
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Menu items
                _buildMenuItem(
                  Icons.local_shipping_outlined,
                  'My Shipments',
                  'View all your shipments',
                  () {},
                ),
                _buildMenuItem(
                  Icons.location_on_outlined,
                  'Saved Addresses',
                  'Manage your saved addresses',
                  () {},
                ),
                _buildMenuItem(
                  Icons.payment_outlined,
                  'Payment Methods',
                  'Manage payment options',
                  () {},
                ),
                _buildMenuItem(
                  Icons.notifications_outlined,
                  'Notifications',
                  'Manage notification preferences',
                  () {},
                ),
                _buildMenuItem(
                  Icons.help_outline,
                  'Help & Support',
                  'Get help with your orders',
                  () {},
                ),
                _buildMenuItem(
                  Icons.info_outline,
                  'About',
                  'App information',
                  () {},
                ),
                const SizedBox(height: 20),
                
                // Logout button
                CustomButton(
                  text: 'Logout',
                  onPressed: () => _showLogoutDialog(context),
                  backgroundColor: AppTheme.errorColor,
                ),
                const SizedBox(height: 20),
                
                // App version
                const Text(
                  'Version 1.0.0',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
