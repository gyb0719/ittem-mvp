# Flutter 관련 ProGuard 규칙
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase 관련 규칙
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Supabase 관련 규칙
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Google Maps 관련 규칙
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# 카카오 로그인 관련 규칙
-keep class com.kakao.** { *; }
-dontwarn com.kakao.**

# JSON 직렬화 관련 규칙
-keepattributes Signature
-keepattributes *Annotation*
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Retrofit 및 OkHttp 관련 규칙
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-keep,allowshrinking,allowoptimization interface retrofit2.Call
-keep,allowshrinking,allowoptimization class retrofit2.Response
-dontwarn okio.**
-dontwarn retrofit2.**

# 일반적인 최적화 규칙
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

# 디버깅을 위한 라인 번호 유지 (선택사항)
-keepattributes SourceFile,LineNumberTable

# 앱 특정 모델 클래스 유지 (필요에 따라 추가)
-keep class com.ittem.app.model.** { *; }