import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Animation components exports
export 'animation_config.dart';
export 'korean_micro_interactions.dart';
export 'korean_list_animations.dart';
export 'korean_navigation_transitions.dart';
export 'korean_form_interactions.dart';
export 'korean_content_interactions.dart';

/// 한국 모바일 UX 애니메이션 매니저
/// 모든 애니메이션을 통합 관리하고 성능 최적화를 담당
class KoreanAnimationManager {
  static KoreanAnimationManager? _instance;
  static KoreanAnimationManager get instance => _instance ??= KoreanAnimationManager._();
  
  KoreanAnimationManager._();

  // Performance settings
  bool _performanceMode = false;
  bool _reduceMotion = false;
  double _animationScale = 1.0;

  // Haptic feedback settings
  bool _enableHaptics = true;
  bool _enableSystemHaptics = true;

  // Animation statistics
  int _activeAnimations = 0;
  final Map<String, int> _animationCounts = {};

  /// Initialize the animation manager
  void initialize({
    bool performanceMode = false,
    bool reduceMotion = false,
    double animationScale = 1.0,
    bool enableHaptics = true,
    bool enableSystemHaptics = true,
  }) {
    _performanceMode = performanceMode;
    _reduceMotion = reduceMotion;
    _animationScale = animationScale.clamp(0.1, 2.0);
    _enableHaptics = enableHaptics;
    _enableSystemHaptics = enableSystemHaptics;
    
    debugPrint('Korean Animation Manager initialized:');
    debugPrint('  Performance Mode: $_performanceMode');
    debugPrint('  Reduce Motion: $_reduceMotion');
    debugPrint('  Animation Scale: $_animationScale');
    debugPrint('  Haptics Enabled: $_enableHaptics');
  }

  /// Get optimized duration based on settings
  Duration getOptimizedDuration(Duration baseDuration) {
    if (_reduceMotion) {
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.3).round());
    }
    
    if (_performanceMode) {
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.7).round());
    }
    
    return Duration(
      milliseconds: (baseDuration.inMilliseconds * _animationScale).round(),
    );
  }

  /// Get optimized curve based on settings
  Curve getOptimizedCurve(Curve baseCurve) {
    if (_reduceMotion) {
      return Curves.linear;
    }
    
    if (_performanceMode) {
      return Curves.easeInOut;
    }
    
    return baseCurve;
  }

  /// Trigger haptic feedback if enabled
  void triggerHaptic(HapticType type) {
    if (!_enableHaptics) return;
    
    switch (type) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.vibrate:
        if (_enableSystemHaptics) {
          HapticFeedback.vibrate();
        }
        break;
    }
  }

  /// Register animation start
  void registerAnimationStart(String animationType) {
    _activeAnimations++;
    _animationCounts[animationType] = (_animationCounts[animationType] ?? 0) + 1;
    
    if (_activeAnimations > 10) {
      debugPrint('⚠️ High animation count: $_activeAnimations active animations');
    }
  }

  /// Register animation end
  void registerAnimationEnd(String animationType) {
    _activeAnimations--;
    if (_activeAnimations < 0) _activeAnimations = 0;
  }

  /// Get animation statistics
  Map<String, dynamic> getStats() {
    return {
      'activeAnimations': _activeAnimations,
      'animationCounts': Map.from(_animationCounts),
      'performanceMode': _performanceMode,
      'reduceMotion': _reduceMotion,
      'animationScale': _animationScale,
    };
  }

  /// Check if device should use performance mode
  bool shouldUsePerformanceMode() {
    // This would typically check device capabilities
    return _performanceMode || _activeAnimations > 8;
  }

  /// Update settings dynamically
  void updateSettings({
    bool? performanceMode,
    bool? reduceMotion,
    double? animationScale,
    bool? enableHaptics,
  }) {
    if (performanceMode != null) _performanceMode = performanceMode;
    if (reduceMotion != null) _reduceMotion = reduceMotion;
    if (animationScale != null) _animationScale = animationScale.clamp(0.1, 2.0);
    if (enableHaptics != null) _enableHaptics = enableHaptics;
  }

  // Getters for current settings
  bool get performanceMode => _performanceMode;
  bool get reduceMotion => _reduceMotion;
  double get animationScale => _animationScale;
  bool get enableHaptics => _enableHaptics;
  int get activeAnimations => _activeAnimations;
}

enum HapticType {
  light,
  medium,
  heavy,
  selection,
  vibrate,
}

/// Korean UX Animation Utils
class KoreanAnimationUtils {
  static final _manager = KoreanAnimationManager.instance;

