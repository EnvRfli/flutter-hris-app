import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../state/providers/clock_provider.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../data/models/work_schedule.dart';
import '../../../routes/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scheduleRepository = ScheduleRepository();
  WorkSchedule? _todaySchedule;
  bool _loadingSchedule = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final clockProvider = context.read<ClockProvider>();

    if (authProvider.user != null) {
      clockProvider.loadTodayRecord(authProvider.user!.id);

      // Load today's schedule
      if (mounted) {
        setState(() => _loadingSchedule = true);
      }

      final schedule =
          await _scheduleRepository.getTodaySchedule(authProvider.user!.id);

      if (mounted) {
        setState(() {
          _todaySchedule = schedule;
          _loadingSchedule = false;
        });
      }
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

            // Today's Schedule Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Jadwal Hari Ini',
                        style: AppTextStyles.h5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  if (_loadingSchedule)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_todaySchedule == null || !_todaySchedule!.isWorkDay)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.weekend,
                              size: 48,
                              color: AppColors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hari Libur',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildScheduleItem(
                                icon: Icons.login,
                                label: 'Masuk',
                                time: _todaySchedule!.startTimeString,
                                color: AppColors.success,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: AppColors.greyLight,
                            ),
                            Expanded(
                              child: _buildScheduleItem(
                                icon: Icons.logout,
                                label: 'Pulang',
                                time: _todaySchedule!.endTimeString,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        if (_todaySchedule!.breakStart != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.infoContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.free_breakfast,
                                  color: AppColors.info,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Istirahat: ${_todaySchedule!.breakStartString} - ${_todaySchedule!.breakEndString}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.infoDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Clock In/Out Buttons
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance Today',
                        style: AppTextStyles.h5,
                      ),
                      if (clockProvider.hasClockedInToday)
                        StatusBadge(
                          label: clockProvider.hasClockedOutToday
                              ? 'Selesai'
                              : 'Sedang Bekerja',
                          type: clockProvider.hasClockedOutToday
                              ? BadgeType.success
                              : BadgeType.warning,
                        )
                      else
                        const StatusBadge(
                          label: 'Belum Masuk',
                          type: BadgeType.neutral,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Clock In',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              clockProvider.todayRecord?.clockInTime != null
                                  ? DateFormat('HH:mm').format(
                                      clockProvider.todayRecord!.clockInTime)
                                  : '-',
                              style: AppTextStyles.h5.copyWith(
                                color: clockProvider.todayRecord?.clockInTime !=
                                        null
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.greyLight,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Clock Out',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              clockProvider.todayRecord?.clockOutTime != null
                                  ? DateFormat('HH:mm').format(
                                      clockProvider.todayRecord!.clockOutTime!)
                                  : '-',
                              style: AppTextStyles.h5.copyWith(
                                color:
                                    clockProvider.todayRecord?.clockOutTime !=
                                            null
                                        ? AppColors.error
                                        : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.greyLight,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Durasi',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              clockProvider.todayRecord?.workDurationString ??
                                  '-',
                              style: AppTextStyles.h5.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!clockProvider.hasClockedInToday)
                    PrimaryButton(
                      text: 'Clock In',
                      icon: Icons.login,
                      onPressed: _handleClockIn,
                      backgroundColor: AppColors.success,
                    )
                  else if (!clockProvider.hasClockedOutToday)
                    PrimaryButton(
                      text: 'Clock Out',
                      icon: Icons.logout,
                      onPressed: _handleClockOut,
                      backgroundColor: AppColors.error,
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.successContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kerja hari ini sudah selesai!',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.successDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Text(
              'Menu Lainnya',
              style: AppTextStyles.h5,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.history,
                    label: 'Riwayat',
                    color: AppColors.primary,
                    onTap: () {
                      context.go('/history');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.person,
                    label: 'Profile',
                    color: AppColors.secondary,
                    onTap: () {
                      context.go('/profile');
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

  Widget _buildScheduleItem({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: AppTextStyles.h5.copyWith(
            color: color,
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
