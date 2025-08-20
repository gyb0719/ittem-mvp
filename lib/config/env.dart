class Env {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  static const String googleMapsAndroidApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_ANDROID_API_KEY',
    defaultValue: 'your-maps-api-key',
  );

  static const String portoneUserCode = String.fromEnvironment(
    'PORTONE_USER_CODE',
    defaultValue: 'imp_your_code',
  );

  static const String portonePg = String.fromEnvironment(
    'PORTONE_PG',
    defaultValue: 'html5_inicis',
  );

  static const String portoneMerchantUidPrefix = String.fromEnvironment(
    'PORTONE_MERCHANT_UID_PREFIX',
    defaultValue: 'ittem_',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  // Legacy field names for compatibility
  static String get googleMapsApiKey => googleMapsAndroidApiKey;
  static String get portoneApiKey => portoneUserCode;

  // Computed values
  static bool get isProduction => appEnv == 'prod';
  static bool get isDevelopment => appEnv == 'dev';
  static bool get enableLogging => !isProduction;
}