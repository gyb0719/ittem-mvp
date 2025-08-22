import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import 'animation_config.dart';

/// 한국 모바일 앱 스타일의 리스트 및 카드 애니메이션
/// 당근마켓, 쿠팡, 배달의민족 등의 UX 패턴을 참고

/// 당근마켓 스타일 스태거드 리스트 애니메이션
class KoreanStaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Curve curve;
  final bool animateOnScroll;
  final ScrollController? scrollController;

  const KoreanStaggeredList({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.itemDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
    this.animateOnScroll = false,
    this.scrollController,
  });

  @override
  State<KoreanStaggeredList> createState() => _KoreanStaggeredListState();
}

class _KoreanStaggeredListState extends State<KoreanStaggeredList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStaggeredAnimation();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.itemDuration,
        vsync: this,
      ),
    );

    _slideAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 50.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));
    }).toList();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimations[index].value),
              child: Opacity(
                opacity: _fadeAnimations[index].value,
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}

/// 쿠팡 스타일 카드 호버 애니메이션
class KoreanInteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final bool enableHoverEffect;
  final bool enablePressEffect;

  const KoreanInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.elevation = 2.0,
    this.backgroundColor,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
  });

  @override
  State<KoreanInteractiveCard> createState() => _KoreanInteractiveCardState();
}

class _KoreanInteractiveCardState extends State<KoreanInteractiveCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _shadowAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pressController = AnimationController(
      duration: AnimationConfig.fast,
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 4.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: AnimationConfig.koreanSnappy,
    ));

    _shadowAnimation = ColorTween(
      begin: AppColors.shadow,
      end: AppColors.shadow.withOpacity(0.2),
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = true);
      _pressController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _pressController.reverse();
      widget.onTap?.call();
    }
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = true);
      _hoverController.forward();
    }
  }

  void _handleHoverExit(PointerExitEvent event) {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = false);
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _pressController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: widget.margin ?? const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.surface,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _shadowAnimation.value ?? AppColors.shadow,
                      blurRadius: _elevationAnimation.value * 2,
                      offset: Offset(0, _elevationAnimation.value),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 배달의민족 스타일 Pull-to-Refresh
class KoreanPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? indicatorColor;
  final double displacement;
  final bool enableHaptic;

  const KoreanPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.indicatorColor,
    this.displacement = 40.0,
    this.enableHaptic = true,
  });

  @override
  State<KoreanPullToRefresh> createState() => _KoreanPullToRefreshState();
}

class _KoreanPullToRefreshState extends State<KoreanPullToRefresh>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanBounce,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    _controller.forward();
    
    if (widget.enableHaptic) {
      HapticFeedback.mediumImpact();
    }

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      displacement: widget.displacement,
      color: widget.indicatorColor ?? AppColors.primary,
      backgroundColor: AppColors.surface,
      child: widget.child,
    );
  }
}

/// 당근마켓 스타일 삭제/아카이브 스와이프 애니메이션
class KoreanSwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;
  final Color deleteColor;
  final Color archiveColor;
  final IconData deleteIcon;
  final IconData archiveIcon;
  final double actionWidth;

  const KoreanSwipeableCard({
    super.key,
    required this.child,
    this.onDelete,
    this.onArchive,
    this.deleteColor = const Color(0xFFFF4444),
    this.archiveColor = const Color(0xFFFF9500),
    this.deleteIcon = Icons.delete,
    this.archiveIcon = Icons.archive,
    this.actionWidth = 80.0,
  });

  @override
  State<KoreanSwipeableCard> createState() => _KoreanSwipeableCardState();
}

class _KoreanSwipeableCardState extends State<KoreanSwipeableCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _deleteController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _deleteAnimation;
  
  double _dragExtent = 0.0;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _deleteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _deleteAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _deleteController,
      curve: AnimationConfig.koreanSharp,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta!;
    _dragExtent += delta;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final progress = (_dragExtent / screenWidth).clamp(-1.0, 0.0);
    
    _slideController.value = -progress;
  }

  void _handleDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;
    
    if (_dragExtent.abs() > threshold) {
      _slideController.forward().then((_) {
        if (_dragExtent < 0) {
          // Swiped left - show actions
          _showActionSheet();
        }
      });
    } else {
      _slideController.reverse();
    }
    
    _dragExtent = 0.0;
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onArchive != null)
                _buildActionItem(
                  icon: widget.archiveIcon,
                  text: '보관하기',
                  color: widget.archiveColor,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onArchive!();
                  },
                ),
              if (widget.onDelete != null)
                _buildActionItem(
                  icon: widget.deleteIcon,
                  text: '삭제하기',
                  color: widget.deleteColor,
                  onTap: () {
                    Navigator.pop(context);
                    _handleDelete();
                  },
                ),
              _buildActionItem(
                icon: Icons.close,
                text: '취소',
                color: AppColors.textSecondary,
                onTap: () {
                  Navigator.pop(context);
                  _slideController.reverse();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _handleDelete() {
    setState(() => _isDeleting = true);
    _deleteController.forward().then((_) {
      widget.onDelete?.call();
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _deleteAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _deleteAnimation.value,
          child: Opacity(
            opacity: _deleteAnimation.value,
            child: GestureDetector(
              onHorizontalDragUpdate: _isDeleting ? null : _handleDragUpdate,
              onHorizontalDragEnd: _isDeleting ? null : _handleDragEnd,
              child: SlideTransition(
                position: _slideAnimation,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 무한 스크롤 리스트 with 로딩 애니메이션
class KoreanInfiniteList extends StatefulWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final Widget? loadingWidget;
  final ScrollController? controller;

  const KoreanInfiniteList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.loadingWidget,
    this.controller,
  });

  @override
  State<KoreanInfiniteList> createState() => _KoreanInfiniteListState();
}

class _KoreanInfiniteListState extends State<KoreanInfiniteList>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_scrollListener);
    
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(KoreanInfiniteList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    _loadingController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.itemCount + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.itemCount) {
          return widget.loadingWidget ?? _buildLoadingIndicator();
        }
        return widget.itemBuilder(context, index);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _loadingAnimation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: _loadingAnimation.value * 2 * 3.14159,
                child: const Icon(
                  Icons.refresh,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '더 보기',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}