import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// 상태 표시 타입
enum StatusType { available, rented, requested, completed, cancelled, error }

extension StatusTypeExtension on StatusType {
  Color get color {
    switch (this) {
      case StatusType.available:
        return AppColors.available;
      case StatusType.rented:
        return AppColors.rented;
      case StatusType.requested:
        return AppColors.requested;
      case StatusType.completed:
        return AppColors.completed;
      case StatusType.cancelled:
        return AppColors.archived;
      case StatusType.error:
        return AppColors.error;
    }
  }

  String get label {
    switch (this) {
      case StatusType.available:
        return '대여가능';
      case StatusType.rented:
        return '대여중';
      case StatusType.requested:
        return '요청됨';
      case StatusType.completed:
        return '완료';
      case StatusType.cancelled:
        return '취소됨';
      case StatusType.error:
        return '오류';
    }
  }

  IconData get icon {
    switch (this) {
      case StatusType.available:
        return Icons.check_circle;
      case StatusType.rented:
        return Icons.schedule;
      case StatusType.requested:
        return Icons.pending;
      case StatusType.completed:
        return Icons.task_alt;
      case StatusType.cancelled:
        return Icons.cancel;
      case StatusType.error:
        return Icons.error;
    }
  }
}

/// 틸 색상 상태 뱃지
class TealStatusChip extends StatelessWidget {
  final StatusType status;
  final String? customLabel;
  final bool showIcon;
  final double fontSize;

  const TealStatusChip({
    super.key,
    required this.status,
    this.customLabel,
    this.showIcon = true,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: status.color.withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              status.icon,
              color: Colors.white,
              size: fontSize + 2,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            customLabel ?? status.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 틸 색상 프로그레스 바
class TealProgressBar extends StatefulWidget {
  final double value; // 0.0 ~ 1.0
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final bool showPercentage;
  final bool animated;

  const TealProgressBar({
    super.key,
    required this.value,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 8,
    this.showPercentage = false,
    this.animated = true,
  });

  @override
  State<TealProgressBar> createState() => _TealProgressBarState();
}

class _TealProgressBarState extends State<TealProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(TealProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null || widget.showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              if (widget.showPercentage)
                AnimatedBuilder(
                  animation: widget.animated ? _animation : AlwaysStoppedAnimation(widget.value),
                  builder: (context, child) {
                    final currentValue = widget.animated ? _animation.value : widget.value;
                    return Text(
                      '${(currentValue * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.tealPale,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: AnimatedBuilder(
            animation: widget.animated ? _animation : AlwaysStoppedAnimation(widget.value),
            builder: (context, child) {
              final currentValue = widget.animated ? _animation.value : widget.value;
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: currentValue,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.foregroundColor ?? AppColors.primary,
                        widget.foregroundColor ?? AppColors.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.foregroundColor ?? AppColors.primary)
                            .withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 틸 색상 스테퍼
class TealStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isHorizontal;

  const TealStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.activeColor,
    this.inactiveColor,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Row(
        children: _buildSteppers(),
      );
    } else {
      return Column(
        children: _buildSteppers(),
      );
    }
  }

  List<Widget> _buildSteppers() {
    List<Widget> widgets = [];
    
    for (int i = 0; i < steps.length; i++) {
      final isActive = i <= currentStep;
      final isCompleted = i < currentStep;
      
      widgets.add(_buildStep(i, steps[i], isActive, isCompleted));
      
      if (i < steps.length - 1) {
        widgets.add(_buildConnector(i < currentStep));
      }
    }
    
    return widgets;
  }

  Widget _buildStep(int index, String title, bool isActive, bool isCompleted) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted 
                ? (activeColor ?? AppColors.primary)
                : isActive 
                    ? (activeColor ?? AppColors.primary)
                    : (inactiveColor ?? AppColors.separator),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: (activeColor ?? AppColors.primary).withValues(alpha: 0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
            ],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    if (isHorizontal) {
      return Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.only(bottom: 40),
          color: isActive 
              ? (activeColor ?? AppColors.primary)
              : (inactiveColor ?? AppColors.separator),
        ),
      );
    } else {
      return Container(
        width: 2,
        height: 40,
        color: isActive 
            ? (activeColor ?? AppColors.primary)
            : (inactiveColor ?? AppColors.separator),
      );
    }
  }
}