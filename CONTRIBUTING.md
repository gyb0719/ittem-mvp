# 기여 가이드 (Contributing Guide)

Ittem MVP 프로젝트에 기여해주셔서 감사합니다! 이 가이드는 효과적이고 일관된 기여를 위한 가이드라인을 제공합니다.

## 📋 목차

- [기여 방법](#기여-방법)
- [개발 환경 설정](#개발-환경-설정)
- [코딩 컨벤션](#코딩-컨벤션)
- [커밋 메시지 가이드](#커밋-메시지-가이드)
- [Pull Request 가이드](#pull-request-가이드)
- [이슈 리포팅](#이슈-리포팅)
- [코드 리뷰 프로세스](#코드-리뷰-프로세스)

## 🤝 기여 방법

### 기여할 수 있는 영역

- 🐛 **버그 수정**: 발견된 버그를 수정
- ✨ **새 기능**: 새로운 기능 추가
- 📚 **문서화**: README, 가이드, 코드 주석 개선
- 🎨 **UI/UX 개선**: 사용자 인터페이스 향상
- 🔧 **리팩토링**: 코드 품질 및 성능 개선
- 🧪 **테스트**: 테스트 코드 작성 및 개선

### 기여 프로세스

1. **이슈 확인**: 기존 이슈를 확인하거나 새 이슈 생성
2. **Fork**: 본 저장소를 Fork
3. **브랜치 생성**: 기능별 브랜치 생성
4. **개발**: 코드 작성 및 테스트
5. **커밋**: 의미 있는 커밋 메시지로 커밋
6. **Push**: Fork된 저장소에 Push
7. **Pull Request**: 본 저장소로 PR 생성
8. **코드 리뷰**: 리뷰 피드백 반영
9. **머지**: 승인 후 머지

## 🛠️ 개발 환경 설정

자세한 개발 환경 설정은 [DEVELOPMENT.md](./docs/DEVELOPMENT.md)를 참조하세요.

### 빠른 시작

```bash
# 1. Fork 후 클론
git clone https://github.com/your-username/ittem-mvp.git
cd ittem-mvp

# 2. 원본 저장소를 upstream으로 추가
git remote add upstream https://github.com/original-owner/ittem-mvp.git

# 3. 의존성 설치
flutter pub get

# 4. 환경변수 설정
cp .env.example .env.dev
# .env.dev 파일을 실제 값으로 편집

# 5. 코드 생성
flutter packages pub run build_runner build

# 6. 개발 서버 실행
flutter run
```

## 📝 코딩 컨벤션

### Dart 코딩 스타일

프로젝트는 [Effective Dart](https://dart.dev/guides/language/effective-dart) 가이드라인을 따릅니다.

#### 1. 네이밍 컨벤션

```dart
// 클래스: PascalCase
class UserService {}
class ItemRepository {}

// 함수 및 변수: camelCase
void getUserData() {}
String userName = '';

// 상수: lowerCamelCase
const String apiBaseUrl = '';

// 파일명: snake_case
// user_service.dart
// item_repository.dart
```

#### 2. 파일 구조

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party package imports
import 'package:riverpod/riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Local imports
import '../models/user.dart';
import '../services/api_service.dart';
```

#### 3. 클래스 구조

```dart
class ExampleWidget extends StatefulWidget {
  // 1. Static fields
  static const String routeName = '/example';
  
  // 2. Instance fields
  final String title;
  final VoidCallback? onPressed;
  
  // 3. Constructor
  const ExampleWidget({
    super.key,
    required this.title,
    this.onPressed,
  });
  
  // 4. Override methods
  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  // 1. Instance fields
  late String _internalState;
  
  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
    _internalState = widget.title;
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
  
  // 4. Private helper methods
  Widget _buildBody() {
    return Container();
  }
  
  void _handleAction() {
    // Handle action
  }
}
```

### Flutter 위젯 가이드라인

#### 1. 위젯 분리

```dart
// ❌ 잘못된 예: 큰 build 메서드
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Long Title'),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.filter), onPressed: () {}),
        PopupMenuButton(/* ... */),
      ],
    ),
    body: Column(
      children: [
        // 50줄 이상의 복잡한 위젯들...
      ],
    ),
  );
}

// ✅ 올바른 예: 위젯 분리
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
  );
}

Widget _buildAppBar() {
  return TealAppBar(
    title: '제목',
    actions: _buildAppBarActions(),
  );
}

List<Widget> _buildAppBarActions() {
  return [
    IconButton(icon: Icon(Icons.search), onPressed: _onSearch),
    IconButton(icon: Icon(Icons.filter), onPressed: _onFilter),
    _buildPopupMenu(),
  ];
}
```

#### 2. 상수 사용

```dart
class Constants {
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  // Animation duration
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
}
```

### 상태 관리 가이드라인 (Riverpod)

#### 1. Provider 네이밍

```dart
// StateProvider
final counterProvider = StateProvider<int>((ref) => 0);

// FutureProvider
final userDataProvider = FutureProvider<User>((ref) async {
  // fetch user data
});

// StateNotifierProvider
final itemsNotifierProvider = StateNotifierProvider<ItemsNotifier, AsyncValue<List<Item>>>(
  (ref) => ItemsNotifier(ref.watch(itemsRepositoryProvider)),
);
```

#### 2. StateNotifier 구조

```dart
class ItemsNotifier extends StateNotifier<AsyncValue<List<Item>>> {
  final ItemsRepository _repository;
  
  ItemsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadItems();
  }
  
  Future<void> _loadItems() async {
    try {
      final items = await _repository.getAllItems();
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> addItem(Item item) async {
    // 낙관적 업데이트
    final currentItems = state.asData?.value ?? [];
    state = AsyncValue.data([...currentItems, item]);
    
    try {
      await _repository.addItem(item);
      await _loadItems(); // 실제 데이터로 새로고침
    } catch (error) {
      await _loadItems(); // 에러 시 롤백
      rethrow;
    }
  }
}
```

## 💬 커밋 메시지 가이드

### 커밋 메시지 형식

```
<타입>(<범위>): <제목>

<본문>

<푸터>
```

### 타입 (Type)

- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포맷팅, 세미콜론 누락 등 (로직 변경 없음)
- `refactor`: 코드 리팩토링
- `test`: 테스트 코드 추가/수정
- `chore`: 빌드 프로세스, 도구 설정 등

### 예시

```bash
feat(auth): add social login with Kakao

- Implement Kakao SDK integration
- Add login button in social login screen
- Handle authentication flow and token storage

Closes #123

fix(map): resolve marker clustering performance issue

The map was freezing when displaying more than 100 markers.
Implemented marker clustering to improve performance.

- Add clustering algorithm for nearby markers
- Optimize marker rendering
- Add loading state during marker updates

Fixes #456

docs: update README with new environment setup

- Add detailed API key setup instructions
- Include troubleshooting section
- Update project structure documentation

chore: upgrade Flutter to 3.9.0

- Update pubspec.yaml dependencies
- Fix deprecation warnings
- Update CI/CD configuration
```

### 커밋 메시지 규칙

1. **제목은 50자 이하**로 작성
2. **제목 첫 글자는 소문자**로 시작
3. **제목 끝에 마침표 없음**
4. **본문은 72자마다 줄바꿈**
5. **본문은 "무엇을", "왜"에 집중**
6. **푸터에는 이슈 번호 참조**

## 🔄 Pull Request 가이드

### PR 생성 전 체크리스트

- [ ] 최신 main 브랜치와 동기화
- [ ] 모든 테스트 통과
- [ ] 코드 포맷팅 적용
- [ ] 관련 문서 업데이트
- [ ] 의미 있는 커밋 메시지

### PR 템플릿

```markdown
## 📋 변경 사항

### 🎯 목적
- 이 PR의 목적을 설명해주세요

### 📝 주요 변경 사항
- [ ] 새로운 기능 추가
- [ ] 버그 수정
- [ ] 리팩토링
- [ ] 문서 업데이트
- [ ] 테스트 추가

### 🔧 기술적 세부사항
- 구현한 주요 기능들을 나열해주세요
- 중요한 기술적 결정사항이 있다면 설명해주세요

### 🧪 테스트
- [ ] 단위 테스트 작성/업데이트
- [ ] 위젯 테스트 작성/업데이트
- [ ] 수동 테스트 완료
- [ ] 기존 테스트 모두 통과

### 📱 스크린샷 (UI 변경사항이 있는 경우)
| Before | After |
|--------|--------|
| ![before](url) | ![after](url) |

### 🔗 관련 이슈
- Closes #이슈번호
- Related to #이슈번호

### ✅ 검토 요청 사항
- 특별히 검토받고 싶은 부분이 있다면 명시해주세요

### 📚 추가 정보
- 기타 참고사항이 있다면 작성해주세요
```

### PR 크기 가이드라인

- **Small PR (권장)**: 100-300줄, 1-3개 파일
- **Medium PR**: 300-500줄, 3-7개 파일
- **Large PR**: 500줄 이상 (가능한 피하고, 작은 PR로 분할)

## 🐛 이슈 리포팅

### 버그 리포트 템플릿

```markdown
## 🐛 버그 설명
버그에 대한 명확하고 간단한 설명

## 🔄 재현 단계
1. '...' 으로 이동
2. '....' 클릭
3. '....' 으로 스크롤
4. 오류 확인

## ✅ 예상 동작
예상했던 동작에 대한 명확하고 간단한 설명

## ❌ 실제 동작
실제로 일어난 일에 대한 명확하고 간단한 설명

## 📱 환경 정보
- 디바이스: [예: iPhone 12, Samsung Galaxy S21]
- OS: [예: Android 12, iOS 15.0]
- 앱 버전: [예: 1.0.0]
- Flutter 버전: [예: 3.9.0]

## 📸 스크린샷
가능하다면 스크린샷을 첨부해주세요

## 📝 추가 정보
버그에 대한 기타 정보나 맥락
```

### 기능 요청 템플릿

```markdown
## 🚀 기능 요청

### 📋 요약
새로운 기능에 대한 간단한 설명

### 🎯 문제 상황
어떤 문제를 해결하고자 하는지 설명
예: "사용자가 [...] 할 때 불편함을 겪고 있습니다"

### 💡 제안하는 해결책
원하는 기능이나 동작에 대한 명확한 설명

### 🔄 대안
고려해본 다른 대안들이 있다면 설명

### 📚 추가 정보
기능 요청에 대한 기타 정보나 맥락
```

## 👀 코드 리뷰 프로세스

### 리뷰어 가이드라인

#### 리뷰 시 확인사항

1. **기능성**: 코드가 의도한 대로 작동하는가?
2. **가독성**: 코드가 이해하기 쉬운가?
3. **성능**: 성능상 문제는 없는가?
4. **보안**: 보안 취약점은 없는가?
5. **테스트**: 적절한 테스트가 있는가?
6. **컨벤션**: 프로젝트 컨벤션을 따르는가?

#### 리뷰 톤

```markdown
# ✅ 좋은 예
"이 접근 방식도 좋지만, [대안]을 고려해보는 것은 어떨까요? 
[이유]때문에 더 적합할 수 있습니다."

"좋은 구현입니다! 다만 [작은 개선사항]을 추가하면 
더 좋을 것 같습니다."

# ❌ 피해야 할 예
"이건 잘못됐습니다."
"왜 이렇게 했나요?"
```

### 작성자 가이드라인

#### PR 작성 시

1. **자기 리뷰 먼저**: PR 생성 전 스스로 코드 검토
2. **명확한 설명**: PR 목적과 변경사항 명확히 기술
3. **테스트 결과**: 테스트 수행 결과 공유
4. **스크린샷**: UI 변경시 Before/After 스크린샷

#### 피드백 대응

1. **건설적 수용**: 피드백을 긍정적으로 받아들이기
2. **명확한 소통**: 이해되지 않는 부분은 질문하기
3. **적극적 개선**: 제안된 개선사항 적용
4. **감사 표현**: 리뷰어에게 감사 인사

## 🎯 베스트 프랙티스

### 코드 품질

1. **단순성 유지**: 복잡한 로직은 작은 함수로 분할
2. **의미 있는 이름**: 변수, 함수, 클래스명은 의도를 명확히
3. **주석 활용**: 복잡한 로직은 주석으로 설명
4. **에러 처리**: 예외 상황에 대한 적절한 처리
5. **테스트 작성**: 핵심 로직에 대한 테스트 코드

### 성능 고려사항

1. **불필요한 rebuild 방지**: const 생성자 활용
2. **메모리 누수 방지**: dispose 메서드 적절히 구현
3. **비동기 처리**: Future, Stream 적절히 활용
4. **이미지 최적화**: 캐싱 및 압축 적용

### 접근성 (Accessibility)

1. **Semantics 위젯**: 스크린 리더를 위한 의미 부여
2. **충분한 터치 영역**: 최소 48x48 크기 확보
3. **색상 대비**: WCAG 가이드라인 준수
4. **키보드 네비게이션**: 키보드만으로 조작 가능

## 📞 문의 및 도움

궁금한 사항이나 도움이 필요한 경우:

1. **GitHub Issues**: 버그 리포트나 기능 제안
2. **Discussions**: 일반적인 질문이나 아이디어 논의
3. **Discord/Slack**: 실시간 소통 (링크가 있는 경우)

## 📄 라이선스

이 프로젝트에 기여함으로써 귀하의 기여가 프로젝트와 동일한 라이선스 하에 배포됨에 동의합니다.

---

**함께 만들어가는 Ittem MVP! 여러분의 기여를 기다립니다! 🎉**