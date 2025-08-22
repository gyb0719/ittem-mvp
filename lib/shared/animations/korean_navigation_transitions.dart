import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import 'animation_config.dart';

/// 한국 모바일 앱 스타일의 네비게이션 전환 애니메이션
/// 카카오톡, 네이버, 토스, 당근마켓 등의 패턴을 참고

/// 카카오톡 스타일 페이지 전환
class KoreanPageTransition extends PageRouteBuilder {
  final Widget child;
  final KoreanTransitionType type;
  final Duration duration;
  final Curve curve;

  KoreanPageTransition({
    required this.child,
    this.type = KoreanTransitionType.slideFromRight,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              type: type,
              curve: curve,
            );
          },
        );

  static Widget _buildTransition({
    required Widget child,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required KoreanTransitionType type,
    required Curve curve,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    switch (type) {
      case KoreanTransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            )),
            child: child,
          ),
        );

      case KoreanTransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case KoreanTransitionType.fadeScale:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );

      case KoreanTransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case KoreanTransitionType.koreanBounce:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

enum KoreanTransitionType {
  slideFromRight,
  slideFromBottom,
  slideFromLeft,
  fadeScale,
  koreanBounce,
}

/// 토스 스타일 탭 전환 애니메이션
class KoreanTabTransition extends StatefulWidget {
  final List<Widget> children;
  final int currentIndex;
  final ValueChanged<int>? onIndexChanged;
  final Duration duration;
  final Curve curve;

  const KoreanTabTransition({
    super.key,
    required this.children,
    required this.currentIndex,
    this.onIndexChanged,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  State<KoreanTabTransition> createState() => _KoreanTabTransitionState();
}

class _KoreanTabTransitionState extends State<KoreanTabTransition>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _indicatorController;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(initialPage: widget.currentIndex);
    
    _indicatorController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _indicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _indicatorController,
      curve: widget.curve,
    ));
  }

  @override
  void didUpdateWidget(KoreanTabTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: widget.duration,
        curve: widget.curve,
      );
      _indicatorController.forward().then((_) {
        _indicatorController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        widget.onIndexChanged?.call(index);
        HapticFeedback.lightImpact();
      },
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return widget.children[index];
      },
    );
  }
}

/// 네이버 스타일 모달 전환
class KoreanModalTransition extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final VoidCallback? onDismiss;
  final Duration duration;
  final Color? barrierColor;

  const KoreanModalTransition({
    super.key,
    required this.child,
    required this.isVisible,
    this.onDismiss,
    this.duration = const Duration(milliseconds: 350),
    this.barrierColor,
  });

  @override
  State<KoreanModalTransition> createState() => _KoreanModalTransitionState();
}

class _KoreanModalTransitionState extends State<KoreanModalTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanBounce,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(KoreanModalTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && _controller.isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Barrier
            GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: (widget.barrierColor ?? Colors.black54)
                    .withOpacity(_fadeAnimation.value * 0.6),
              ),
            ),
            // Modal content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 당근마켓 스타일 바텀 시트 전환
class KoreanBottomSheet extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final VoidCallback? onDismiss;
  final Duration duration;
  final double maxHeight;
  final bool enableDrag;

  const KoreanBottomSheet({
    super.key,
    required this.child,
    required this.isVisible,
    this.onDismiss,
    this.duration = const Duration(milliseconds: 300),
    this.maxHeight = 0.9,
    this.enableDrag = true,
  });

  @override
  State<KoreanBottomSheet> createState() => _KoreanBottomSheetState();
}

class _KoreanBottomSheetState extends State<KoreanBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanGentle,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(KoreanBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enableDrag) return;
    
    setState(() {
      _dragOffset += details.primaryDelta!;
      _dragOffset = _dragOffset.clamp(0.0, double.infinity);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enableDrag) return;
    
    const threshold = 100.0;
    
    if (_dragOffset > threshold) {
      widget.onDismiss?.call();
    }
    
    setState(() {
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && _controller.isDismissed) {
      return const SizedBox.shrink();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final maxSheetHeight = screenHeight * widget.maxHeight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Barrier
            GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black54.withOpacity(_fadeAnimation.value * 0.6),
              ),
            ),
            // Bottom sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(
                  0,
                  (maxSheetHeight * _slideAnimation.value) + _dragOffset,
                ),
                child: GestureDetector(
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: maxSheetHeight,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.textTertiary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Content
                        Flexible(child: widget.child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 쿠팡 스타일 네비게이션 바 애니메이션
class KoreanAnimatedNavigationBar extends StatefulWidget {
  final List<KoreanNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double height;

  const KoreanAnimatedNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.height = 60.0,
  });

  @override
  State<KoreanAnimatedNavigationBar> createState() => _KoreanAnimatedNavigationBarState();
}

class _KoreanAnimatedNavigationBarState extends State<KoreanAnimatedNavigationBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Color?>> _colorAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: AnimationConfig.fast,
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AnimationConfig.koreanBounce,
      ));
    }).toList();

    _colorAnimations = _controllers.map((controller) {
      return ColorTween(
        begin: widget.unselectedColor ?? AppColors.textTertiary,
        end: widget.selectedColor ?? AppColors.primary,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Animate current index
    _controllers[widget.currentIndex].forward();
  }

  @override
  void didUpdateWidget(KoreanAnimatedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
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
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.separator, width: 0.5),
        ),
      ),
      child: Row(
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final isSelected = index == widget.currentIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call(index);
                HapticFeedback.lightImpact();
              },
              child: AnimatedBuilder(
                animation: _controllers[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimations[index].value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: _colorAnimations[index].value,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: _colorAnimations[index].value,
                            fontSize: 12,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class KoreanNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const KoreanNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}