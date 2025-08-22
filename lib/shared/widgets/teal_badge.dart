import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TealBadgeType { primary, secondary, success, warning, error, info }
enum TealBadgeSize { small, medium, large }

class TealBadge extends StatelessWidget {
  final String? text;
  final int? count;
  final Widget? child;
  final TealBadgeType type;
  final TealBadgeSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final bool showZero;
  final int? maxCount;
  final Widget? icon;
  final bool isVisible;

  const TealBadge({
    super.key,
    this.text,
    this.count,
    this.child,
    this.type = TealBadgeType.primary,
    this.size = TealBadgeSize.medium,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.showZero = false,
    this.maxCount = 99,
    this.icon,
    this.isVisible = true,
  });

  // 팩토리 생성자들
  factory TealBadge.count({
    Key? key,
    required int count,
    Widget? child,
    TealBadgeType type = TealBadgeType.primary,
    TealBadgeSize size = TealBadgeSize.medium,
    bool showZero = false,
    int maxCount = 99,
  }) {
    return TealBadge(
      key: key,
      count: count,
      child: child,
      type: type,
      size: size,
      showZero: showZero,
      maxCount: maxCount,
    );
  }

  factory TealBadge.text({
    Key? key,
    required String text,
    Widget? child,
    TealBadgeType type = TealBadgeType.primary,
    TealBadgeSize size = TealBadgeSize.medium,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return TealBadge(
      key: key,
      text: text,
      child: child,
      type: type,
      size: size,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory TealBadge.dot({
    Key? key,
    Widget? child,
    TealBadgeType type = TealBadgeType.primary,
    TealBadgeSize size = TealBadgeSize.small,
    Color? backgroundColor,
  }) {
    return TealBadge(
      key: key,
      child: child,
      type: type,
      size: size,
      backgroundColor: backgroundColor,
    );
  }

  factory TealBadge.icon({
    Key? key,
    required Widget icon,
    Widget? child,
    TealBadgeType type = TealBadgeType.primary,
    TealBadgeSize size = TealBadgeSize.medium,
    Color? backgroundColor,
  }) {
    return TealBadge(
      key: key,
      icon: icon,
      child: child,
      type: type,
      size: size,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return child ?? const SizedBox.shrink();
    }

    final shouldShow = _shouldShowBadge();
    if (!shouldShow) {
      return child ?? const SizedBox.shrink();
    }

    if (child == null) {
      return _buildStandaloneBadge();
    }

    return Badge(
      label: _buildBadgeContent(),
      backgroundColor: _getBadgeColor(),
      textColor: _getTextColor(),
      alignment: AlignmentDirectional.topEnd,
      offset: _getBadgeOffset(),
      child: child,
    );
  }

  bool _shouldShowBadge() {
    if (count != null) {
      return count! > 0 || showZero;
    }
    return text != null || icon != null;
  }

  Widget _buildStandaloneBadge() {
    final badgeStyle = _getBadgeStyle();
    
    return Container(
      padding: padding ?? badgeStyle.padding,
      decoration: BoxDecoration(
        color: _getBadgeColor(),
        borderRadius: BorderRadius.circular(badgeStyle.borderRadius),
        boxShadow: [
          BoxShadow(
            color: _getBadgeColor().withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: _buildBadgeContent(),
    );
  }

  Widget _buildBadgeContent() {
    final badgeStyle = _getBadgeStyle();
    
    if (icon != null) {
      return icon!;
    }
    
    if (count != null) {
      final displayCount = count! > maxCount! ? '${maxCount!}+' : count.toString();
      return Text(
        displayCount,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: badgeStyle.fontSize,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      );
    }
    
    if (text != null) {
      return Text(
        text!,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: badgeStyle.fontSize,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      );
    }
    
    // Dot badge (no content)
    return const SizedBox.shrink();
  }

  Color _getBadgeColor() {
    if (backgroundColor != null) return backgroundColor!;
    
    switch (type) {
      case TealBadgeType.primary:
        return AppColors.primary;
      case TealBadgeType.secondary:
        return AppColors.secondary;
      case TealBadgeType.success:
        return AppColors.success;
      case TealBadgeType.warning:
        return AppColors.warning;
      case TealBadgeType.error:
        return AppColors.error;
      case TealBadgeType.info:
        return AppColors.info;
    }
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;
    return Colors.white;
  }

  BadgeStyle _getBadgeStyle() {
    switch (size) {
      case TealBadgeSize.small:
        return BadgeStyle(
          fontSize: 10,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          borderRadius: 8,
        );
      case TealBadgeSize.medium:
        return BadgeStyle(
          fontSize: 12,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          borderRadius: 10,
        );
      case TealBadgeSize.large:
        return BadgeStyle(
          fontSize: 14,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          borderRadius: 12,
        );
    }
  }

  Offset _getBadgeOffset() {
    switch (size) {
      case TealBadgeSize.small:
        return const Offset(4, -4);
      case TealBadgeSize.medium:
        return const Offset(6, -6);
      case TealBadgeSize.large:
        return const Offset(8, -8);
    }
  }
}

class BadgeStyle {
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const BadgeStyle({
    required this.fontSize,
    required this.padding,
    required this.borderRadius,
  });
}

// 상태 배지 (온라인/오프라인 등)
class TealStatusBadge extends StatelessWidget {
  final bool isOnline;
  final Widget child;
  final Color? onlineColor;
  final Color? offlineColor;
  final TealBadgeSize size;
  final String? tooltip;

  const TealStatusBadge({
    super.key,
    required this.isOnline,
    required this.child,
    this.onlineColor,
    this.offlineColor,
    this.size = TealBadgeSize.medium,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isOnline 
      ? (onlineColor ?? AppColors.success)
      : (offlineColor ?? AppColors.textTertiary);
    
    final dotSize = _getDotSize();
    
    Widget badge = Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );

    if (tooltip != null) {
      badge = Tooltip(
        message: tooltip!,
        child: badge,
      );
    }

    return badge;
  }

  double _getDotSize() {
    switch (size) {
      case TealBadgeSize.small:
        return 8;
      case TealBadgeSize.medium:
        return 12;
      case TealBadgeSize.large:
        return 16;
    }
  }
}

// 알림 배지
class TealNotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final int maxCount;
  final bool showZero;
  final TealBadgeType type;
  final VoidCallback? onTap;

  const TealNotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.maxCount = 99,
    this.showZero = false,
    this.type = TealBadgeType.error,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TealBadge.count(
        count: count,
        maxCount: maxCount,
        showZero: showZero,
        type: type,
        child: child,
      ),
    );
  }
}

// 진행률 배지
class TealProgressBadge extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Widget child;
  final Color? progressColor;
  final Color? backgroundColor;
  final TealBadgeSize size;
  final bool showPercentage;

  const TealProgressBadge({
    super.key,
    required this.progress,
    required this.child,
    this.progressColor,
    this.backgroundColor,
    this.size = TealBadgeSize.medium,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -8,
          top: -8,
          child: Container(
            width: _getBadgeSize(),
            height: _getBadgeSize(),
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: progress,
                  backgroundColor: backgroundColor ?? AppColors.separator,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? AppColors.primary,
                  ),
                  strokeWidth: 2,
                ),
                if (showPercentage)
                  Center(
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: _getTextSize(),
                        fontWeight: FontWeight.w600,
                        color: progressColor ?? AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getBadgeSize() {
    switch (size) {
      case TealBadgeSize.small:
        return 20;
      case TealBadgeSize.medium:
        return 24;
      case TealBadgeSize.large:
        return 28;
    }
  }

  double _getTextSize() {
    switch (size) {
      case TealBadgeSize.small:
        return 8;
      case TealBadgeSize.medium:
        return 9;
      case TealBadgeSize.large:
        return 10;
    }
  }
}