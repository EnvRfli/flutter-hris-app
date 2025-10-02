import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum BadgeType { success, warning, error, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final bool isOutlined;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.neutral,
    this.isOutlined = false,
  });

  Color _getBackgroundColor() {
    if (isOutlined) return Colors.transparent;

    switch (type) {
      case BadgeType.success:
        return AppColors.green.withOpacity(0.1);
      case BadgeType.warning:
        return AppColors.yellow.withOpacity(0.1);
      case BadgeType.error:
        return AppColors.red.withOpacity(0.1);
      case BadgeType.info:
        return AppColors.blue.withOpacity(0.1);
      case BadgeType.neutral:
        return AppColors.grey.withOpacity(0.1);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.greenDark;
      case BadgeType.warning:
        return AppColors.yellowDark;
      case BadgeType.error:
        return AppColors.redDark;
      case BadgeType.info:
        return AppColors.blueDark;
      case BadgeType.neutral:
        return AppColors.greyDark;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.green;
      case BadgeType.warning:
        return AppColors.yellow;
      case BadgeType.error:
        return AppColors.red;
      case BadgeType.info:
        return AppColors.blue;
      case BadgeType.neutral:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
        border: isOutlined
            ? Border.all(color: _getBorderColor(), width: 1.5)
            : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
