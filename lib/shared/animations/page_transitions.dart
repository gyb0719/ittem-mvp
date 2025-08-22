import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'animation_config.dart';

/// Expedia 스타일의 커스텀 페이지 전환들
class ExpediaPageTransitions {
  
  /// 기본 슬라이드 전환 (오른쪽에서 왼쪽으로)
  static CustomTransitionPage<T> slideFromRight<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.pageTransition,
      reverseTransitionDuration: AnimationConfig.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaEnter,
            reverseCurve: AnimationConfig.expedaExit,
          )),
          child: child,
        );
      },
    );
  }

  /// 모달 스타일 전환 (아래에서 위로)
  static CustomTransitionPage<T> slideFromBottom<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.modalTransition,
      reverseTransitionDuration: AnimationConfig.modalTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.smoothCurve,
            reverseCurve: AnimationConfig.sharpCurve,
          )),
          child: child,
        );
      },
    );
  }

  /// 페이드 전환
  static CustomTransitionPage<T> fadeTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.normal,
      reverseTransitionDuration: AnimationConfig.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaTransition,
          ),
          child: child,
        );
      },
    );
  }

  /// 스케일 전환 (확대/축소 효과)
  static CustomTransitionPage<T> scaleTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
    double initialScale = 0.8,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.fast,
      reverseTransitionDuration: AnimationConfig.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: initialScale,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.bounceCurve,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 회전과 스케일을 결합한 전환
  static CustomTransitionPage<T> rotateScaleTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.slow,
      reverseTransitionDuration: AnimationConfig.slow,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.rotate(
          angle: (1 - animation.value) * 0.3,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.7,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AnimationConfig.bounceCurve,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// 탭 전환을 위한 부드러운 페이드 전환
  static CustomTransitionPage<T> tabTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.tabTransition,
      reverseTransitionDuration: AnimationConfig.tabTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaTransition,
          ),
          child: child,
        );
      },
    );
  }

  /// 시트 스타일 전환 (아래에서 위로, 배경 딤)
  static CustomTransitionPage<T> sheetTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
    bool barrierDismissible = true,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      opaque: false,
      barrierColor: Colors.black54,
      barrierDismissible: barrierDismissible,
      transitionDuration: AnimationConfig.modalTransition,
      reverseTransitionDuration: AnimationConfig.modalTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.smoothCurve,
            reverseCurve: AnimationConfig.sharpCurve,
          )),
          child: child,
        );
      },
    );
  }

  /// Hero 스타일 전환 (특정 요소에서 확장)
  static CustomTransitionPage<T> heroTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
    required String heroTag,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.pageTransition,
      reverseTransitionDuration: AnimationConfig.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaTransition,
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AnimationConfig.expedaEnter,
            )),
            child: child,
          ),
        );
      },
    );
  }

  /// 공유된 축 전환 (Material 3 스타일)
  static CustomTransitionPage<T> sharedAxisTransition<T extends Object?>(
    Widget child, {
    LocalKey? key,
    String? name,
    Object? arguments,
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.horizontal,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: AnimationConfig.pageTransition,
      reverseTransitionDuration: AnimationConfig.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: transitionType,
          child: child,
        );
      },
    );
  }
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

class _SharedAxisTransition extends StatelessWidget {
  const _SharedAxisTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.transitionType,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType transitionType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaEnter,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      case SharedAxisTransitionType.vertical:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaEnter,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      case SharedAxisTransitionType.scaled:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.expedaEnter,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

/// 경량화된 전환을 위한 노 트랜지션 페이지 (기존 대체용)
class NoTransitionPage<T extends Object?> extends CustomTransitionPage<T> {
  const NoTransitionPage({
    super.key,
    super.name,
    super.arguments,
    required super.child,
  }) : super(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: _noTransition,
        );

  static Widget _noTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}