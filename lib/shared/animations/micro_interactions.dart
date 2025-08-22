import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'animation_config.dart';

/// 버튼 터치 피드백 애니메이션
class AnimatedTouchFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scaleValue;
  final bool enableHapticFeedback;

  const AnimatedTouchFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.duration = AnimationConfig.buttonPress,
    this.scaleValue = 0.95,
    this.enableHapticFeedback = true,
  });

  @override
  State<AnimatedTouchFeedback> createState() => _AnimatedTouchFeedbackState();
}

class _AnimatedTouchFeedbackState extends State<AnimatedTouchFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.materialCurve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// 리플 효과가 있는 터치 피드백
class AnimatedRippleFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final Duration duration;
  final BorderRadius? borderRadius;

  const AnimatedRippleFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.duration = AnimationConfig.rippleEffect,
    this.borderRadius,
  });

  @override
  State<AnimatedRippleFeedback> createState() => _AnimatedRippleFeedbackState();
}

class _AnimatedRippleFeedbackState extends State<AnimatedRippleFeedback> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        splashColor: widget.rippleColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: widget.rippleColor ?? Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: widget.borderRadius,
        child: widget.child,
      ),
    );
  }
}

/// 텍스트 필드 포커스 애니메이션
class AnimatedTextFieldFocus extends StatefulWidget {
  final Widget child;
  final Color focusColor;
  final Duration duration;
  final double borderWidth;

  const AnimatedTextFieldFocus({
    super.key,
    required this.child,
    required this.focusColor,
    this.duration = AnimationConfig.fast,
    this.borderWidth = 2.0,
  });

  @override
  State<AnimatedTextFieldFocus> createState() => _AnimatedTextFieldFocusState();
}

class _AnimatedTextFieldFocusState extends State<AnimatedTextFieldFocus>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: widget.focusColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _handleFocusChange,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _colorAnimation.value ?? Colors.grey,
                  width: widget.borderWidth,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// 스위치/토글 애니메이션
class AnimatedToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const AnimatedToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    this.duration = AnimationConfig.fast,
  });

  @override
  State<AnimatedToggle> createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.bounceCurve,
    ));

    _colorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
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
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _colorAnimation.value,
        ),
        child: AnimatedBuilder(
          animation: _positionAnimation,
          builder: (context, child) {
            return Align(
              alignment: Alignment.lerp(
                Alignment.centerLeft,
                Alignment.centerRight,
                _positionAnimation.value,
              )!,
              child: Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 플로팅 액션 버튼 애니메이션
class AnimatedFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool visible;
  final Duration duration;

  const AnimatedFloatingActionButton({
    super.key,
    this.onPressed,
    required this.child,
    this.visible = true,
    this.duration = AnimationConfig.normal,
  });

  @override
  State<AnimatedFloatingActionButton> createState() => _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends State<AnimatedFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _visibilityController;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _visibilityController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _pressController = AnimationController(
      duration: AnimationConfig.buttonPress,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _visibilityController,
      curve: AnimationConfig.bounceCurve,
    ));

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: AnimationConfig.materialCurve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _visibilityController,
      curve: AnimationConfig.expedaEnter,
    ));

    if (widget.visible) {
      _visibilityController.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedFloatingActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _visibilityController.forward();
      } else {
        _visibilityController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _pressAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pressAnimation.value,
                child: FloatingActionButton(
                  onPressed: null, // GestureDetector로 처리
                  child: widget.child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 카운터 애니메이션 (숫자 증가/감소)
class AnimatedCounter extends StatefulWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = AnimationConfig.normal,
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _controller.reset();
      _controller.forward();
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
      animation: _animation,
      builder: (context, child) {
        final currentValue = (_previousValue + 
            (widget.value - _previousValue) * _animation.value).round();
        
        return Text(
          currentValue.toString(),
          style: widget.style,
        );
      },
    );
  }
}