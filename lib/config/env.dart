import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // Private constructor to prevent instantiation
  Env._();

  /// Initialize environment variables from the appropriate .env file
  static Future<void> initialize() async {
    const flavor = String.fromEnvironment('FLUTTER_FLAVOR', defaultValue: 'dev');
    
    String envFile;
    switch (flavor) {
      case 'prod':
      case 'production':
        envFile = '.env.prod';
        break;
      case 'dev':
      case 'development':
      default:
        envFile = '.env.dev';
        break;
    }

    try {
      await dotenv.load(fileName: envFile);
    } catch (e) {
      // Fallback to .env.dev if the specified file doesn't exist
      try {
        await dotenv.load(fileName: '.env.dev');
      } catch (fallbackError) {
        throw Exception('Failed to load environment configuration: $fallbackError');
      }
    }
  }

  // Core configuration
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'dev';

  // Supabase configuration
  static String get supabaseUrl => 
      dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';
  
  static String get supabaseAnonKey => 
      dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key';

  // Google Maps configuration
  static String get googleMapsAndroidApiKey => 
      dotenv.env['GOOGLE_MAPS_ANDROID_API_KEY'] ?? 'your-maps-api-key';

  // PortOne payment configuration
  static String get portoneUserCode => 
      dotenv.env['PORTONE_USER_CODE'] ?? 'imp_your_code';
  
  static String get portonePg => 
      dotenv.env['PORTONE_PG'] ?? 'html5_inicis';
  
  static String get portoneMerchantUidPrefix => 
      dotenv.env['PORTONE_MERCHANT_UID_PREFIX'] ?? 'ittem_';

  // Sentry configuration
  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';

  // Development configuration
  static bool get enableLogging => 
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true' || isDevelopment;
  
  static bool get debugMode => 
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true' || isDevelopment;

  // Legacy field names for compatibility
  static String get googleMapsApiKey => googleMapsAndroidApiKey;
  static String get portoneApiKey => portoneUserCode;

  // Computed values
  static bool get isProduction => appEnv == 'prod';
  static bool get isDevelopment => appEnv == 'dev';

  // Validation helpers
  static void validateRequiredEnvVars() {
    final requiredVars = {
      'SUPABASE_URL': supabaseUrl,
      'SUPABASE_ANON_KEY': supabaseAnonKey,
      'GOOGLE_MAPS_ANDROID_API_KEY': googleMapsAndroidApiKey,
      'PORTONE_USER_CODE': portoneUserCode,
    };

    final missingVars = <String>[];
    for (final entry in requiredVars.entries) {
      if (entry.value.isEmpty || 
          entry.value.startsWith('your-') || 
          entry.value == 'imp_your_code') {
        missingVars.add(entry.key);
      }
    }

    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing or invalid required environment variables: ${missingVars.join(', ')}'
      );
    }
  }

  // Debug helper
  static Map<String, String> getAllEnvVars() {
    return {
      'APP_ENV': appEnv,
      'SUPABASE_URL': supabaseUrl.replaceRange(8, supabaseUrl.length - 15, '***'),
      'SUPABASE_ANON_KEY': '${supabaseAnonKey.substring(0, 8)}***',
      'GOOGLE_MAPS_ANDROID_API_KEY': '${googleMapsAndroidApiKey.substring(0, 8)}***',
      'PORTONE_USER_CODE': portoneUserCode,
      'PORTONE_PG': portonePg,
      'PORTONE_MERCHANT_UID_PREFIX': portoneMerchantUidPrefix,
      'SENTRY_DSN': sentryDsn.isNotEmpty ? 'SET' : 'NOT_SET',
      'ENABLE_LOGGING': enableLogging.toString(),
      'DEBUG_MODE': debugMode.toString(),
    };
  }
}