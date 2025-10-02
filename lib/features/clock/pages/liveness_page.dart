import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../state/providers/auth_provider.dart';
import '../../../state/providers/clock_provider.dart';

class LivenessPage extends StatefulWidget {
  const LivenessPage({super.key});

  @override
  State<LivenessPage> createState() => _LivenessPageState();
}

class _LivenessPageState extends State<LivenessPage> {
  bool _isProcessing = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _startLivenessCheck();
  }

  Future<void> _startLivenessCheck() async {
    // Simulate liveness check for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });

    // Process clock in/out
    await _processClock();

    // Wait a bit to show success message
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigate back to clock page
    context.pop();
  }

  Future<void> _processClock() async {
    final authProvider = context.read<AuthProvider>();
    final clockProvider = context.read<ClockProvider>();

    if (authProvider.user == null) return;

    final userId = authProvider.user!.id;
    final location = 'Office - Jakarta'; // Dummy location

    if (!clockProvider.hasClockedInToday) {
      // Clock In
      await clockProvider.clockIn(userId, location);
    } else if (!clockProvider.hasClockedOutToday) {
      // Clock Out
      final recordId = clockProvider.todayRecord!.id;
      await clockProvider.clockOut(recordId, location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Liveness Check'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon/Animation
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSuccess
                      ? AppColors.successContainer
                      : AppColors.primaryContainer,
                  border: Border.all(
                    color: _isSuccess ? AppColors.success : AppColors.primary,
                    width: 3,
                  ),
                ),
                child: _isProcessing
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      )
                    : Icon(
                        _isSuccess ? Icons.check_circle : Icons.error,
                        size: 100,
                        color: _isSuccess ? AppColors.success : AppColors.error,
                      ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                _isProcessing
                    ? 'Verifying...'
                    : _isSuccess
                        ? 'Verification Successful!'
                        : 'Verification Failed',
                style: AppTextStyles.h3.copyWith(
                  color: _isSuccess ? AppColors.success : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                _isProcessing
                    ? 'Please wait while we verify your identity...'
                    : _isSuccess
                        ? 'Your attendance has been recorded successfully.'
                        : 'Unable to verify your identity. Please try again.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Info
              if (_isProcessing)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.warningDark,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This is a placeholder for liveness detection. In production, this would use face recognition or biometric verification.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warningDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
