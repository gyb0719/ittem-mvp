# 개발 환경 설정 가이드

이 문서는 Ittem MVP 프로젝트의 개발 환경 설정에 대한 상세한 가이드입니다.

## 📋 사전 요구사항

### 필수 도구

| 도구 | 버전 | 설치 링크 |
|------|------|-----------|
| Flutter SDK | 3.9.0+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.0.0+ | Flutter와 함께 설치됨 |
| Android Studio | 최신 | [developer.android.com](https://developer.android.com/studio) |
| VS Code | 최신 (선택) | [code.visualstudio.com](https://code.visualstudio.com/) |
| Git | 2.30+ | [git-scm.com](https://git-scm.com/) |

### Android 개발 환경

1. **Android SDK 설정**
   ```bash
   # Android Studio를 통해 다음 컴포넌트 설치:
   # - Android SDK Platform-Tools
   # - Android SDK Build-Tools (33.0.0+)
   # - Android SDK Platform (API 33+)
   # - Android Emulator
   ```

2. **Android 에뮬레이터 설정**
   ```bash
   # AVD Manager에서 다음 사양으로 에뮬레이터 생성:
   # - API Level: 33 (Android 13) 이상
   # - RAM: 2GB 이상
   # - Storage: 8GB 이상
   # - Hardware: x86_64 (Intel HAXM 권장)
   ```

### VS Code 확장 프로그램 (권장)

```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "formulahendry.auto-rename-tag",
    "streetsidesoftware.code-spell-checker"
  ]
}
```

## 🛠️ 개발 환경 설정

### 1. 프로젝트 클론 및 설정

```bash
# 1. 저장소 클론
git clone https://github.com/your-username/ittem-mvp.git
cd ittem-mvp

# 2. Flutter 환경 확인
flutter doctor

# 3. 의존성 설치
flutter pub get

# 4. 환경변수 파일 생성
cp .env.example .env.dev
```

### 2. 환경변수 설정

`.env.dev` 파일을 편집하여 개발용 API 키를 설정하세요:

```env
# 개발 환경 설정
APP_ENV=dev
ENABLE_LOGGING=true
DEBUG_MODE=true

# Supabase 설정 (개발용 프로젝트)
SUPABASE_URL=https://your-dev-project.supabase.co
SUPABASE_ANON_KEY=your-dev-anon-key

# Google Maps API 키 (개발용)
GOOGLE_MAPS_ANDROID_API_KEY=your-dev-maps-key

# PortOne 설정 (테스트 모드)
PORTONE_USER_CODE=imp_test_code
PORTONE_PG=html5_inicis.sandbox
PORTONE_MERCHANT_UID_PREFIX=ittem_dev_
```

### 3. 코드 생성 실행

Freezed 및 JSON 직렬화 코드 생성:

```bash
# 한 번 생성
flutter packages pub run build_runner build

# 파일 변경 감지 및 자동 재생성 (개발 중 유용)
flutter packages pub run build_runner watch
```

### 4. Android 설정

#### AndroidManifest.xml 설정

`android/app/src/main/AndroidManifest.xml`에서 다음 권한 확인:

```xml
<!-- 위치 권한 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- 인터넷 권한 -->
<uses-permission android:name="android.permission.INTERNET" />

<!-- 카메라 및 저장소 권한 -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

#### Google Maps API 키 설정

`android/app/src/main/AndroidManifest.xml`의 `<application>` 태그 내에 추가:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${GOOGLE_MAPS_ANDROID_API_KEY}" />
```

## 🚀 실행 및 테스트

### 개발 서버 실행

```bash
# 기본 실행 (개발 환경)
flutter run

# 특정 디바이스에서 실행
flutter run -d android

# 핫 리로드 활성화된 상태로 실행
flutter run --hot
```

### 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/item_model_test.dart

# 커버리지 포함 테스트
flutter test --coverage

# 통합 테스트 (Android 에뮬레이터 필요)
flutter drive --target=test_driver/app.dart
```

### 코드 품질 검사

```bash
# Dart 코드 분석
flutter analyze

# 코드 포맷팅
flutter format .

# 의존성 검사
flutter pub deps
```

## 🔧 개발 도구

### 디버그 도구

1. **Flutter Inspector**
   - VS Code: Ctrl+Shift+P → "Flutter: Open Widget Inspector"
   - 위젯 트리 시각화 및 디버그

2. **Dev Tools**
   ```bash
   # 브라우저에서 dev tools 열기
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

3. **로그 확인**
   ```bash
   # 앱 로그 실시간 확인
   flutter logs
   
   # Android 로그
   adb logcat
   ```

### 성능 프로파일링

```bash
# 성능 프로파일링 모드 실행
flutter run --profile

# 메모리 사용량 확인
flutter run --trace-startup
```

## 🎯 개발 워크플로

### 1. 기능 개발 시작

```bash
# 새 브랜치 생성
git checkout -b feature/new-feature

# 개발 시작
flutter run --hot
```

### 2. 코드 작성 및 테스트

```bash
# 변경사항 확인
flutter analyze
flutter test

# 코드 포맷팅
flutter format .
```

### 3. 커밋 및 푸시

```bash
# 변경사항 커밋
git add .
git commit -m "feat: add new feature"

# 푸시
git push origin feature/new-feature
```

## 📱 디바이스별 설정

### Android 실제 기기 연결

1. **개발자 옵션 활성화**
   - 설정 → 디바이스 정보 → 빌드 번호 7회 터치

2. **USB 디버깅 활성화**
   - 설정 → 개발자 옵션 → USB 디버깅 켜기

3. **기기 연결 확인**
   ```bash
   adb devices
   flutter devices
   ```

### iOS 설정 (향후 지원)

```bash
# iOS 시뮬레이터 실행
open -a Simulator

# iOS 기기에 설치
flutter run -d ios
```

## 🐛 문제 해결

### 일반적인 문제

1. **Flutter Doctor 경고**
   ```bash
   flutter doctor --verbose
   # 출력된 경고사항에 따라 해결
   ```

2. **의존성 충돌**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **Android 라이선스 문제**
   ```bash
   flutter doctor --android-licenses
   # 모든 라이선스에 'y' 입력
   ```

4. **Supabase 연결 실패**
   ```bash
   # .env.dev 파일 확인
   # SUPABASE_URL과 SUPABASE_ANON_KEY 값 검증
   ```

5. **Google Maps 표시 안됨**
   ```bash
   # AndroidManifest.xml의 API 키 확인
   # Google Cloud Console에서 API 활성화 확인
   ```

### 로그 디버깅

```bash
# 상세 로그 출력
flutter run --verbose

# 특정 태그 로그만 확인
adb logcat -s flutter
```

## 🔄 자동화 스크립트

개발 효율성을 위한 유용한 스크립트들:

### setup.sh (개발 환경 초기 설정)

```bash
#!/bin/bash
echo "Setting up development environment..."

# Flutter 의존성 설치
flutter pub get

# 환경변수 파일 생성
if [ ! -f .env.dev ]; then
    cp .env.example .env.dev
    echo "Created .env.dev file. Please configure your API keys."
fi

# 코드 생성
flutter packages pub run build_runner build

# 분석 및 테스트
flutter analyze
flutter test

echo "Development environment setup complete!"
```

### run-dev.sh (개발 실행)

```bash
#!/bin/bash
echo "Starting development server..."

# 코드 생성 감시 (백그라운드)
flutter packages pub run build_runner watch &

# 앱 실행 (핫 리로드)
flutter run --hot
```

이 가이드를 통해 Ittem MVP 프로젝트의 개발 환경을 성공적으로 설정하고 효율적으로 개발할 수 있습니다.