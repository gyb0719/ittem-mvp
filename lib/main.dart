import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/env.dart';
import 'app/app.dart';
import 'services/image_cache_service.dart';
import 'services/performance_service.dart';
import 'theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final logger = Logger();
  
  try {
    // Initialize environment variables first
    await Env.initialize();
    logger.i('Environment configuration loaded: ${Env.appEnv}');
    
    // Validate required environment variables
    if (Env.isDevelopment) {
      try {
        Env.validateRequiredEnvVars();
        logger.i('Environment variables validation passed');
      } catch (e) {
        logger.w('Environment validation failed: $e');
        // In development, continue with default values
      }
    } else {
      Env.validateRequiredEnvVars();
    }
    
    // Initialize Hive
    await Hive.initFlutter();
    logger.i('Hive initialized');
    
    // Initialize Theme Service
    await ThemeService.initialize();
    logger.i('Theme service initialized');
    
    // Initialize Image Cache Service (skip on web)
    if (!kIsWeb) {
      await ImageCacheService.initialize();
      logger.i('Image cache service initialized');
    } else {
      logger.i('Image cache service skipped (web platform)');
    }
    
    // Initialize Performance Service
    PerformanceService().startMonitoring();
    logger.i('Performance monitoring started');
    
    // Initialize Supabase
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    logger.i('Supabase initialized');
    
    // Debug: Print environment configuration in development
    if (Env.isDevelopment && Env.enableLogging) {
      logger.d('Environment variables: ${Env.getAllEnvVars()}');
    }
    
    logger.i('App initialized successfully');
  } catch (error, stackTrace) {
    logger.e('Failed to initialize app', error: error, stackTrace: stackTrace);
    // In production, we might want to show an error screen instead of crashing
    rethrow;
  }
  
  runApp(
    const ProviderScope(
      child: IttemApp(),
    ),
  );
}