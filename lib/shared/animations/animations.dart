// 애니메이션 시스템 배럴 파일
// 모든 애니메이션 관련 클래스와 유틸리티를 한 곳에서 export

export 'animation_config.dart';
export 'page_transitions.dart';
export 'list_animations.dart';
export 'state_animations.dart';
export 'micro_interactions.dart';
export 'scroll_effects.dart';
export 'performance_wrapper.dart';

// 자주 사용되는 애니메이션 유틸리티들을 위한 편의 클래스들

import 'package:flutter/material.dart';
import 'animation_config.dart';
import 'page_transitions.dart';

/// 자주 사용되는 애니메이션 패턴들을 위한 헬퍼 클래스
class AnimationHelpers {
  
  /// 기본 페이드 인 애니메이션
  static Widget fadeIn({
    required Widget child,
    Duration duration = AnimationConfig.normal,
    Curve curve = AnimationConfig.expedaTransition,
    double opacity = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: opacity),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 기본 슬라이드 인 애니메이션
  static Widget slideIn({
    required Widget child,
    Duration duration = AnimationConfig.normal,
    Curve curve = AnimationConfig.expedaEnter,
    Offset begin = const Offset(0.0, 0.3),
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      tween: Tween(begin: begin, end: Offset.zero),
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 기본 스케일 인 애니메이션
  static Widget scaleIn({
    required Widget child,
    Duration duration = AnimationConfig.fast,
    Curve curve = AnimationConfig.bounceCurve,
    double begin = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: begin, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 회전 애니메이션
  static Widget rotateIn({
    required Widget child,
    Duration duration = AnimationConfig.normal,
    Curve curve = AnimationConfig.expedaTransition,
    double begin = 0.3,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: begin, end: 0.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 조합된 페이드+슬라이드 애니메이션
  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = AnimationConfig.normal,
    Curve curve = AnimationConfig.expedaEnter,
    Offset slideBegin = const Offset(0.0, 0.3),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, progress, child) {
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset.lerp(slideBegin, Offset.zero, progress)!,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// 조합된 페이드+스케일 애니메이션
  static Widget fadeScaleIn({
    required Widget child,
    Duration duration = AnimationConfig.fast,
    Curve curve = AnimationConfig.bounceCurve,
    double scaleBegin = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, progress, child) {
        return Opacity(
          opacity: progress,
          child: Transform.scale(
            scale: scaleBegin + (1.0 - scaleBegin) * progress,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// 미리 정의된 페이지 전환 팩토리
class PageTransitionFactory {
  
  /// iOS 스타일 슬라이드 전환
  static Page<T> slide<T extends Object?>(Widget child, {String? name}) {
    return ExpediaPageTransitions.slideFromRight<T>(child, name: name);
  }

  /// 모달 스타일 전환
  static Page<T> modal<T extends Object?>(Widget child, {String? name}) {
    return ExpediaPageTransitions.slideFromBottom<T>(child, name: name);
  }

  /// 페이드 전환
  static Page<T> fade<T extends Object?>(Widget child, {String? name}) {
    return ExpediaPageTransitions.fadeTransition<T>(child, name: name);
  }

  /// 스케일 전환
  static Page<T> scale<T extends Object?>(Widget child, {String? name}) {
    return ExpediaPageTransitions.scaleTransition<T>(child, name: name);
  }

  /// 탭 전환
  static Page<T> tab<T extends Object?>(Widget child, {String? name}) {
    return ExpediaPageTransitions.tabTransition<T>(child, name: name);
  }

  /// 시트 전환
  static Page<T> sheet<T extends Object?>(Widget child, {String? name}) {
    return ExpediaPageTransitions.sheetTransition<T>(child, name: name);
  }

  /// 트랜지션 없음 (성능용)
  static Page<T> none<T extends Object?>(Widget child, {String? name}) {
    return NoTransitionPage<T>(child: child, name: name);
  }
}

/// 접근성을 고려한 애니메이션 래퍼
class AccessibleAnimation extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final Duration duration;

  const AccessibleAnimation({
    super.key,
    required this.child,
    this.fallback,
    this.duration = AnimationConfig.normal,
  });

  @override
  Widget build(BuildContext context) {
    // 시스템의 reduced motion 설정을 확인
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    
    if (disableAnimations) {
      return fallback ?? child;
    }
    
    return child;
  }
}

/// 성능 최적화를 위한 애니메이션 래퍼
class OptimizedAnimation extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const OptimizedAnimation({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return RepaintBoundary(
      child: child,
    );
  }
}

/// 애니메이션 상태를 관리하는 믹신
mixin AnimationStateMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  final List<AnimationController> _controllers = [];

  /// 새로운 애니메이션 컨트롤러를 생성하고 관리 목록에 추가
  AnimationController createController({
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
  }) {
    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      vsync: this,
    );
    _controllers.add(controller);
    return controller;
  }

  /// 모든 애니메이션 정리
  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}