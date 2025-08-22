import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/colors.dart';
import '../../../services/performance_service.dart';

// 고급 스켈레톤 로딩 시스템 - 한국 모바일 UX 최적화
class AdvancedSkeletonLoader {
  static const Duration defaultAnimationDuration = Duration(milliseconds: 1200);
  static const Duration fastAnimationDuration = Duration(milliseconds: 800);
  static const Duration slowAnimationDuration = Duration(milliseconds: 1600);
  
  // 성능 기반 애니메이션 속도 조절
  static Duration getOptimalAnimationDuration() {
    final performanceService = PerformanceService();
    
    if (!performanceService.isPerformanceGood) {
      return slowAnimationDuration; // 성능이 나쁠 때는 느리게
    } else if (performanceService.currentFps > 58) {
      return fastAnimationDuration; // 성능이 좋을 때는 빠르게
    }
    
    return defaultAnimationDuration;
  }
}

// 스켈레톤 색상 테마 (다크/라이트 모드 지원)
class SkeletonTheme {
  final Color baseColor;
  final Color highlightColor;
  final Color containerColor;
  
  const SkeletonTheme({
    required this.baseColor,
    required this.highlightColor,
    required this.containerColor,
  });
  
  static SkeletonTheme light() {
    return SkeletonTheme(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      containerColor: Colors.white,
    );
  }
  
  static SkeletonTheme dark() {
    return SkeletonTheme(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[600]!,
      containerColor: Colors.grey[800]!,
    );
  }
  
  static SkeletonTheme fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark() : light();
  }
}

// 고급 스켈레톤 애니메이션 위젯
class AdvancedSkeletonBox extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final SkeletonTheme? theme;
  final bool enableAnimation;
  final Duration? animationDuration;
  final Widget? child;
  
  const AdvancedSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.theme,
    this.enableAnimation = true,
    this.animationDuration,
    this.child,
  });
  
  @override
  State<AdvancedSkeletonBox> createState() => _AdvancedSkeletonBoxState();
}

class _AdvancedSkeletonBoxState extends State<AdvancedSkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration ?? AdvancedSkeletonLoader.getOptimalAnimationDuration(),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.enableAnimation) {
      _animationController.repeat();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? SkeletonTheme.fromBrightness(
      Theme.of(context).brightness,
    );
    
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: theme.baseColor,
      ),
      child: widget.enableAnimation
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        theme.baseColor,
                        theme.highlightColor,
                        theme.baseColor,
                      ],
                      stops: [
                        _animation.value - 0.3,
                        _animation.value,
                        _animation.value + 0.3,
                      ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                    ),
                  ),
                  child: widget.child,
                );
              },
            )
          : widget.child,
    );
  }
}

// 아이템 카드 스켈레톤 (당근마켓 스타일)
class ItemCardSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showPrice;
  final bool showLocation;
  final bool showLikeButton;
  
  const ItemCardSkeleton({
    super.key,
    this.width,
    this.height,
    this.showPrice = true,
    this.showLocation = true,
    this.showLikeButton = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                AdvancedSkeletonBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 8,
                ),
                if (showLikeButton)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: AdvancedSkeletonBox(
                      width: 32,
                      height: 32,
                      borderRadius: 16,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 제목 영역
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdvancedSkeletonBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 4),
                AdvancedSkeletonBox(
                  width: 120,
                  height: 14,
                  borderRadius: 4,
                ),
                if (showPrice) ...[
                  const SizedBox(height: 8),
                  AdvancedSkeletonBox(
                    width: 80,
                    height: 18,
                    borderRadius: 4,
                  ),
                ],
                if (showLocation) ...[
                  const Spacer(),
                  AdvancedSkeletonBox(
                    width: 100,
                    height: 12,
                    borderRadius: 4,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 리스트 아이템 스켈레톤 (세로 스크롤용)
class ListItemSkeleton extends StatelessWidget {
  final bool showAvatar;
  final bool showSubtitle;
  final bool showTrailing;
  
  const ListItemSkeleton({
    super.key,
    this.showAvatar = true,
    this.showSubtitle = true,
    this.showTrailing = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 아바타 또는 썸네일
          if (showAvatar)
            AdvancedSkeletonBox(
              width: 60,
              height: 60,
              borderRadius: 8,
            ),
          
          if (showAvatar) const SizedBox(width: 12),
          
          // 텍스트 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdvancedSkeletonBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 8),
                  AdvancedSkeletonBox(
                    width: 200,
                    height: 14,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 4),
                  AdvancedSkeletonBox(
                    width: 120,
                    height: 12,
                    borderRadius: 4,
                  ),
                ],
              ],
            ),
          ),
          
          // 트레일링 위젯
          if (showTrailing) ...[
            const SizedBox(width: 12),
            AdvancedSkeletonBox(
              width: 24,
              height: 24,
              borderRadius: 12,
            ),
          ],
        ],
      ),
    );
  }
}

