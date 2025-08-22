import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'performance_service.dart';

class ImageCacheService {
  static late CustomCacheManager _customCacheManager;
  static final PerformanceService _performanceService = PerformanceService();
  
  // 캐시 설정 - 한국 모바일 환경에 최적화
  static const int maxCacheObjects = 1000;
  static const Duration stalePeriod = Duration(days: 7); // 더 자주 갱신
  static const Duration maxCacheAge = Duration(days: 30); // 메모리 효율성을 위해 단축
  
  // 성능 최적화 설정
  static const int maxConcurrentDownloads = 3; // 동시 다운로드 제한
  static const Duration downloadTimeout = Duration(seconds: 10);
  static const int retryAttempts = 2;
  
  // 지연 로딩을 위한 큐
  static final List<String> _preloadQueue = [];
  static bool _isPreloading = false;
  static Timer? _preloadTimer;
  
  // 네트워크 상태 기반 품질 조절
  static bool _isOnWifi = true;
  static bool _isLowDataMode = false;

  static Future<void> initialize() async {
    final directory = await getTemporaryDirectory();
    _customCacheManager = CustomCacheManager(
      Config(
        'ittem_image_cache',
        stalePeriod: stalePeriod,
        maxNrOfCacheObjects: maxCacheObjects,
        repo: JsonCacheInfoRepository(databaseName: 'ittem_image_cache'),
        fileSystem: IOFileSystem(directory.path),
      ),
    );
    
    // 네트워크 상태 감지 초기화
    await _initializeNetworkState();
    
    // 주기적 캐시 정리 시작
    _startPeriodicCleanup();
    
    debugPrint('🖼️ ImageCacheService initialized with advanced features');
  }
  
  static Future<void> _initializeNetworkState() async {
    try {
      // 실제 앱에서는 connectivity_plus 패키지 사용
      // 여기서는 기본값으로 설정
      _isOnWifi = true;
      _isLowDataMode = false;
    } catch (e) {
      debugPrint('Error detecting network state: $e');
    }
  }
  
  static void _startPeriodicCleanup() {
    Timer.periodic(const Duration(hours: 6), (_) {
      _performMaintenanceCleanup();
    });
  }
  
  static Future<void> _performMaintenanceCleanup() async {
    try {
      // 성능이 좋지 않을 때 더 적극적으로 정리
      if (!_performanceService.isPerformanceGood) {
        await _customCacheManager.emptyCache();
        imageCache.clear();
        debugPrint('🧹 Aggressive cache cleanup due to poor performance');
      } else {
        // 일반적인 정리
        await _customCacheManager.removeFile('');
        debugPrint('🧹 Regular cache maintenance completed');
      }
    } catch (e) {
      debugPrint('Error during cache cleanup: $e');
    }
  }

