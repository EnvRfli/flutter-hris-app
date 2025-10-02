import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../state/providers/clock_provider.dart';
import '../../../data/models/clock_record.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
      clockProvider.loadHistory(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clockProvider = context.watch<ClockProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: _buildBody(clockProvider),
      ),
    );
  }

  Widget _buildBody(ClockProvider clockProvider) {
    if (clockProvider.state == ClockState.loading &&
        clockProvider.history.isEmpty) {
      return const LoadingView(message: 'Loading history...');
    }

    if (clockProvider.state == ClockState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load history',
                style: AppTextStyles.h5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                clockProvider.errorMessage ?? 'An error occurred',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (clockProvider.history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: AppColors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No History Yet',
                style: AppTextStyles.h5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your attendance history will appear here',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: clockProvider.history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final record = clockProvider.history[index];
        return _buildHistoryCard(record);
      },
    );
  }

  Widget _buildHistoryCard(ClockRecord record) {
    final isCompleted = record.clockOutTime != null;
    final date = record.clockInTime;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: AppColors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(date),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(date),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatusBadge(
                label: isCompleted ? 'Completed' : 'Pending',
                type: isCompleted ? BadgeType.success : BadgeType.warning,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Clock In/Out Details
          Row(
            children: [
              Expanded(
                child: _buildTimeDetail(
                  icon: Icons.login,
                  iconColor: AppColors.green,
                  label: 'Clock In',
                  time: record.clockInTime,
                  location: record.clockInLocation,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppColors.greyLight,
              ),
              Expanded(
                child: _buildTimeDetail(
                  icon: Icons.logout,
                  iconColor: AppColors.red,
                  label: 'Clock Out',
                  time: record.clockOutTime,
                  location: record.clockOutLocation,
                ),
              ),
            ],
          ),

          // Work Duration
          if (isCompleted) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer,
                  color: AppColors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Work Duration: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  record.workDurationString,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeDetail({
    required IconData icon,
    required Color iconColor,
    required String label,
    DateTime? time,
    String? location,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time != null ? DateFormat('HH:mm').format(time) : '-',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: time != null ? AppColors.textPrimary : AppColors.grey,
          ),
        ),
        if (location != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 10,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  location,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
