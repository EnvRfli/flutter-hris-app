import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../state/providers/clock_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final authProvider = context.read<AuthProvider>();
    final clockProvider = context.read<ClockProvider>();

    if (authProvider.user != null) {
      clockProvider.loadTodayRecord(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final clockProvider = context.watch<ClockProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome Card with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.white.withOpacity(0.2),
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back,',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.name ?? 'User',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy')
                              .format(DateTime.now()),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Today's Status Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Status',
                        style: AppTextStyles.h5,
                      ),
                      if (clockProvider.hasClockedInToday)
                        StatusBadge(
                          label: clockProvider.hasClockedOutToday
                              ? 'Completed'
                              : 'In Progress',
                          type: clockProvider.hasClockedOutToday
                              ? BadgeType.success
                              : BadgeType.warning,
                        )
                      else
                        const StatusBadge(
                          label: 'Not Started',
                          type: BadgeType.neutral,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _buildStatusRow(
                    icon: Icons.login,
                    iconColor: AppColors.success,
                    label: 'Clock In',
                    value: clockProvider.todayRecord?.clockInTime != null
                        ? DateFormat('HH:mm')
                            .format(clockProvider.todayRecord!.clockInTime)
                        : '-',
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    icon: Icons.logout,
                    iconColor: AppColors.error,
                    label: 'Clock Out',
                    value: clockProvider.todayRecord?.clockOutTime != null
                        ? DateFormat('HH:mm')
                            .format(clockProvider.todayRecord!.clockOutTime!)
                        : '-',
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    icon: Icons.timer,
                    iconColor: AppColors.primary,
                    label: 'Work Duration',
                    value: clockProvider.todayRecord?.workDurationString ?? '-',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTextStyles.h5,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.access_time,
                    label: 'Clock In/Out',
                    color: AppColors.primary,
                    onTap: () {
                      // Navigate to clock page
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.history,
                    label: 'History',
                    color: AppColors.secondary,
                    onTap: () {
                      // Navigate to history page
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.person,
                    label: 'Profile',
                    color: AppColors.accent1,
                    onTap: () {
                      // Navigate to profile page
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.settings,
                    label: 'Settings',
                    color: AppColors.grey,
                    onTap: () {
                      // Navigate to settings page
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