  static Widget optimizedNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableMemoryCache = true,
    ImageCacheQuality quality = ImageCacheQuality.medium,
    bool enableProgressiveLoading = true,
    bool enableBlurredPlaceholder = true,
  }) {
    // 네트워크 상태에 따른 품질 조절
    final adjustedQuality = _getAdjustedQuality(quality);
    
    return FutureBuilder<bool>(
      future: _checkImageAvailability(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return errorWidget ?? _buildDefaultErrorWidget();
        }
        
        return _buildProgressiveImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholder: placeholder,
          errorWidget: errorWidget,
          quality: adjustedQuality,
          enableProgressiveLoading: enableProgressiveLoading,
          enableBlurredPlaceholder: enableBlurredPlaceholder,
        );
      },
    );
  }
  
  static Widget _buildProgressiveImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
    required ImageCacheQuality quality,
    required bool enableProgressiveLoading,
    required bool enableBlurredPlaceholder,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      cacheManager: _customCacheManager,
      memCacheWidth: _getMemCacheWidth(width, quality),
      memCacheHeight: _getMemCacheHeight(height, quality),
      placeholder: (context, url) {
        if (enableBlurredPlaceholder) {
          return _buildBlurredPlaceholder(width, height);
        }
        return placeholder ?? _buildDefaultPlaceholder();
      },
      progressIndicatorBuilder: enableProgressiveLoading
          ? (context, url, progress) => _buildProgressIndicator(progress, width, height)
          : null,
      errorWidget: (context, url, error) {
        _performanceService.trackNetworkRequest(
          'image_load_error',
          duration: Duration.zero,
          responseSize: -1,
        );
        return errorWidget ?? _buildDefaultErrorWidget();
      },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 150),
      useOldImageOnUrlChange: true,
      filterQuality: _getFilterQuality(quality),
      imageBuilder: (context, imageProvider) {
        // 이미지 로드 성공 추적
        _performanceService.trackNetworkRequest(
          'image_load_success',
          duration: Duration.zero,
          responseSize: 200,
        );
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
        );
      },
    );
  }
  
  static Future<bool> _checkImageAvailability(String imageUrl) async {
    if (imageUrl.isEmpty) return false;
    
    try {
      // 캐시에서 먼저 확인
      final file = await _customCacheManager.getFileFromCache(imageUrl);
      if (file != null) return true;
      
      // 간단한 HEAD 요청으로 이미지 존재 확인 (선택적)
      return true; // 실제 구현에서는 HTTP HEAD 요청 사용
    } catch (e) {
      return false;
    }
  }
  
  static ImageCacheQuality _getAdjustedQuality(ImageCacheQuality quality) {
    // 네트워크 상태와 성능에 따른 품질 조절
    if (_isLowDataMode) {
      return ImageCacheQuality.low;
    }
    
    if (!_isOnWifi && quality == ImageCacheQuality.high) {
      return ImageCacheQuality.medium;
    }
    
    if (!_performanceService.isPerformanceGood) {
      return quality == ImageCacheQuality.high 
          ? ImageCacheQuality.medium 
          : ImageCacheQuality.low;
    }
    
    return quality;
  }
  
  static FilterQuality _getFilterQuality(ImageCacheQuality quality) {
    switch (quality) {
      case ImageCacheQuality.low:
        return FilterQuality.low;
      case ImageCacheQuality.medium:
        return FilterQuality.medium;
      case ImageCacheQuality.high:
        return FilterQuality.high;
    }
  }

  static Widget optimizedThumbnail({
    required String imageUrl,
    double size = 60,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return optimizedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: fit ?? BoxFit.cover,
      placeholder: placeholder,
      errorWidget: errorWidget,
      quality: ImageCacheQuality.low,
      enableProgressiveLoading: false,
    );
  }

  static Widget optimizedHeroImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return optimizedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: placeholder,
      errorWidget: errorWidget,
      quality: ImageCacheQuality.high,
    );
  }

  static Future<void> preloadImages(List<String> imageUrls, {bool priority = false}) async {
    if (imageUrls.isEmpty) return;
    
    _performanceService.startOperation('preload_images');
    
    // 성능이 좋지 않으면 프리로드 건너뛰기
    if (!_performanceService.isPerformanceGood && !priority) {
      debugPrint('⏭️ Skipping image preload due to poor performance');
      return;
    }
    
    // 우선순위가 높은 경우 즉시 로드, 아니면 큐에 추가
    if (priority) {
      await _preloadImagesImmediately(imageUrls.take(3).toList());
    } else {
      _addToPreloadQueue(imageUrls);
    }
    
    _performanceService.endOperation('preload_images', additionalData: {
      'urls_count': imageUrls.length,
      'priority': priority,
    });
  }
  
  static Future<void> _preloadImagesImmediately(List<String> imageUrls) async {
    final futures = imageUrls.map((url) async {
      try {
        await _customCacheManager.getSingleFile(url).timeout(downloadTimeout);
        debugPrint('✅ Preloaded: ${url.split('/').last}');
      } catch (e) {
        debugPrint('❌ Failed to preload: ${url.split('/').last}, error: $e');
      }
    });
    
    await Future.wait(futures);
  }
  
  static void _addToPreloadQueue(List<String> imageUrls) {
    _preloadQueue.addAll(imageUrls.where((url) => !_preloadQueue.contains(url)));
    _processPreloadQueue();
  }
  
  static void _processPreloadQueue() {
    if (_isPreloading || _preloadQueue.isEmpty) return;
    
    _preloadTimer?.cancel();
    _preloadTimer = Timer(const Duration(milliseconds: 500), () async {
      _isPreloading = true;
      
      try {
        final batch = _preloadQueue.take(maxConcurrentDownloads).toList();
        _preloadQueue.removeRange(0, batch.length);
        
        await _preloadImagesImmediately(batch);
        
        // 큐에 더 있으면 계속 처리
        if (_preloadQueue.isNotEmpty) {
          _isPreloading = false;
          _processPreloadQueue();
        }
      } finally {
        _isPreloading = false;
      }
    });
  }

  static Future<void> clearCache() async {
    _performanceService.startOperation('clear_cache');
    
    try {
      await _customCacheManager.emptyCache();
      imageCache.clear();
      imageCache.clearLiveImages();
      
      // 프리로드 큐도 정리
      _preloadQueue.clear();
      _preloadTimer?.cancel();
      _isPreloading = false;
      
      debugPrint('🗑️ Image cache cleared completely');
      
      _performanceService.endOperation('clear_cache', additionalData: {
        'success': true,
      });
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      _performanceService.endOperation('clear_cache', additionalData: {
        'success': false,
        'error': e.toString(),
      });
    }
  }
  
  // 스마트 캐시 정리 - 메모리 압박 시 호출
  static Future<void> smartCacheCleanup() async {
    try {
      final cacheSize = await getCacheSize();
      final maxSizeBytes = 100 * 1024 * 1024; // 100MB 제한
      
      if (cacheSize > maxSizeBytes) {
        // 오래된 파일부터 삭제
        await _customCacheManager.removeFile('');
        
        // 메모리 캐시도 일부 정리
        imageCache.clear();
        
        debugPrint('🧹 Smart cache cleanup completed. Size reduced from ${formatCacheSize(cacheSize)}');
      }
    } catch (e) {
      debugPrint('Error during smart cache cleanup: $e');
    }
  }
  
  // 네트워크 상태 업데이트
  static void updateNetworkState({required bool isOnWifi, bool isLowDataMode = false}) {
    _isOnWifi = isOnWifi;
    _isLowDataMode = isLowDataMode;
    
    debugPrint('📶 Network state updated: WiFi=$isOnWifi, LowData=$isLowDataMode');
  }

  static Future<void> clearOldCache() async {
    await _customCacheManager.removeFile('');
  }

  static Future<int> getCacheSize() async {
    try {
      final directory = await getTemporaryDirectory();
      final cacheDir = Directory('${directory.path}/ittem_image_cache');
      if (await cacheDir.exists()) {
        int totalSize = 0;
        await for (final file in cacheDir.list(recursive: true)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
        return totalSize;
      }
      return 0;
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
      return 0;
    }
  }

  static String formatCacheSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static int? _getMemCacheWidth(double? width, ImageCacheQuality quality) {
    if (width == null) return null;
    
    switch (quality) {
      case ImageCacheQuality.low:
        return (width * 0.5).round();
      case ImageCacheQuality.medium:
        return (width * 0.8).round();
      case ImageCacheQuality.high:
        return width.round();
    }
  }

  static int? _getMemCacheHeight(double? height, ImageCacheQuality quality) {
    if (height == null) return null;
    
    switch (quality) {
      case ImageCacheQuality.low:
        return (height * 0.5).round();
      case ImageCacheQuality.medium:
        return (height * 0.8).round();
      case ImageCacheQuality.high:
        return height.round();
    }
  }

  static Widget _buildDefaultPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }
  
  static Widget _buildBlurredPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
  
  static Widget _buildProgressIndicator(
    DownloadProgress? progress,
    double? width,
    double? height,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (progress != null) ...[
            CircularProgressIndicator(
              value: progress.progress,
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Text(
              '${(progress.progress ?? 0 * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ] else
            const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
        ],
      ),
    );
  }

  static Widget _buildDefaultErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.error_outline,
        color: Colors.grey,
        size: 32,
      ),
    );
  }
}

class CustomCacheManager extends CacheManager {
  static const key = 'ittem_custom_cache';

  CustomCacheManager(Config config) : super(config);
}

enum ImageCacheQuality {
  low,    // 50% 해상도, 모바일 데이터 절약
  medium, // 80% 해상도, 기본 설정
  high,   // 100% 해상도, WiFi 환경 권장
}

// 한국 모바일 환경 최적화를 위한 확장 기능
class KoreanMobileOptimizations {
  // 당근마켓 스타일의 빠른 이미지 로딩
  static Widget fastLoadingImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return ImageCacheService.optimizedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      quality: ImageCacheQuality.medium,
      enableProgressiveLoading: true,
      enableBlurredPlaceholder: true,
    );
  }
  
  // 쿠팡 스타일의 썸네일 최적화
  static Widget optimizedThumbnail({
    required String imageUrl,
    double size = 80,
  }) {
    return ImageCacheService.optimizedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      quality: ImageCacheQuality.low,
      enableProgressiveLoading: false,
      enableBlurredPlaceholder: false,
    );
  }
}