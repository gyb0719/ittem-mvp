# 배포 가이드

이 문서는 Ittem MVP 앱의 다양한 환경으로의 배포 방법을 안내합니다.

## 📦 빌드 종류

### 개발 빌드 (Development)

개발 및 테스트 목적의 빌드입니다.

```bash
# APK 빌드 (디버그)
flutter build apk --debug

# 개발 환경 변수 사용
flutter build apk --debug --dart-define=FLUTTER_FLAVOR=dev

# 번들 빌드 (디버그)
flutter build appbundle --debug --dart-define=FLUTTER_FLAVOR=dev
```

### 스테이징 빌드 (Staging)

운영 환경과 유사한 테스트 환경용 빌드입니다.

```bash
# 스테이징 APK
flutter build apk --release --dart-define=FLUTTER_FLAVOR=staging

# 스테이징 번들
flutter build appbundle --release --dart-define=FLUTTER_FLAVOR=staging
```

### 운영 빌드 (Production)

실제 서비스용 빌드입니다.

```bash
# 운영 APK
flutter build apk --release --dart-define=FLUTTER_FLAVOR=prod

# 운영 번들 (Google Play Store 업로드용)
flutter build appbundle --release --dart-define=FLUTTER_FLAVOR=prod
```

## 🔧 환경별 설정

### 환경변수 관리

각 환경별로 적절한 `.env` 파일을 사용합니다:

#### .env.dev (개발)
```env
APP_ENV=dev
SUPABASE_URL=https://dev-project.supabase.co
SUPABASE_ANON_KEY=dev-anon-key
GOOGLE_MAPS_ANDROID_API_KEY=dev-maps-key
PORTONE_USER_CODE=imp_dev_code
PORTONE_PG=html5_inicis.sandbox
ENABLE_LOGGING=true
DEBUG_MODE=true
```

#### .env.staging (스테이징)
```env
APP_ENV=staging
SUPABASE_URL=https://staging-project.supabase.co
SUPABASE_ANON_KEY=staging-anon-key
GOOGLE_MAPS_ANDROID_API_KEY=staging-maps-key
PORTONE_USER_CODE=imp_staging_code
PORTONE_PG=html5_inicis.sandbox
ENABLE_LOGGING=true
DEBUG_MODE=false
```

#### .env.prod (운영)
```env
APP_ENV=prod
SUPABASE_URL=https://prod-project.supabase.co
SUPABASE_ANON_KEY=prod-anon-key
GOOGLE_MAPS_ANDROID_API_KEY=prod-maps-key
PORTONE_USER_CODE=imp_prod_code
PORTONE_PG=html5_inicis
ENABLE_LOGGING=false
DEBUG_MODE=false
SENTRY_DSN=https://your-sentry-dsn
```

## 🤖 Android 배포

### 1. 키스토어 생성 및 관리

#### 키스토어 생성
```bash
# 릴리즈용 키스토어 생성
keytool -genkey -v -keystore ~/ittem-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias ittem
```

#### 키스토어 정보 설정

`android/key.properties` 파일 생성:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=ittem
storeFile=../ittem-release-key.keystore
```

#### build.gradle 설정

`android/app/build.gradle` 수정:
```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 2. Google Play Store 배포

#### 앱 번들 생성
```bash
# 운영용 앱 번들 빌드
flutter build appbundle --release --dart-define=FLUTTER_FLAVOR=prod

# 빌드 결과 확인
ls -la build/app/outputs/bundle/release/
```

#### 앱 서명 확인
```bash
# 서명 정보 확인
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

#### Google Play Console 업로드

1. [Google Play Console](https://play.google.com/console) 로그인
2. 앱 선택 → 출시 관리 → 앱 번들 탐색기
3. 새 출시 버전 만들기
4. `app-release.aab` 파일 업로드
5. 출시 노트 작성 및 검토
6. 출시 또는 검토를 위해 제출

### 3. 직접 배포 (APK)

#### APK 생성
```bash
# 운영용 APK 빌드
flutter build apk --release --dart-define=FLUTTER_FLAVOR=prod

# 빌드 결과 확인
ls -la build/app/outputs/flutter-apk/
```

#### APK 설치 테스트
```bash
# 연결된 디바이스에 설치
adb install build/app/outputs/flutter-apk/app-release.apk

# 설치 확인
adb shell pm list packages | grep com.example.ittem_app
```

## 🍎 iOS 배포 (향후 지원)

### App Store Connect 배포

```bash
# iOS 빌드
flutter build ios --release --dart-define=FLUTTER_FLAVOR=prod

