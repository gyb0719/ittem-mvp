import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

/// Shimmer 효과를 생성하는 기본 위젯
/// 부드러운 애니메이션으로 로딩 상태를 표현합니다.
class SkeletonShimmer extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Duration period;
  final LinearGradient? gradient;

  const SkeletonShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.period = const Duration(milliseconds: 1500),
    this.gradient,
  });

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.period,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.enabled) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(SkeletonShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  LinearGradient get _defaultGradient {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDark) {
      return const LinearGradient(
        colors: [
          Color(0xFF1E293B), // surfaceDark
          Color(0xFF334155), // separatorDark
          Color(0xFF1E293B), // surfaceDark
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment(-1.0, 0.0),
        end: Alignment(1.0, 0.0),
      );
    } else {
      return const LinearGradient(
        colors: [
          Color(0xFFE2E8F0), // separator
          Color(0xFFF1F5F9), // lighter
          Color(0xFFE2E8F0), // separator
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment(-1.0, 0.0),
        end: Alignment(1.0, 0.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return (widget.gradient ?? _defaultGradient).createShader(
              Rect.fromLTWH(
                bounds.width * _animation.value,
                0,
                bounds.width,
                bounds.height,
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton 색상을 관리하는 헬퍼 클래스
class SkeletonColors {
  static Color getBaseColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.surfaceDark : AppColors.separator;
  }

  static Color getHighlightColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.separatorDark : const Color(0xFFF1F5F9);
  }

  static LinearGradient getShimmerGradient(BuildContext context) {
    final baseColor = getBaseColor(context);
    final highlightColor = getHighlightColor(context);
    
    return LinearGradient(
      colors: [
        baseColor,
        highlightColor,
        baseColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}