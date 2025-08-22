import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'animation_config.dart';

/// 성능 최적화를 위한 애니메이션 래퍼
class PerformanceAwareAnimation extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final bool respectReducedMotion;

  const PerformanceAwareAnimation({
    super.key,
    required this.child,
    this.enabled = true,
    this.respectReducedMotion = true,
  });

  @override
  Widget build(BuildContext context) {
    // 디버그 모드가 아닌 경우 또는 애니메이션이 비활성화된 경우
    if (!enabled || (!kDebugMode && _shouldDisableAnimations(context))) {
      return child;
    }

    // 접근성 설정 확인
    if (respectReducedMotion && MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    // RepaintBoundary로 성능 최적화
    return RepaintBoundary(
      child: child,
    );
  }

  bool _shouldDisableAnimations(BuildContext context) {
    // 성능이 낮은 기기에서는 애니메이션을 줄임
    final mediaQuery = MediaQuery.of(context);
    
    // 작은 화면이나 저해상도에서는 일부 애니메이션 제한
    if (mediaQuery.size.width < 600 || mediaQuery.devicePixelRatio < 2.0) {
      return false; // 기본적으로는 활성화하되, 필요시 조건 추가
    }
    
    return false;
  }
}

/// 메모리 효율적인 애니메이션 컨트롤러 관리자
class AnimationManager {
  static final Map<String, AnimationController> _controllers = {};
  
  /// 애니메이션 컨트롤러를 재사용하거나 새로 생성
  static AnimationController getController({
    required String key,
    required Duration duration,
    required TickerProvider vsync,
    Duration? reverseDuration,
  }) {
    if (_controllers.containsKey(key)) {
      final controller = _controllers[key]!;
      // AnimationController 상태 확인을 다른 방법으로 처리
      try {
        // 컨트롤러가 사용 가능한지 확인
        controller.value;
        return controller;
      } catch (e) {
        // 컨트롤러가 disposed된 경우
        _controllers.remove(key);
      }
    }

    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      vsync: vsync,
    );

    _controllers[key] = controller;
    return controller;
  }

  /// 특정 컨트롤러 해제
  static void disposeController(String key) {
    if (_controllers.containsKey(key)) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }
  }

  /// 모든 컨트롤러 해제
  static void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}

/// 배터리 효율적인 애니메이션 설정
class BatteryAwareAnimationConfig {
  static Duration getDuration(Duration original, BuildContext context) {
    // 저전력 모드일 때 애니메이션 시간 단축
    if (_isLowPowerMode()) {
      return Duration(milliseconds: (original.inMilliseconds * 0.5).round());
    }
    return original;
  }

  static Curve getCurve(Curve original) {
    // 저전력 모드일 때 선형 커브 사용
    if (_isLowPowerMode()) {
      return Curves.linear;
    }
    return original;
  }

  static bool _isLowPowerMode() {
    // 실제로는 플랫폼별 저전력 모드 감지 로직 필요
    // 현재는 기본값 false 반환
    return false;
  }
}

/// FPS 모니터링을 위한 위젯
class FPSMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const FPSMonitor({
    super.key,
    required this.child,
    this.enabled = kDebugMode,
  });

  @override
  State<FPSMonitor> createState() => _FPSMonitorState();
}

class _FPSMonitorState extends State<FPSMonitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _frameCount = 0;
  double _currentFPS = 0.0;
  DateTime _lastTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _controller = AnimationController(
        duration: const Duration(days: 1),
        vsync: this,
      )..repeat();
      
      _controller.addListener(_updateFPS);
    }
  }

  void _updateFPS() {
    _frameCount++;
    final now = DateTime.now();
    final elapsed = now.difference(_lastTime).inMilliseconds;
    
    if (elapsed >= 1000) {
      setState(() {
        _currentFPS = _frameCount * 1000 / elapsed;
        _frameCount = 0;
        _lastTime = now;
      });
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.enabled && kDebugMode)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _currentFPS >= 50 
                    ? Colors.green.withOpacity(0.8)
                    : _currentFPS >= 30
                        ? Colors.orange.withOpacity(0.8)
                        : Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'FPS: ${_currentFPS.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 조건부 애니메이션 빌더
class ConditionalAnimation extends StatelessWidget {
  final bool condition;
  final Widget animatedChild;
  final Widget staticChild;
  final Widget? loadingChild;

  const ConditionalAnimation({
    super.key,
    required this.condition,
    required this.animatedChild,
    required this.staticChild,
    this.loadingChild,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return animatedChild;
    } else if (loadingChild != null) {
      return loadingChild!;
    } else {
      return staticChild;
    }
  }
}

/// 스마트 애니메이션 래퍼 - 상황에 따라 애니메이션 자동 조절
class SmartAnimation extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool enableInLowPerformance;

  const SmartAnimation({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.enableInLowPerformance = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLowPerformance = _isLowPerformanceDevice(mediaQuery);
    
    // 저성능 기기에서 애니메이션 비활성화할지 결정
    if (isLowPerformance && !enableInLowPerformance) {
      return child;
    }

    // 접근성 설정 확인
    if (mediaQuery.disableAnimations) {
      return child;
    }

    return PerformanceAwareAnimation(
      child: child,
    );
  }

  bool _isLowPerformanceDevice(MediaQueryData mediaQuery) {
    // 간단한 성능 추정 로직
    final screenSize = mediaQuery.size.width * mediaQuery.size.height;
    final pixelRatio = mediaQuery.devicePixelRatio;
    
    // 작은 화면이거나 낮은 픽셀 밀도를 저성능으로 판단
    return screenSize < 400 * 800 || pixelRatio < 2.0;
  }
}

/// 메모리 효율적인 사전 빌드 애니메이션
class PrebuiltAnimation extends StatefulWidget {
  final Widget Function(Animation<double> animation) builder;
  final Duration duration;
  final Curve curve;
  final bool autoStart;

  const PrebuiltAnimation({
    super.key,
    required this.builder,
    this.duration = AnimationConfig.normal,
    this.curve = AnimationConfig.expedaTransition,
    this.autoStart = true,
  });

  @override
  State<PrebuiltAnimation> createState() => _PrebuiltAnimationState();
}

class _PrebuiltAnimationState extends State<PrebuiltAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
      curve: widget.curve,
    ));

    if (widget.autoStart) {
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
      builder: (context, child) => widget.builder(_animation),
    );
  }
}