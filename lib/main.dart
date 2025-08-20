import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/env.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final logger = Logger();
  
  try {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Initialize Supabase
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    
    logger.i('App initialized successfully');
  } catch (error, stackTrace) {
    logger.e('Failed to initialize app', error: error, stackTrace: stackTrace);
  }
  
  runApp(
    const ProviderScope(
      child: IttemApp(),
    ),
  );
}