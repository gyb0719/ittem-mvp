import 'package:flutter/material.dart';
import 'animation_config.dart';

/// 상태 변화를 위한 애니메이션 컴포넌트들
class AnimatedStateTransition extends StatefulWidget {
  final Widget child;
  final String stateKey;
  final Duration duration;
  final Curve curve;

  const AnimatedStateTransition({
    super.key,
    required this.child,
    required this.stateKey,
    this.duration = AnimationConfig.normal,
    this.curve = AnimationConfig.expedaTransition,
  });

  @override
  State<AnimatedStateTransition> createState() => _AnimatedStateTransitionState();
}

class _AnimatedStateTransitionState extends State<AnimatedStateTransition> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: widget.curve,
      switchOutCurve: widget.curve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(widget.stateKey),
        child: widget.child,
      ),
    );
  }
}

/// 로딩 상태 애니메이션
class AnimatedLoadingState extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final Duration duration;

  const AnimatedLoadingState({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.duration = AnimationConfig.skeletonFade,
  });

  @override
  State<AnimatedLoadingState> createState() => _AnimatedLoadingStateState();
}

class _AnimatedLoadingStateState extends State<AnimatedLoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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
      curve: AnimationConfig.expedaTransition,
    ));

    if (!widget.isLoading) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedLoadingState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.reverse();
      } else {
        _controller.forward();
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
    return Stack(
      children: [
        // 로딩 위젯
        if (widget.isLoading)
          widget.loadingWidget ?? const _DefaultLoadingWidget(),
        
        // 실제 콘텐츠
        FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ],
    );
  }
}

class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// 빈 상태 애니메이션
class AnimatedEmptyState extends StatefulWidget {
  final bool isEmpty;
  final Widget child;
  final Widget emptyWidget;
  final Duration duration;

  const AnimatedEmptyState({
    super.key,
    required this.isEmpty,
    required this.child,
    required this.emptyWidget,
    this.duration = AnimationConfig.normal,
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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
      curve: AnimationConfig.bounceCurve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    if (widget.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedEmptyState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEmpty != oldWidget.isEmpty) {
      if (widget.isEmpty) {
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
    return AnimatedSwitcher(
      duration: widget.duration,
      child: widget.isEmpty
          ? ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.emptyWidget,
              ),
            )
          : widget.child,
    );
  }
}

/// 에러 상태 애니메이션
class AnimatedErrorState extends StatefulWidget {
  final bool hasError;
  final Widget child;
  final Widget errorWidget;
  final Duration duration;
  final VoidCallback? onRetry;

  const AnimatedErrorState({
    super.key,
    required this.hasError,
    required this.child,
    required this.errorWidget,
    this.duration = AnimationConfig.normal,
    this.onRetry,
  });

  @override
  State<AnimatedErrorState> createState() => _AnimatedErrorStateState();
}

class _AnimatedErrorStateState extends State<AnimatedErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.expedaTransition,
    ));

    if (widget.hasError) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedErrorState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError != oldWidget.hasError) {
      if (widget.hasError) {
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
    return AnimatedSwitcher(
      duration: widget.duration,
      child: widget.hasError
          ? FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      10 * _shakeAnimation.value * (1 - _shakeAnimation.value),
                      0,
                    ),
                    child: widget.errorWidget,
                  );
                },
              ),
            )
          : widget.child,
    );
  }
}

/// 성공 피드백 애니메이션
class AnimatedSuccessFeedback extends StatefulWidget {
  final bool showSuccess;
  final Widget child;
  final Widget? successWidget;
  final Duration duration;
  final Duration displayDuration;

  const AnimatedSuccessFeedback({
    super.key,
    required this.showSuccess,
    required this.child,
    this.successWidget,
    this.duration = AnimationConfig.fast,
    this.displayDuration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedSuccessFeedback> createState() => _AnimatedSuccessFeedbackState();
}

class _AnimatedSuccessFeedbackState extends State<AnimatedSuccessFeedback>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: AnimationConfig.bounceCurve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AnimationConfig.expedaTransition,
    ));
  }

  @override
  void didUpdateWidget(AnimatedSuccessFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showSuccess && !oldWidget.showSuccess) {
      _showSuccessAnimation();
    }
  }

  void _showSuccessAnimation() async {
    await _fadeController.forward();
    await _bounceController.forward();
    
    await Future.delayed(widget.displayDuration);
    
    if (mounted) {
      await _fadeController.reverse();
      _bounceController.reset();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showSuccess)
          Positioned.fill(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _bounceAnimation,
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: widget.successWidget ?? const _DefaultSuccessWidget(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DefaultSuccessWidget extends StatelessWidget {
  const _DefaultSuccessWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 48,
      ),
    );
  }
}

/// 컨텐츠 크기 변화 애니메이션
class AnimatedSizeTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedSizeTransition({
    super.key,
    required this.child,
    this.duration = AnimationConfig.normal,
    this.curve = AnimationConfig.expedaTransition,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

/// 투명도 변화 애니메이션
class AnimatedOpacityTransition extends StatelessWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Curve curve;

  const AnimatedOpacityTransition({
    super.key,
    required this.child,
    required this.visible,
    this.duration = AnimationConfig.normal,
    this.curve = AnimationConfig.expedaTransition,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}