plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ittem_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.ittem.app"
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Google Maps API Key from dart-define
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = project.findProperty("dart.env.GOOGLE_MAPS_ANDROID_API_KEY") ?: "your-api-key"
    }

    buildTypes {
        release {
            // APK 크기 최소화를 위한 코드 및 리소스 축소
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // 빌드 성능 향상을 위한 설정
            isDebuggable = false
            isJniDebuggable = false
            isRenderscriptDebuggable = false
            isPseudoLocalesEnabled = false
        }
        
        debug {
            isMinifyEnabled = false
            isDebuggable = true
        }
    }
    
    // APK 출력 설정 최적화
    packagingOptions {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/ASL2.0",
                "**/kotlin/**",
                "kotlin/**",
                "**/*.kotlin_metadata",
                "**/*.version",
                "**/*.properties"
            )
        }
    }
    
    // 빌드 성능 최적화
    dexOptions {
        javaMaxHeapSize = "4g"
        preDexLibraries = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring support
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
