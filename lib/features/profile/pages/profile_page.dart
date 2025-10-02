import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../routes/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          AppCard(
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.blue.withOpacity(0.1),
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  user?.name ?? 'User',
                  style: AppTextStyles.h4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // Email
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                const Divider(height: 1),
                const SizedBox(height: 20),

                // Info Rows
                _buildInfoRow(
                  icon: Icons.work_outline,
                  label: 'Position',
                  value: user?.position ?? '-',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.business_outlined,
                  label: 'Department',
                  value: user?.department ?? '-',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Options
          Text(
            'Settings',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 12),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildMenuTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    // TODO: Navigate to edit profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit Profile - Coming Soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {
                    // TODO: Navigate to change password
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Change Password - Coming Soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuTile(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    // TODO: Navigate to notifications settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications - Coming Soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildMenuTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help and support',
                  onTap: () {
                    // TODO: Navigate to help
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help & Support - Coming Soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About Section
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: AppTextStyles.h5,
                ),
                const SizedBox(height: 12),
                _buildAboutRow('Version', '1.0.0'),
                const SizedBox(height: 8),
                _buildAboutRow('Build', '100'),
                const SizedBox(height: 8),
                _buildAboutRow('Environment', 'Development'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          PrimaryButton(
            text: 'Logout',
            icon: Icons.logout,
            onPressed: () => _handleLogout(context),
            backgroundColor: AppColors.red,
          ),
          const SizedBox(height: 16),

          // Footer Text
          Center(
            child: Text(
              'Made with ❤️ by Flutter',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 24),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildAboutRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        context.go(AppRouter.login);
      }
    }
  }
}
