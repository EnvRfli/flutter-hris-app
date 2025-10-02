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
        return AppColors.successContainer;
      case BadgeType.warning:
        return AppColors.warningContainer;
      case BadgeType.error:
        return AppColors.errorContainer;
      case BadgeType.info:
        return AppColors.infoContainer;
      case BadgeType.neutral:
        return AppColors.surfaceVariant;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.successDark;
      case BadgeType.warning:
        return AppColors.warningDark;
      case BadgeType.error:
        return AppColors.errorDark;
      case BadgeType.info:
        return AppColors.infoDark;
      case BadgeType.neutral:
        return AppColors.greyDark;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.success;
      case BadgeType.warning:
        return AppColors.warning;
      case BadgeType.error:
        return AppColors.error;
      case BadgeType.info:
        return AppColors.info;
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
