import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import 'animation_config.dart';

/// 한국 모바일 앱 스타일의 프리미엄 마이크로 인터랙션
/// 당근마켓, 쿠팡, 카카오톡, 토스 등의 UX 패턴을 참고

/// 당근마켓 스타일 하트 애니메이션
class KoreanHeartButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onTap;
  final double size;
  final Color? likedColor;
  final Color? unlikedColor;
  final bool enableHaptic;

  const KoreanHeartButton({
    super.key,
    required this.isLiked,
    this.onTap,
    this.size = 24.0,
    this.likedColor,
    this.unlikedColor,
    this.enableHaptic = true,
  });

  @override
  State<KoreanHeartButton> createState() => _KoreanHeartButtonState();
}

class _KoreanHeartButtonState extends State<KoreanHeartButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.heartAnimation,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanBounce,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.unlikedColor ?? AppColors.textTertiary,
      end: widget.likedColor ?? AppColors.error,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isLiked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(KoreanHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked != oldWidget.isLiked) {
      if (widget.isLiked) {
        _controller.forward();
        _pulseController.forward().then((_) {
          _pulseController.reverse();
        });
        if (widget.enableHaptic) {
          HapticFeedback.mediumImpact();
        }
      } else {
        _controller.reverse();
        if (widget.enableHaptic) {
          HapticFeedback.lightImpact();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size + 16,
        height: widget.size + 16,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            if (widget.isLiked)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.5),
                    child: Container(
                      width: widget.size + 8,
                      height: widget.size + 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (widget.likedColor ?? AppColors.error)
                            .withOpacity(0.3 * (1.0 - _pulseAnimation.value)),
                      ),
                    ),
                  );
                },
              ),
            // Heart icon
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                    size: widget.size,
                    color: _colorAnimation.value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 쿠팡 스타일 가격 하이라이트 애니메이션
class KoreanPriceHighlight extends StatefulWidget {
  final String price;
  final String? originalPrice;
  final TextStyle? style;
  final TextStyle? originalStyle;
  final bool animate;
  final Duration duration;

  const KoreanPriceHighlight({
    super.key,
    required this.price,
    this.originalPrice,
    this.style,
    this.originalStyle,
    this.animate = true,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<KoreanPriceHighlight> createState() => _KoreanPriceHighlightState();
}

class _KoreanPriceHighlightState extends State<KoreanPriceHighlight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanSnappy,
    ));

    _colorAnimation = ColorTween(
      begin: AppColors.textPrimary,
      end: AppColors.error,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _controller.forward().then((_) {
            _controller.reverse();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.originalPrice != null) ...[
                Text(
                  widget.originalPrice!,
                  style: widget.originalStyle ?? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                widget.price,
                style: (widget.style ?? const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                )).copyWith(
                  color: _colorAnimation.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 카카오톡 스타일 채팅 버블 애니메이션
class KoreanChatBubble extends StatefulWidget {
  final Widget child;
  final bool isOwn;
  final bool animate;
  final int animationIndex;

  const KoreanChatBubble({
    super.key,
    required this.child,
    this.isOwn = false,
    this.animate = true,
    this.animationIndex = 0,
  });

  @override
  State<KoreanChatBubble> createState() => _KoreanChatBubbleState();
}

class _KoreanChatBubbleState extends State<KoreanChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.chatBubble,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanGentle,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isOwn ? 0.3 : -0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.animationIndex * 50), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: EdgeInsets.only(
                  left: widget.isOwn ? 60 : 0,
                  right: widget.isOwn ? 0 : 60,
                  bottom: 8,
                ),
                child: Row(
                  mainAxisAlignment: widget.isOwn 
                      ? MainAxisAlignment.end 
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isOwn 
                            ? AppColors.primary 
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: widget.isOwn ? null : Border.all(
                          color: AppColors.separator,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 토스 스타일 성공 애니메이션
class KoreanSuccessAnimation extends StatefulWidget {
  final Widget child;
  final bool show;
  final VoidCallback? onComplete;

  const KoreanSuccessAnimation({
    super.key,
    required this.child,
    this.show = false,
    this.onComplete,
  });

  @override
  State<KoreanSuccessAnimation> createState() => _KoreanSuccessAnimationState();
}

class _KoreanSuccessAnimationState extends State<KoreanSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanBounce,
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppColors.success.withOpacity(0.1),
      end: AppColors.success,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.show) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(KoreanSuccessAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show && widget.show) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.forward().then((_) {
      _checkController.forward().then((_) {
        HapticFeedback.mediumImpact();
        widget.onComplete?.call();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return widget.child;

    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorAnimation.value,
                ),
                child: AnimatedBuilder(
                  animation: _checkAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CheckmarkPainter(_checkAnimation.value),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    const start = Offset(0.2, 0.5);
    const middle = Offset(0.45, 0.7);
    const end = Offset(0.8, 0.3);

    if (progress <= 0.5) {
      // First half: draw from start to middle
      final currentProgress = progress * 2;
      final currentPoint = Offset.lerp(start, middle, currentProgress)!;
      
      path.moveTo(start.dx * size.width, start.dy * size.height);
      path.lineTo(currentPoint.dx * size.width, currentPoint.dy * size.height);
    } else {
      // Second half: draw from middle to end
      final currentProgress = (progress - 0.5) * 2;
      final currentPoint = Offset.lerp(middle, end, currentProgress)!;
      
      path.moveTo(start.dx * size.width, start.dy * size.height);
      path.lineTo(middle.dx * size.width, middle.dy * size.height);
      path.lineTo(currentPoint.dx * size.width, currentPoint.dy * size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 네이버 스타일 프리미엄 버튼
class KoreanPremiumButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? pressedColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool enableHaptic;
  final bool isLoading;

  const KoreanPremiumButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.pressedColor,
    this.padding,
    this.borderRadius,
    this.enableHaptic = true,
    this.isLoading = false,
  });

  @override
  State<KoreanPremiumButton> createState() => _KoreanPremiumButtonState();
}

class _KoreanPremiumButtonState extends State<KoreanPremiumButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _loadingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: AnimationConfig.koreanBounceDuration,
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: AnimationConfig.koreanSnappy,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? AppColors.primary,
      end: widget.pressedColor ?? AppColors.primaryVariant,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(KoreanPremiumButton oldWidget) {
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
    _pressController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _pressController.forward();
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
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
      if (widget.onPressed != null && !widget.isLoading) {
        widget.onPressed!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, _loadingController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding ?? const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: _elevationAnimation.value * 2,
                    offset: Offset(0, _elevationAnimation.value),
                  ),
                ],
              ),
              child: widget.isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159,
                          child: const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        widget.child,
                      ],
                    )
                  : widget.child,
            ),
          );
        },
      ),
    );
  }
}