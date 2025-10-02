import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../state/providers/clock_provider.dart';
import '../../../routes/app_router.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
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

  Future<void> _handleClockIn() async {
    context.push(AppRouter.liveness);
  }

  Future<void> _handleClockOut() async {
    context.push(AppRouter.liveness);
  }

  @override
  Widget build(BuildContext context) {
    final clockProvider = context.watch<ClockProvider>();
    final todayRecord = clockProvider.todayRecord;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clock In/Out'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date Card
            AppCard(
              color: AppColors.blue,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('EEEE').format(DateTime.now()),
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMMM yyyy').format(DateTime.now()),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status Card
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
                      _buildStatusBadge(clockProvider),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Clock In
                  _buildTimeRow(
                    icon: Icons.login,
                    iconColor: AppColors.green,
                    label: 'Clock In',
                    time: todayRecord?.clockInTime,
                    location: todayRecord?.clockInLocation,
                  ),
                  const SizedBox(height: 16),

                  // Clock Out
                  _buildTimeRow(
                    icon: Icons.logout,
                    iconColor: AppColors.red,
                    label: 'Clock Out',
                    time: todayRecord?.clockOutTime,
                    location: todayRecord?.clockOutLocation,
                  ),
                  const SizedBox(height: 16),

                  // Work Duration
                  if (todayRecord != null) ...[
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.timer,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Work Duration',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          todayRecord.workDurationString,
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            if (!clockProvider.hasClockedInToday)
              PrimaryButton(
                text: 'Clock In',
                icon: Icons.login,
                onPressed: _handleClockIn,
                backgroundColor: AppColors.green,
              )
            else if (!clockProvider.hasClockedOutToday)
              PrimaryButton(
                text: 'Clock Out',
                icon: Icons.logout,
                onPressed: _handleClockOut,
                backgroundColor: AppColors.red,
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.green.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.green,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You have completed your work for today!',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.greenDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Info Text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.yellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.yellow.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.yellowDark,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Clock In/Out button will navigate to Liveness Check (3 seconds simulation)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.yellowDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ClockProvider clockProvider) {
    if (!clockProvider.hasClockedInToday) {
      return const StatusBadge(
        label: 'Not Started',
        type: BadgeType.neutral,
      );
    } else if (!clockProvider.hasClockedOutToday) {
      return const StatusBadge(
        label: 'In Progress',
        type: BadgeType.warning,
      );
    } else {
      return const StatusBadge(
        label: 'Completed',
        type: BadgeType.success,
      );
    }
  }

  Widget _buildTimeRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    DateTime? time,
    String? location,
  }) {
    return Column(
      children: [
        Row(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Text(
              time != null ? DateFormat('HH:mm').format(time) : '-',
              style: AppTextStyles.h5.copyWith(
                color: time != null ? iconColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
