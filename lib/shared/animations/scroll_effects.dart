import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'animation_config.dart';

/// 패럴랙스 효과를 위한 위젯
class ParallaxWidget extends StatefulWidget {
  final Widget child;
  final double strength;
  final ScrollController? scrollController;

  const ParallaxWidget({
    super.key,
    required this.child,
    this.strength = AnimationConfig.parallaxStrength,
    this.scrollController,
  });

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_updateOffset);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_updateOffset);
    super.dispose();
  }

  void _updateOffset() {
    if (mounted) {
      setState(() {
        _offset = (widget.scrollController?.offset ?? 0.0) * widget.strength;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_offset),
      child: widget.child,
    );
  }
}

/// 스크롤에 따라 축소되는 헤더
class CollapsibleHeader extends StatefulWidget {
  final Widget child;
  final double expandedHeight;
  final double collapsedHeight;
  final ScrollController scrollController;
  final Color? backgroundColor;
  final Widget? flexibleSpace;

  const CollapsibleHeader({
    super.key,
    required this.child,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.scrollController,
    this.backgroundColor,
    this.flexibleSpace,
  });

  @override
  State<CollapsibleHeader> createState() => _CollapsibleHeaderState();
}

class _CollapsibleHeaderState extends State<CollapsibleHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.fast,
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: widget.expandedHeight,
      end: widget.collapsedHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    widget.scrollController.addListener(_updateHeader);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateHeader);
    _controller.dispose();
    super.dispose();
  }

  void _updateHeader() {
    final offset = widget.scrollController.offset;
    final progress = (offset / AnimationConfig.headerCollapseThreshold).clamp(0.0, 1.0);
    _controller.value = progress;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: _heightAnimation.value,
          color: widget.backgroundColor,
          child: Stack(
            children: [
              if (widget.flexibleSpace != null)
                Positioned.fill(
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: widget.flexibleSpace!,
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 스크롤 기반 애니메이션 효과
class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final double revealOffset;
  final Duration duration;
  final Curve curve;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.revealOffset = 100.0,
    this.duration = AnimationConfig.normal,
    this.curve = AnimationConfig.expedaEnter,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        
        if (position.dy < screenHeight - widget.revealOffset && !_isVisible) {
          _isVisible = true;
          _controller.forward();
        }
        
        return false;
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

/// 고정 요소 (스티키)
class StickyWidget extends StatefulWidget {
  final Widget child;
  final double stickOffset;
  final ScrollController scrollController;

  const StickyWidget({
    super.key,
    required this.child,
    this.stickOffset = 0.0,
    required this.scrollController,
  });

  @override
  State<StickyWidget> createState() => _StickyWidgetState();
}

class _StickyWidgetState extends State<StickyWidget> {
  bool _isSticky = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateSticky);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateSticky);
    super.dispose();
  }

  void _updateSticky() {
    final isCurrentlySticky = widget.scrollController.offset > widget.stickOffset;
    if (isCurrentlySticky != _isSticky) {
      setState(() {
        _isSticky = isCurrentlySticky;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AnimationConfig.fast,
      curve: AnimationConfig.expedaTransition,
      decoration: BoxDecoration(
        boxShadow: _isSticky
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: widget.child,
    );
  }
}

/// 스크롤 투 탑 버튼
class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double showOffset;
  final VoidCallback? onPressed;
  final Widget? child;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.showOffset = 200.0,
    this.onPressed,
    this.child,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.bounceCurve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaEnter,
    ));

    widget.scrollController.addListener(_updateVisibility);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _updateVisibility() {
    final shouldShow = widget.scrollController.offset > widget.showOffset;
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
      
      if (_isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0.0,
      duration: AnimationConfig.slow,
      curve: AnimationConfig.expedaTransition,
    );
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton(
          mini: true,
          onPressed: _scrollToTop,
          child: widget.child ?? const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}

/// 무한 스크롤 로더
class InfiniteScrollLoader extends StatefulWidget {
  final ScrollController scrollController;
  final Future<void> Function() onLoadMore;
  final bool isLoading;
  final double threshold;
  final Widget? loadingWidget;

  const InfiniteScrollLoader({
    super.key,
    required this.scrollController,
    required this.onLoadMore,
    required this.isLoading,
    this.threshold = 200.0,
    this.loadingWidget,
  });

  @override
  State<InfiniteScrollLoader> createState() => _InfiniteScrollLoaderState();
}

class _InfiniteScrollLoaderState extends State<InfiniteScrollLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    widget.scrollController.addListener(_checkForLoadMore);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkForLoadMore);
    _controller.dispose();
    super.dispose();
  }

  void _checkForLoadMore() {
    if (widget.isLoading) return;
    
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    
    if (maxScroll - currentScroll <= widget.threshold) {
      widget.onLoadMore();
    }
  }

  @override
  void didUpdateWidget(InfiniteScrollLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.loadingWidget ?? 
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

/// 스크롤 기반 진행 바
class ScrollProgressBar extends StatefulWidget {
  final ScrollController scrollController;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;

  const ScrollProgressBar({
    super.key,
    required this.scrollController,
    this.backgroundColor,
    this.progressColor,
    this.height = 4.0,
  });

  @override
  State<ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<ScrollProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.ultraFast,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    widget.scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateProgress);
    _controller.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    
    if (maxScroll > 0) {
      final newProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      if (newProgress != _progress) {
        setState(() {
          _progress = newProgress;
        });
        _controller.animateTo(_progress);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: widget.backgroundColor ?? Colors.grey.withOpacity(0.2),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _progressAnimation.value,
              child: Container(
                height: widget.height,
                color: widget.progressColor ?? Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}