  /// Create an optimized animation controller
  static AnimationController createController({
    required TickerProvider vsync,
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
  }) {
    final optimizedDuration = _manager.getOptimizedDuration(duration);
    final optimizedReverseDuration = reverseDuration != null 
        ? _manager.getOptimizedDuration(reverseDuration)
        : null;

    _manager.registerAnimationStart(debugLabel ?? 'unknown');

    final controller = AnimationController(
      duration: optimizedDuration,
      reverseDuration: optimizedReverseDuration,
      vsync: vsync,
      debugLabel: debugLabel,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || 
          status == AnimationStatus.dismissed) {
        _manager.registerAnimationEnd(debugLabel ?? 'unknown');
      }
    });

    return controller;
  }

  /// Create an optimized curved animation
  static CurvedAnimation createCurvedAnimation({
    required AnimationController parent,
    required Curve curve,
    Curve? reverseCurve,
  }) {
    return CurvedAnimation(
      parent: parent,
      curve: _manager.getOptimizedCurve(curve),
      reverseCurve: reverseCurve != null 
          ? _manager.getOptimizedCurve(reverseCurve)
          : null,
    );
  }

  /// Trigger haptic feedback
  static void haptic(HapticType type) {
    _manager.triggerHaptic(type);
  }

  /// Check if animations should be reduced
  static bool get shouldReduceMotion => _manager.reduceMotion;

  /// Check if performance mode is active
  static bool get isPerformanceMode => _manager.shouldUsePerformanceMode();
}

/// Korean Animation Theme Extensions
extension KoreanAnimationTheme on ThemeData {
  /// Get Korean-style page transition theme
  PageTransitionsTheme get koreanPageTransitionsTheme {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: KoreanPageTransitionsBuilder(),
        TargetPlatform.iOS: KoreanPageTransitionsBuilder(),
      },
    );
  }
}

/// Custom page transitions builder for Korean UX patterns
class KoreanPageTransitionsBuilder extends PageTransitionsBuilder {
  const KoreanPageTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: KoreanAnimationManager.instance.getOptimizedCurve(
        Curves.easeInOutCubic,
      ),
    );
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    );
  }
}

/// Korean Animation Presets for common use cases
class KoreanAnimationPresets {
  static const Duration quickFeedback = Duration(milliseconds: 80);
  static const Duration normalTransition = Duration(milliseconds: 250);
  static const Duration slowTransition = Duration(milliseconds: 400);
  
  static const Curve koreanEase = Curves.easeInOutCubic;
  static const Curve koreanBounce = Curves.elasticOut;
  static const Curve koreanSnap = Curves.easeOutBack;

  /// 당근마켓 스타일 프리셋
  static const Duration carrotQuick = Duration(milliseconds: 150);
  static const Curve carrotEase = Curves.easeOutCubic;

  /// 쿠팡 스타일 프리셋  
  static const Duration coupangTransition = Duration(milliseconds: 200);
  static const Curve coupangEase = Curves.easeInOutQuart;

  /// 카카오톡 스타일 프리셋
  static const Duration kakaoMessage = Duration(milliseconds: 160);
  static const Curve kakaoEase = Curves.easeInOutSine;

  /// 토스 스타일 프리셋
  static const Duration tossSuccess = Duration(milliseconds: 300);
  static const Curve tossEase = Curves.elasticOut;

  /// 네이버 스타일 프리셋
  static const Duration naverSearch = Duration(milliseconds: 300);
  static const Curve naverEase = Curves.easeInOutCubic;
}

/// Performance monitoring widget for animations
class KoreanAnimationMonitor extends StatefulWidget {
  final Widget child;
  final bool showStats;

  const KoreanAnimationMonitor({
    super.key,
    required this.child,
    this.showStats = false,
  });

  @override
  State<KoreanAnimationMonitor> createState() => _KoreanAnimationMonitorState();
}

class _KoreanAnimationMonitorState extends State<KoreanAnimationMonitor> {
  @override
  Widget build(BuildContext context) {
    if (!widget.showStats || const bool.fromEnvironment('dart.vm.product')) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.of(context).padding.top + 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Animations: ${KoreanAnimationManager.instance.activeAnimations}',
                  style: TextStyle(
                    color: KoreanAnimationManager.instance.activeAnimations > 5
                        ? Colors.orange
                        : Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Performance: ${KoreanAnimationManager.instance.shouldUsePerformanceMode() ? "ON" : "OFF"}',
                  style: TextStyle(
                    color: KoreanAnimationManager.instance.shouldUsePerformanceMode()
                        ? Colors.orange
                        : Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Scale: ${KoreanAnimationManager.instance.animationScale.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}