import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final List<PerformanceMetric> _metrics = [];
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  Timer? _memoryMonitorTimer;
  bool _isMonitoring = false;
  
  // Memory tracking
  final List<int> _memoryHistory = [];
  int _lastMemoryUsage = 0;
  
  // FPS tracking
  final List<double> _fpsHistory = [];
  double _currentFps = 60.0;
  int _frameDrops = 0;
  int _totalFrames = 0;

  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _memoryMonitorTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _collectMemoryMetrics(),
    );
    
    _collectDeviceInfo();
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = null;
  }

  void startOperation(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
  }

  void endOperation(String operationName, {Map<String, dynamic>? additionalData}) {
    final startTime = _operationStartTimes.remove(operationName);
    if (startTime == null) {
      debugPrint('Warning: No start time found for operation: $operationName');
      return;
    }

    final duration = DateTime.now().difference(startTime);
    final metric = PerformanceMetric(
      operationName: operationName,
      duration: duration,
      timestamp: DateTime.now(),
      additionalData: additionalData,
    );

    _metrics.add(metric);
    
    if (kDebugMode && duration.inMilliseconds > 1000) {
      debugPrint('⚠️ Slow operation detected: $operationName took ${duration.inMilliseconds}ms');
    }
  }

  Future<void> _collectMemoryMetrics() async {
    try {
      // Web 환경에서는 Platform 체크를 하지 않고 기본 처리
      int memoryUsage = 0;
      
      if (kIsWeb) {
        // 웹 환경에서는 이미지 캐시 기반으로 추정
        memoryUsage = _estimateMemoryUsage();
      } else {
        try {
          if (Platform.isAndroid) {
            // Android native 메모리 정보
            memoryUsage = _estimateMemoryUsage(); // 시뮬레이션
          } else {
            memoryUsage = _estimateMemoryUsage();
          }
        } catch (e) {
          memoryUsage = _estimateMemoryUsage();
        }
      }
      
      _memoryHistory.add(memoryUsage);
      if (_memoryHistory.length > 120) {
        _memoryHistory.removeAt(0);
      }
      
      final memoryDelta = memoryUsage - _lastMemoryUsage;
      _lastMemoryUsage = memoryUsage;
      
      _metrics.add(PerformanceMetric(
        operationName: 'memory_check',
        duration: Duration.zero,
        timestamp: DateTime.now(),
        additionalData: {
          'type': 'memory',
          'memory_usage_mb': (memoryUsage / 1024 / 1024).round(),
          'memory_delta_mb': (memoryDelta / 1024 / 1024).round(),
          'image_cache_size': imageCache.currentSize,
          'image_cache_count': imageCache.currentSizeBytes,
          'platform': kIsWeb ? 'web' : (Platform.isAndroid ? 'android' : 'other'),
        },
      ));
    } catch (e) {
      debugPrint('Error collecting memory metrics: $e');
    }
  }
  
  int _estimateMemoryUsage() {
    // 대략적인 메모리 사용량 추정
    int estimation = 0;
    
    try {
      // 이미지 캐시 기여도
      estimation += imageCache.currentSizeBytes;
      
      // Flutter 엔진 기본 오버헤드 (추정)
      estimation += kIsWeb ? 30 * 1024 * 1024 : 50 * 1024 * 1024; // Web: ~30MB, Mobile: ~50MB
    } catch (e) {
      estimation = kIsWeb ? 30 * 1024 * 1024 : 50 * 1024 * 1024;
    }
    
    return estimation;
  }

  Future<void> _collectDeviceInfo() async {
    try {
      Map<String, dynamic> deviceData = {};
      
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        deviceData = {
          'platform': 'web',
          'browser': webInfo.browserName.name,
          'version': webInfo.appVersion ?? 'unknown',
          'user_agent': webInfo.userAgent ?? 'unknown',
        };
      } else {
        try {
          if (Platform.isAndroid) {
            final androidInfo = await _deviceInfo.androidInfo;
            deviceData = {
              'platform': 'android',
              'version': androidInfo.version.release,
              'sdk': androidInfo.version.sdkInt,
              'manufacturer': androidInfo.manufacturer,
              'model': androidInfo.model,
              'device': androidInfo.device,
            };
          } else if (Platform.isIOS) {
            final iosInfo = await _deviceInfo.iosInfo;
            deviceData = {
              'platform': 'ios',
              'version': iosInfo.systemVersion,
              'name': iosInfo.name,
              'model': iosInfo.model,
              'localizedModel': iosInfo.localizedModel,
            };
          }
        } catch (e) {
          deviceData = {
            'platform': 'unknown',
            'error': e.toString(),
          };
        }
      }

      _metrics.add(PerformanceMetric(
        operationName: 'device_info',
        duration: Duration.zero,
        timestamp: DateTime.now(),
        additionalData: deviceData,
      ));
    } catch (e) {
      debugPrint('Error collecting device info: $e');
    }
  }

  List<PerformanceMetric> getMetrics({String? operationName, Duration? timeWindow}) {
    var filteredMetrics = _metrics.asMap().entries.map((e) => e.value).toList();
    
    if (operationName != null) {
      filteredMetrics = filteredMetrics
          .where((metric) => metric.operationName == operationName)
          .toList();
    }
    
    if (timeWindow != null) {
      final cutoffTime = DateTime.now().subtract(timeWindow);
      filteredMetrics = filteredMetrics
          .where((metric) => metric.timestamp.isAfter(cutoffTime))
          .toList();
    }
    
    return filteredMetrics;
  }

  PerformanceReport generateReport() {
    if (_metrics.isEmpty) {
      return PerformanceReport(
        totalOperations: 0,
        averageDuration: Duration.zero,
        slowOperations: [],
        memoryMetrics: [],
        reportGeneratedAt: DateTime.now(),
      );
    }

    final operationMetrics = _metrics
        .where((metric) => metric.operationName != 'memory_check' && metric.operationName != 'device_info')
        .toList();

    final slowOperations = operationMetrics
        .where((metric) => metric.duration.inMilliseconds > 1000)
        .toList()
      ..sort((a, b) => b.duration.compareTo(a.duration));

    final memoryMetrics = _metrics
        .where((metric) => metric.operationName == 'memory_check')
        .toList();

    final totalDuration = operationMetrics.fold<Duration>(
      Duration.zero,
      (total, metric) => total + metric.duration,
    );

    final averageDuration = operationMetrics.isEmpty
        ? Duration.zero
        : Duration(
            milliseconds: totalDuration.inMilliseconds ~/ operationMetrics.length,
          );

    return PerformanceReport(
      totalOperations: operationMetrics.length,
      averageDuration: averageDuration,
      slowOperations: slowOperations.take(10).toList(),
      memoryMetrics: memoryMetrics,
      reportGeneratedAt: DateTime.now(),
    );
  }

  void clearMetrics() {
    _metrics.clear();
    _operationStartTimes.clear();
  }

  String exportMetricsAsJson() {
    return jsonEncode({
      'metrics': _metrics.map((metric) => metric.toJson()).toList(),
      'exported_at': DateTime.now().toIso8601String(),
    });
  }

  void logSlowFrame(Duration frameDuration) {
    if (frameDuration.inMilliseconds > 16) { // 60 FPS 기준
      _frameDrops++;
      _currentFps = 1000 / frameDuration.inMilliseconds;
      
      _metrics.add(PerformanceMetric(
        operationName: 'slow_frame',
        duration: frameDuration,
        timestamp: DateTime.now(),
        additionalData: {
          'fps': (1000 / frameDuration.inMilliseconds).round(),
          'target_fps': 60,
        },
      ));
    }
    _totalFrames++;
  }

  // Network request tracking
  void trackNetworkRequest(String url, {Duration? duration, int? responseSize}) {
    _metrics.add(PerformanceMetric(
      operationName: 'network_request',
      duration: duration ?? Duration.zero,
      timestamp: DateTime.now(),
      additionalData: {
        'url': url,
        'response_size_bytes': responseSize,
      },
    ));
  }

  // Performance getters
  bool get isPerformanceGood {
    return _currentFps >= 50 && currentMemoryUsageMB < 200;
  }

  bool get isMemoryHealthy {
    return currentMemoryUsageMB < 200;
  }

  double get currentFps => _currentFps;

  double get currentMemoryUsageMB {
    return _lastMemoryUsage / 1024 / 1024;
  }

  // Scroll tracking
  void startScrollTracking(String scrollableId) {
    startOperation('scroll_$scrollableId');
  }

  void endScrollTracking(String scrollableId) {
    endOperation('scroll_$scrollableId');
  }

  // Performance snapshot for reporting
  Map<String, dynamic> getPerformanceSnapshot() {
    final frameDropRate = _totalFrames > 0 ? (_frameDrops / _totalFrames) * 100 : 0.0;
    
    return {
      'fps': _currentFps.round(),
      'frame_drops': _frameDrops,
      'frame_drop_rate': frameDropRate,
      'total_frames': _totalFrames,
      'memory_usage_mb': currentMemoryUsageMB.round(),
      'is_performance_good': isPerformanceGood,
      'is_memory_healthy': isMemoryHealthy,
    };
  }
}

