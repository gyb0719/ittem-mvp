import 'package:flutter/material.dart';

/// 앱 전반에서 사용할 애니메이션 설정값들 - 한국 모바일 UX 최적화
class AnimationConfig {
  // Duration 설정 - 한국 앱들의 빠른 피드백 선호도 반영
  static const Duration ultraFast = Duration(milliseconds: 80);  // 당근마켓 스타일
  static const Duration fast = Duration(milliseconds: 150);      // 카카오톡 스타일
  static const Duration normal = Duration(milliseconds: 250);    // 쿠팡 스타일
  static const Duration slow = Duration(milliseconds: 400);      // 네이버 스타일
  static const Duration verySlow = Duration(milliseconds: 600);  // 토스 스타일
  
  // Korean UX specific durations
  static const Duration koreanBounceDuration = Duration(milliseconds: 120);
  static const Duration heartAnimation = Duration(milliseconds: 180);
  static const Duration priceHighlight = Duration(milliseconds: 200);
  static const Duration chatBubble = Duration(milliseconds: 160);
  
  // Curve 설정 - 한국 앱들의 자연스러운 움직임 패턴
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeOutExpo;
  static const Curve smoothCurve = Curves.easeInOutQuart;
  static const Curve materialCurve = Curves.easeInOut;
  
  // Korean mobile app specific curves
  static const Curve koreanBounce = Curves.elasticOut;
  static const Curve koreanSnappy = Curves.easeOutBack;
  static const Curve koreanGentle = Curves.easeInOutSine;
  static const Curve koreanSharp = Curves.easeOutCubic;
  
  // Expedia 스타일 커브들
  static const Curve expedaEnter = Curves.easeOutCubic;
  static const Curve expedaExit = Curves.easeInCubic;
  static const Curve expedaTransition = Curves.easeInOutCubic;
  
  // 스태거드 애니메이션을 위한 딜레이
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration microDelay = Duration(milliseconds: 25);
  
  // 페이지 전환별 설정
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration tabTransition = Duration(milliseconds: 250);
  static const Duration modalTransition = Duration(milliseconds: 400);
  
  // 리스트 애니메이션 설정
  static const Duration listItemEnter = Duration(milliseconds: 300);
  static const Duration listStagger = Duration(milliseconds: 80);
  
  // 마이크로 인터랙션 설정
  static const Duration buttonPress = Duration(milliseconds: 150);
  static const Duration rippleEffect = Duration(milliseconds: 200);
  static const Duration scalePress = Duration(milliseconds: 100);
  
  // 로딩 애니메이션 설정
  static const Duration shimmerPeriod = Duration(milliseconds: 1500);
  static const Duration skeletonFade = Duration(milliseconds: 300);
  
  // 스크롤 기반 애니메이션 설정
  static const double parallaxStrength = 0.3;
  static const double headerCollapseThreshold = 150.0;
  
  // 접근성을 위한 설정
  static bool get reduceMotion => false; // 시스템 설정에서 가져올 수 있음
  
  static Duration get adaptiveDuration {
    return reduceMotion ? ultraFast : normal;
  }
  
  static Curve get adaptiveCurve {
    return reduceMotion ? Curves.linear : defaultCurve;
  }
}

/// 애니메이션 타입별 미리 정의된 설정들
class AnimationPresets {
  // 페이지 전환 프리셋
  static const slideFromRight = _AnimationPreset(
    duration: AnimationConfig.pageTransition,
    curve: AnimationConfig.expedaEnter,
    reverseCurve: AnimationConfig.expedaExit,
  );
  
  static const slideFromBottom = _AnimationPreset(
    duration: AnimationConfig.modalTransition,
    curve: AnimationConfig.smoothCurve,
    reverseCurve: AnimationConfig.sharpCurve,
  );
  
  static const fadeIn = _AnimationPreset(
    duration: AnimationConfig.normal,
    curve: AnimationConfig.expedaTransition,
  );
  
  static const scaleUp = _AnimationPreset(
    duration: AnimationConfig.fast,
    curve: AnimationConfig.bounceCurve,
  );
  
  // 리스트 애니메이션 프리셋
  static const listStaggered = _AnimationPreset(
    duration: AnimationConfig.listItemEnter,
    curve: AnimationConfig.expedaEnter,
    staggerDelay: AnimationConfig.listStagger,
  );
  
  // 마이크로 인터랙션 프리셋
  static const buttonFeedback = _AnimationPreset(
    duration: AnimationConfig.buttonPress,
    curve: AnimationConfig.materialCurve,
  );
  
  static const ripple = _AnimationPreset(
    duration: AnimationConfig.rippleEffect,
    curve: AnimationConfig.expedaTransition,
  );
  
  // Korean UX specific presets
  static const koreanHeartBounce = _AnimationPreset(
    duration: AnimationConfig.heartAnimation,
    curve: AnimationConfig.koreanBounce,
  );
  
  static const koreanPriceHighlight = _AnimationPreset(
    duration: AnimationConfig.priceHighlight,
    curve: AnimationConfig.koreanSnappy,
  );
  
  static const koreanChatBubble = _AnimationPreset(
    duration: AnimationConfig.chatBubble,
    curve: AnimationConfig.koreanGentle,
  );
  
  static const koreanButtonPress = _AnimationPreset(
    duration: AnimationConfig.koreanBounceDuration,
    curve: AnimationConfig.koreanSnappy,
  );
  
  static const koreanSuccessAnimation = _AnimationPreset(
    duration: AnimationConfig.normal,
    curve: AnimationConfig.koreanBounce,
  );
}

class _AnimationPreset {
  final Duration duration;
  final Curve curve;
  final Curve? reverseCurve;
  final Duration? staggerDelay;
  
  const _AnimationPreset({
    required this.duration,
    required this.curve,
    this.reverseCurve,
    this.staggerDelay,
  });
}