// 검색 결과 그리드 스켈레톤
class GridSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets padding;
  
  const GridSkeletonLoader({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.7,
    this.padding = const EdgeInsets.all(16),
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ItemCardSkeleton();
        },
      ),
    );
  }
}

// 프로그레시브 로딩 위젯 (단계별 로딩)
class ProgressiveLoadingWidget extends StatefulWidget {
  final List<Widget> loadingStages;
  final List<Duration> stageDurations;
  final Widget finalContent;
  final VoidCallback? onLoadingComplete;
  
  const ProgressiveLoadingWidget({
    super.key,
    required this.loadingStages,
    required this.stageDurations,
    required this.finalContent,
    this.onLoadingComplete,
  });
  
  @override
  State<ProgressiveLoadingWidget> createState() => _ProgressiveLoadingWidgetState();
}

class _ProgressiveLoadingWidgetState extends State<ProgressiveLoadingWidget> {
  int _currentStage = 0;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _startProgressiveLoading();
  }
  
  void _startProgressiveLoading() async {
    for (int i = 0; i < widget.loadingStages.length; i++) {
      await Future.delayed(widget.stageDurations[i]);
      if (mounted) {
        setState(() {
          _currentStage = i + 1;
        });
      }
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      widget.onLoadingComplete?.call();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return widget.finalContent;
    }
    
    if (_currentStage >= widget.loadingStages.length) {
      return widget.loadingStages.last;
    }
    
    return widget.loadingStages[_currentStage];
  }
}

// 스마트 스켈레톤 위젯 (성능 기반 조절)
class SmartSkeletonWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? customSkeleton;
  final bool enableHapticFeedback;
  
  const SmartSkeletonWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.customSkeleton,
    this.enableHapticFeedback = false,
  });
  
  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      // 로딩 완료 시 햅틱 피드백 (선택적)
      if (enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      return child;
    }
    
    return customSkeleton ?? _buildDefaultSkeleton(context);
  }
  
  Widget _buildDefaultSkeleton(BuildContext context) {
    final performanceService = PerformanceService();
    
    // 성능이 나쁘면 단순한 스켈레톤 표시
    if (!performanceService.isPerformanceGood) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      );
    }
    
    // 성능이 좋으면 고급 스켈레톤 표시
    return AdvancedSkeletonBox(
      width: double.infinity,
      height: double.infinity,
    );
  }
}

// 카테고리 그리드 스켈레톤
class CategoryGridSkeleton extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  
  const CategoryGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 3,
  });
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdvancedSkeletonBox(
                width: 48,
                height: 48,
                borderRadius: 12,
              ),
              const SizedBox(height: 8),
              AdvancedSkeletonBox(
                width: 60,
                height: 14,
                borderRadius: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}

// 인기 아이템 가로 스크롤 스켈레톤
class HorizontalItemsSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;
  
  const HorizontalItemsSkeleton({
    super.key,
    this.itemCount = 3,
    this.itemWidth = 300,
    this.itemHeight = 120,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            width: itemWidth,
            margin: EdgeInsets.only(
              right: index < itemCount - 1 ? 16 : 0,
            ),
            child: ListItemSkeleton(
              showAvatar: true,
              showSubtitle: true,
              showTrailing: true,
            ),
          );
        },
      ),
    );
  }
}

// 성능 최적화된 스켈레톤 유틸리티
class SkeletonUtils {
  // 스켈레톤 애니메이션 활성화 여부 결정
  static bool shouldEnableAnimation() {
    final performanceService = PerformanceService();
    return performanceService.isPerformanceGood && performanceService.currentFps > 45;
  }
  
  // 스켈레톤 개수 조절 (성능 기반)
  static int getOptimalSkeletonCount(int targetCount) {
    final performanceService = PerformanceService();
    
    if (!performanceService.isPerformanceGood) {
      return (targetCount * 0.5).round().clamp(1, targetCount);
    }
    
    return targetCount;
  }
  
  // 스켈레톤 품질 조절
  static bool shouldUseHighQualitySkeleton() {
    final performanceService = PerformanceService();
    return performanceService.isPerformanceGood && 
           performanceService.isMemoryHealthy;
  }
}