class PerformanceMetric {
  final String operationName;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  const PerformanceMetric({
    required this.operationName,
    required this.duration,
    required this.timestamp,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation_name': operationName,
      'duration_ms': duration.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
      'additional_data': additionalData,
    };
  }

  factory PerformanceMetric.fromJson(Map<String, dynamic> json) {
    return PerformanceMetric(
      operationName: json['operation_name'],
      duration: Duration(milliseconds: json['duration_ms']),
      timestamp: DateTime.parse(json['timestamp']),
      additionalData: json['additional_data'],
    );
  }
}

class PerformanceReport {
  final int totalOperations;
  final Duration averageDuration;
  final List<PerformanceMetric> slowOperations;
  final List<PerformanceMetric> memoryMetrics;
  final DateTime reportGeneratedAt;

  const PerformanceReport({
    required this.totalOperations,
    required this.averageDuration,
    required this.slowOperations,
    required this.memoryMetrics,
    required this.reportGeneratedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_operations': totalOperations,
      'average_duration_ms': averageDuration.inMilliseconds,
      'slow_operations': slowOperations.map((op) => op.toJson()).toList(),
      'memory_metrics_count': memoryMetrics.length,
      'report_generated_at': reportGeneratedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    final performanceService = PerformanceService();
    final snapshot = performanceService.getPerformanceSnapshot();
    
    return '''
Performance Report (${reportGeneratedAt.toString()})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Total Operations: $totalOperations
⏱️  Average Duration: ${averageDuration.inMilliseconds}ms
🐌 Slow Operations (>1000ms): ${slowOperations.length}
💾 Memory Checks: ${memoryMetrics.length}

🎯 Current Performance:
  • FPS: ${snapshot['fps']} (Target: 60)
  • Frame Drops: ${snapshot['frame_drops']} (${snapshot['frame_drop_rate'].toStringAsFixed(1)}%)
  • Memory: ${snapshot['memory_usage_mb']}MB
  • Status: ${snapshot['is_performance_good'] ? '✅ Good' : '⚠️ Poor'}

${slowOperations.isNotEmpty ? '''
Slowest Operations:
${slowOperations.take(5).map((op) => '  • ${op.operationName}: ${op.duration.inMilliseconds}ms').join('\n')}
''' : ''}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''';
  }
}

// 성능 모니터링을 위한 헬퍼 클래스
class PerformanceWidget extends StatelessWidget {
  final Widget child;
  final String operationName;

  const PerformanceWidget({
    super.key,
    required this.child,
    required this.operationName,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        PerformanceService().startOperation('widget_build_$operationName');
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PerformanceService().endOperation('widget_build_$operationName');
        });
        
        return child;
      },
    );
  }
}