# Xcode에서 Archive 생성
# Product → Archive → Upload to App Store
```

## 🚀 CI/CD 파이프라인

### GitHub Actions 설정

`.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'zulu'
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.9.0'
        channel: 'stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Generate code
      run: flutter packages pub run build_runner build --delete-conflicting-outputs
    
    - name: Run tests
      run: flutter test
    
    - name: Build APK
      run: flutter build apk --release --dart-define=FLUTTER_FLAVOR=prod
      env:
        SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
        SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
        GOOGLE_MAPS_ANDROID_API_KEY: ${{ secrets.GOOGLE_MAPS_ANDROID_API_KEY }}
        PORTONE_USER_CODE: ${{ secrets.PORTONE_USER_CODE }}
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-release.apk
        path: build/app/outputs/flutter-apk/app-release.apk
    
    - name: Create Release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.ref }}
        release_name: Release ${{ github.ref }}
        draft: false
        prerelease: false
```

### GitLab CI 설정

`.gitlab-ci.yml`:

```yaml
stages:
  - test
  - build
  - deploy

variables:
  FLUTTER_VERSION: "3.9.0"

before_script:
  - apt-get update -qq && apt-get install -y -qq git curl unzip
  - git clone https://github.com/flutter/flutter.git -b stable --depth 1
  - export PATH="$PATH:`pwd`/flutter/bin"
  - flutter doctor
  - flutter pub get

test:
  stage: test
  script:
    - flutter analyze
    - flutter test

build_apk:
  stage: build
  script:
    - flutter build apk --release --dart-define=FLUTTER_FLAVOR=prod
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
    expire_in: 1 week
  only:
    - tags

deploy_production:
  stage: deploy
  script:
    - echo "Deploying to production..."
    # 여기에 배포 스크립트 추가
  only:
    - tags
```

## 📊 배포 검증

### 배포 전 체크리스트

- [ ] 모든 테스트 통과
- [ ] 코드 분석 통과 (`flutter analyze`)
- [ ] 환경변수 검증
- [ ] API 키 유효성 확인
- [ ] 버전 번호 업데이트
- [ ] 빌드 성공 확인
- [ ] 서명 확인 (릴리즈 빌드)

### 배포 후 검증

```bash
# 앱 설치 및 실행 테스트
adb install build/app/outputs/flutter-apk/app-release.apk
adb shell am start -n com.example.ittem_app/.MainActivity

# 로그 모니터링
adb logcat | grep flutter

# 성능 모니터링
flutter run --profile
```

### 롤백 절차

문제 발생 시 이전 버전으로 롤백:

```bash
# 이전 태그로 체크아웃
git checkout tags/v1.0.0

# 긴급 빌드 및 배포
flutter build apk --release --dart-define=FLUTTER_FLAVOR=prod
```

## 🔍 배포 모니터링

### Sentry 연동

```dart
// main.dart에 Sentry 설정
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      options.environment = Env.appEnv;
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

### 성능 모니터링

```dart
// 커스텀 이벤트 추가
Sentry.addBreadcrumb(Breadcrumb(
  message: 'User logged in',
  category: 'auth',
  level: SentryLevel.info,
));
```

## 📈 버전 관리

### 시맨틱 버저닝

```
MAJOR.MINOR.PATCH
1.0.0 → 1.0.1 (패치)
1.0.1 → 1.1.0 (마이너)
1.1.0 → 2.0.0 (메이저)
```

### 버전 업데이트

`pubspec.yaml`:
```yaml
version: 1.0.0+1
# version: major.minor.patch+buildNumber
```

### 태그 생성 및 릴리즈

```bash
# 태그 생성
git tag -a v1.0.0 -m "Release version 1.0.0"

# 태그 푸시
git push origin v1.0.0

# GitHub 릴리즈 생성 (선택)
gh release create v1.0.0 build/app/outputs/flutter-apk/app-release.apk
```

## 🛡️ 보안 고려사항

### 1. API 키 보호
- 환경변수로만 관리
- 코드에 하드코딩 금지
- CI/CD 시크릿 변수 사용

### 2. 코드 난독화
```bash
# 릴리즈 빌드 시 자동 난독화
flutter build apk --release --obfuscate --split-debug-info=./debug-symbols
```

### 3. ProGuard 설정
`android/app/proguard-rules.pro`:
```
# Supabase 관련 클래스 보호
-keep class io.supabase.** { *; }
-keep class com.google.gson.** { *; }
```

이 가이드를 따라 안전하고 효율적인 배포 프로세스를 구축할 수 있습니다.