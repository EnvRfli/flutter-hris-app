import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../data/repositories/leave_repository.dart';
import '../../../data/models/work_schedule.dart';
import '../../../data/models/leave_request.dart';
import '../../../data/models/overtime_request.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scheduleRepository = ScheduleRepository();
  final _leaveRepository = LeaveRepository();

  List<WorkSchedule> _schedules = [];
  List<LeaveRequest> _leaveRequests = [];
  List<OvertimeRequest> _overtimeRequests = [];
  Map<String, int> _leaveBalance = {};

  bool _loadingSchedule = true;
  bool _loadingLeave = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final userId = authProvider.user!.id;

    if (mounted) {
      setState(() => _loadingSchedule = true);
    }

    final schedules =
        await _scheduleRepository.getUserSchedule(userId, days: 14);

    if (mounted) {
      setState(() {
        _schedules = schedules;
        _loadingSchedule = false;
      });
    }

    if (mounted) {
      setState(() => _loadingLeave = true);
    }

    final leaves = await _leaveRepository.getUserLeaves(userId);
    final overtimes = await _leaveRepository.getUserOvertimes(userId);
    final balance = await _leaveRepository.getLeaveBalance(userId);

    if (mounted) {
      setState(() {
        _leaveRequests = leaves;
        _overtimeRequests = overtimes;
        _leaveBalance = balance;
        _loadingLeave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Jadwal & Menu HR'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Jadwal Kerja'),
            Tab(text: 'Cuti & Izin'),
            Tab(text: 'Lembur'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScheduleTab(),
          _buildLeaveTab(),
          _buildOvertimeTab(),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    if (_loadingSchedule) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Kerja',
                            style: AppTextStyles.h5,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_schedules.where((s) => s.isWorkDay).length} hari kerja dalam 2 minggu',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Jadwal 14 Hari Kedepan',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 12),
          ..._schedules.map((schedule) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildScheduleCard(schedule),
              )),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(WorkSchedule schedule) {
    final isToday = DateFormat('yyyy-MM-dd').format(schedule.date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primaryContainer
                  : schedule.isWorkDay
                      ? AppColors.successContainer
                      : AppColors.greyExtraLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('EEE').format(schedule.date),
                  style: AppTextStyles.caption.copyWith(
                    color: isToday
                        ? AppColors.primary
                        : schedule.isWorkDay
                            ? AppColors.success
                            : AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd').format(schedule.date),
                  style: AppTextStyles.h5.copyWith(
                    color: isToday
                        ? AppColors.primary
                        : schedule.isWorkDay
                            ? AppColors.success
                            : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(schedule.date),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (schedule.isWorkDay)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule.startTimeString} - ${schedule.endTimeString}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${schedule.workDurationString})',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Hari Libur',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
              ],
            ),
          ),
          if (isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Hari Ini',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLeaveTab() {
    if (_loadingLeave) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sisa Cuti',
                  style: AppTextStyles.h5,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildLeaveBalanceItem(
                        'Cuti Tahunan',
                        _leaveBalance['annual'] ?? 0,
                        _leaveBalance['total'] ?? 12,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLeaveBalanceItem(
                        'Cuti Sakit',
                        _leaveBalance['sick'] ?? 0,
                        5,
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Ajukan Cuti',
                  Icons.event_busy,
                  AppColors.primary,
                  () {
                    _showComingSoonDialog('Ajukan Cuti');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Ajukan Izin',
                  Icons.edit_calendar,
                  AppColors.secondary,
                  () {
                    _showComingSoonDialog('Ajukan Izin');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Riwayat Pengajuan',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 12),
          if (_leaveRequests.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Belum ada pengajuan cuti/izin',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ..._leaveRequests.map((leave) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildLeaveCard(leave),
                )),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceItem(
      String label, int remaining, int total, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$remaining / $total',
            style: AppTextStyles.h4.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: remaining / total,
              backgroundColor: AppColors.greyLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(LeaveRequest leave) {
    Color statusColor;
    switch (leave.status) {
      case LeaveStatus.approved:
        statusColor = AppColors.success;
        break;
      case LeaveStatus.rejected:
        statusColor = AppColors.error;
        break;
      case LeaveStatus.pending:
        statusColor = AppColors.warning;
        break;
      case LeaveStatus.cancelled:
        statusColor = AppColors.grey;
        break;
    }

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  leave.typeLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  leave.statusLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${DateFormat('dd MMM').format(leave.startDate)} - ${DateFormat('dd MMM yyyy').format(leave.endDate)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${leave.durationDays} hari)',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            leave.reason,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildOvertimeTab() {
    if (_loadingLeave) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildActionButton(
            'Ajukan Lembur',
            Icons.work_history,
            AppColors.accent1,
            () {
              _showComingSoonDialog('Ajukan Lembur');
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Riwayat Lembur',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 12),
          if (_overtimeRequests.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Belum ada pengajuan lembur',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ..._overtimeRequests.map((overtime) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildOvertimeCard(overtime),
                )),
        ],
      ),
    );
  }

  Widget _buildOvertimeCard(OvertimeRequest overtime) {
    Color statusColor;
    switch (overtime.status) {
      case OvertimeStatus.approved:
        statusColor = AppColors.success;
        break;
      case OvertimeStatus.rejected:
        statusColor = AppColors.error;
        break;
      case OvertimeStatus.pending:
        statusColor = AppColors.warning;
        break;
      case OvertimeStatus.cancelled:
        statusColor = AppColors.grey;
        break;
    }

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  DateFormat('dd MMMM yyyy').format(overtime.date),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  overtime.statusLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${overtime.startTimeString} - ${overtime.endTimeString}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${overtime.durationString})',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            overtime.reason,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('Fitur $feature akan segera hadir!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
