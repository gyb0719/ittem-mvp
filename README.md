# Ittem - 지역 기반 물건 대여 플랫폼

Flutter로 개발된 지역 기반 물건 대여 플랫폼 모바일 앱입니다.

## 주요 기능

- **위치 기반 서비스**: GPS를 통한 현재 위치 파악 및 지역 범위 내 사용자 간 거래
- **물건 대여**: 물건 등록, 검색, 필터링, 대여 요청/승인 시스템
- **실시간 채팅**: 대여자와 임대인 간 실시간 소통
- **지도 연동**: Google Maps를 통한 위치 기반 아이템 검색
- **사용자 관리**: 프로필, 신뢰도 점수, 리뷰 시스템

## 기술 스택

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Maps**: Google Maps Flutter
- **Location**: Geolocator
- **Local Storage**: Hive
- **HTTP Client**: Dio
- **UI/UX**: Material Design 3 with Apple-style design

## 설치 및 실행

### 1. 사전 요구사항

- Flutter SDK 3.x 이상
- Android Studio 또는 VS Code
- Android SDK (Android 개발용)

### 2. 프로젝트 설정

```bash
# 의존성 설치
flutter pub get

# 코드 분석
flutter analyze

# 테스트 실행
flutter test
```

### 3. Google Maps API 설정

Google Maps를 사용하기 위해 API 키가 필요합니다:

1. [Google Cloud Console](https://console.cloud.google.com/)에서 프로젝트 생성
2. Maps SDK for Android 활성화
3. API 키 생성
4. `android/app/src/main/AndroidManifest.xml` 파일에서 `YOUR_GOOGLE_MAPS_API_KEY_HERE`를 실제 API 키로 교체

### 4. 실행

```bash
# Android 에뮬레이터 또는 기기에서 실행
flutter run

# 또는 디버그 APK 빌드
flutter build apk --debug
```

## 주요 화면

### 1. 홈 화면
- 카테고리별 아이템 브라우징
- 인기 아이템 표시
- 위치 기반 검색

### 2. 아이템 목록
- 필터링 및 정렬 기능
- 내 대여 목록 관리
- 아이템 등록

### 3. 채팅
- 실시간 메시징
- 대여 관련 문의

### 4. 프로필
- 사용자 정보 관리
- 신뢰도 및 리뷰 확인
- 설정 관리

### 5. 지도
- 위치 기반 아이템 검색
- 거리 및 카테고리 필터

## 다음 단계

현재 구현된 기본 구조를 바탕으로 다음 기능들을 추가할 수 있습니다:

1. **인증 시스템**: 회원가입, 로그인, 소셜 로그인
2. **실제 채팅**: WebSocket 또는 Firebase를 통한 실시간 채팅
3. **결제 연동**: 아임포트, 토스페이먼츠 등
4. **푸시 알림**: Firebase Cloud Messaging
5. **이미지 업로드**: Firebase Storage 또는 AWS S3
6. **백엔드 연동**: REST API 또는 GraphQL
