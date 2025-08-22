# 시스템 아키텍처

Ittem MVP는 모던 Flutter 아키텍처 패턴을 따르며, 확장 가능하고 유지보수가 용이한 구조로 설계되었습니다.

## 🏛️ 전체 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                     Client (Flutter App)                    │
├─────────────────────────────────────────────────────────────┤
│  Presentation Layer  │  Domain Layer   │  Data Layer        │
│ ┌─────────────────── │ ─────────────── │ ─────────────────┐ │
│ │ • Screens          │ • Models        │ • Repositories   │ │
│ │ • Widgets          │ • Providers     │ • Services       │ │
│ │ │ • UI Components  │ • Use Cases     │ • Data Sources   │ │
│ └─────────────────── │ ─────────────── │ ─────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                               │
                               │ API Calls / Real-time
                               │
┌─────────────────────────────────────────────────────────────┐
│                    Backend Services                         │
├─────────────────────────────────────────────────────────────┤
│                      Supabase                              │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ PostgreSQL + PostGIS │ Auth │ Storage │ Real-time      │ │
│ │ • Users              │ • JWT│ • Images│ • WebSocket    │ │
│ │ • Items              │ • RLS│ • Files │ • Subscriptions│ │
│ │ • Messages           │      │         │                │ │
│ │ • Transactions       │      │         │                │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                               │
                               │ External APIs
                               │
┌─────────────────────────────────────────────────────────────┐
│                   External Services                         │
├─────────────────────────────────────────────────────────────┤
│  Google Maps API  │  PortOne Payment  │  Push Notification │
│  • Geocoding      │  • Payment        │  • FCM (Future)    │
│  • Places         │  • Webhooks       │  • Real-time       │
│  • Directions     │  • Verification   │    Alerts          │
└─────────────────────────────────────────────────────────────┘
```

## 📱 Flutter 앱 아키텍처

### 계층별 구조 (Layer Architecture)

#### 1. Presentation Layer (UI)
```
lib/
├── features/                 # 기능별 UI 모듈
│   ├── auth/                # 인증 관련 화면
│   ├── home/                # 홈 화면
│   ├── items/               # 아이템 관리 화면
│   ├── map/                 # 지도 화면
│   ├── chat/                # 채팅 화면
│   ├── profile/             # 프로필 화면
│   └── ...
├── shared/
│   └── widgets/             # 재사용 가능한 UI 컴포넌트
│       ├── teal_button.dart
│       ├── teal_card.dart
│       └── teal_*.dart      # Teal 디자인 시스템
└── theme/                   # 테마 및 스타일 정의
```

#### 2. Domain Layer (비즈니스 로직)
```
lib/
├── core/
│   ├── models/              # 도메인 모델 (Freezed)
│   │   ├── item.dart
│   │   ├── location.dart
│   │   └── user.dart
│   ├── providers/           # Riverpod 상태 관리
│   │   ├── items_provider.dart
│   │   ├── location_provider.dart
│   │   └── auth_provider.dart
│   └── repositories/        # 추상 레포지토리 인터페이스
└── shared/
    └── models/              # 공통 모델
```

#### 3. Data Layer (데이터)
```
lib/
├── services/                # 외부 서비스 연동
│   ├── supabase_service.dart
│   ├── google_maps_service.dart
│   ├── image_upload_service.dart
│   └── payment_service.dart
└── shared/
    └── services/            # 공통 서비스
        └── auth_service.dart
```

## 🔄 상태 관리 (Riverpod)

### Provider 구조

```dart
// 1. StateProvider - 단순 상태
final counterProvider = StateProvider<int>((ref) => 0);

// 2. FutureProvider - 비동기 데이터
final itemsProvider = FutureProvider<List<Item>>((ref) async {
  final repository = ref.watch(itemsRepositoryProvider);
  return repository.getAllItems();
});

// 3. StateNotifierProvider - 복잡한 상태 관리
final itemsNotifierProvider = StateNotifierProvider<ItemsNotifier, AsyncValue<List<Item>>>(
  (ref) => ItemsNotifier(ref.watch(itemsRepositoryProvider)),
);

// 4. Provider - 의존성 주입
final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository(ref.watch(supabaseServiceProvider));
});
```

### 상태 흐름

```
UI Widget → Provider → Repository → Service → Supabase
    ↓         ↑          ↑           ↑          ↑
  Consumer   Watch    Inject     Inject    API Call
```

## 🗄️ 데이터베이스 설계 (Supabase)

### ERD (Entity Relationship Diagram)

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│    users    │       │    items    │       │  messages   │
├─────────────┤       ├─────────────┤       ├─────────────┤
│ id (UUID)   │◄─────►│ id (UUID)   │       │ id (UUID)   │
│ email       │       │ owner_id    │       │ sender_id   │
│ phone       │       │ title       │       │ receiver_id │
│ name        │       │ description │       │ item_id     │
│ avatar_url  │       │ price       │       │ content     │
│ rating      │       │ category    │       │ created_at  │
│ location    │       │ location    │       │ read_at     │
│ created_at  │       │ images      │       └─────────────┘
│ updated_at  │       │ status      │              │
└─────────────┘       │ created_at  │              │
                      │ updated_at  │              │
                      └─────────────┘              │
                             │                     │
                             ▼                     ▼
                      ┌─────────────┐       ┌─────────────┐
                      │transactions │       │   reviews   │
                      ├─────────────┤       ├─────────────┤
                      │ id (UUID)   │       │ id (UUID)   │
                      │ item_id     │       │ transaction_id│
                      │ renter_id   │       │ reviewer_id │
                      │ owner_id    │       │ reviewee_id │
                      │ start_date  │       │ rating      │
                      │ end_date    │       │ comment     │
                      │ total_price │       │ created_at  │
                      │ status      │       └─────────────┘
                      │ created_at  │
                      └─────────────┘
```

### 테이블 구조

#### users 테이블
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR UNIQUE NOT NULL,
  phone VARCHAR,
  name VARCHAR NOT NULL,
  avatar_url TEXT,
  rating DECIMAL(3,2) DEFAULT 0,
  location GEOGRAPHY(POINT),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (Row Level Security) 정책
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);
```

#### items 테이블
```sql
CREATE TABLE items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR NOT NULL,
  description TEXT,
  price INTEGER NOT NULL,
  category VARCHAR NOT NULL,
  location GEOGRAPHY(POINT),
  images TEXT[],
  status VARCHAR DEFAULT 'available' CHECK (status IN ('available', 'rented', 'maintenance')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 지리적 검색을 위한 인덱스
CREATE INDEX items_location_idx ON items USING GIST (location);

-- RLS 정책
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view available items" ON items FOR SELECT USING (status = 'available');
CREATE POLICY "Owner can manage own items" ON items FOR ALL USING (auth.uid() = owner_id);
```

### 지리적 검색 함수

```sql
-- 주변 아이템 검색 함수
CREATE OR REPLACE FUNCTION items_nearby(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  distance_meters INTEGER DEFAULT 1000
)
RETURNS TABLE(
  id UUID,
  title VARCHAR,
  price INTEGER,
  distance_meters DOUBLE PRECISION
)
LANGUAGE SQL
AS $$
  SELECT 
    i.id,
    i.title,
    i.price,
    ST_Distance(
      i.location::geometry,
      ST_MakePoint(user_lng, user_lat)::geometry
    ) as distance_meters
  FROM items i
  WHERE 
    i.status = 'available'
    AND ST_DWithin(
      i.location::geometry,
      ST_MakePoint(user_lng, user_lat)::geometry,
      distance_meters
    )
  ORDER BY distance_meters;
$$;
```

## 🎨 UI/UX 아키텍처

### Teal 디자인 시스템

#### 컴포넌트 계층 구조

```
TealComponents (배럴 파일)
├── Core Components
│   ├── TealButton        # 기본 버튼
│   ├── TealCard          # 카드 컨테이너
│   └── TealTextField     # 입력 필드
├── Layout Components
│   ├── TealAppBar        # 상단 바
│   ├── TealBottomSheet   # 하단 시트
│   └── TealDialog        # 모달
├── Data Display
│   ├── TealBadge         # 배지
│   ├── TealChip          # 칩
│   └── TealAvatar        # 아바타
├── Feedback
│   ├── TealLoading       # 로딩
│   ├── TealNotification  # 알림
│   └── TealStatus        # 상태 표시
└── Utility
    ├── TealSearch        # 검색
    └── TealDivider       # 구분선
```

#### 테마 시스템

```dart
// theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: TealColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.pretendardTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TealButton.defaultStyle,
    ),
  );
}
```

### 반응형 디자인

```dart
// shared/utils/responsive.dart
class Responsive {
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 768;
  
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 768 && 
      MediaQuery.of(context).size.width < 1200;
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1200;
}
```

## 🌐 네트워킹 아키텍처

### API 통신 구조

```dart
// services/api_service.dart
class ApiService {
  final SupabaseClient _client;
  
  ApiService(this._client);
  
  // Generic API 호출
  Future<T> request<T>({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.from(endpoint).select();
      return _handleResponse<T>(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
```

### 에러 처리

```dart
// core/exceptions/app_exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  AppException(this.message, [this.statusCode]);
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, 0);
}

class AuthException extends AppException {
  AuthException(String message) : super(message, 401);
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, 400);
}
```

## 🔐 보안 아키텍처

### 인증 흐름

```
1. User Login Request
   ↓
2. Supabase Auth
   ↓
3. JWT Token Generation
   ↓
4. Token Storage (Secure)
   ↓
5. API Requests with Token
   ↓
6. Row Level Security Check
   ↓
7. Data Access Granted/Denied
```

### RLS (Row Level Security) 정책

```sql
-- 사용자는 자신의 데이터만 접근
CREATE POLICY "Users access own data" ON users
  FOR ALL USING (auth.uid() = id);

-- 아이템은 공개적으로 조회 가능, 소유자만 수정
CREATE POLICY "Public read items" ON items
  FOR SELECT USING (true);

CREATE POLICY "Owner modify items" ON items
  FOR INSERT, UPDATE, DELETE USING (auth.uid() = owner_id);
```

## 📊 성능 최적화

### 1. 이미지 최적화
```dart
// services/image_optimization_service.dart
class ImageOptimizationService {
  Future<File> compressImage(File image) async {
    return await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '${image.path}_compressed.jpg',
      quality: 70,
      minWidth: 800,
      minHeight: 600,
    );
  }
}
```

### 2. 지도 성능 최적화
```dart
// features/map/widgets/optimized_map.dart
class OptimizedGoogleMap extends StatefulWidget {
  @override
  _OptimizedGoogleMapState createState() => _OptimizedGoogleMapState();
}

class _OptimizedGoogleMapState extends State<OptimizedGoogleMap> {
  Set<Marker> _markers = {};
  Timer? _debounceTimer;
  
  void _onCameraMove(CameraPosition position) {
    // 디바운싱으로 API 호출 최적화
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _loadNearbyItems(position.target);
    });
  }
}
```

### 3. 상태 관리 최적화
```dart
// core/providers/optimized_provider.dart
final itemsProvider = StreamProvider.autoDispose.family<List<Item>, String>(
  (ref, category) {
    // 자동 dispose로 메모리 최적화
    final repository = ref.watch(itemsRepositoryProvider);
    return repository.getItemsByCategory(category);
  },
);
```

## 🧪 테스트 아키텍처

### 테스트 피라미드

```
    /\
   /  \      E2E Tests
  /____\     (소수의 핵심 플로우)
 /      \    
/        \   Integration Tests
\________/    (기능별 통합)
           
Unit Tests
(많은 수의 단위 테스트)
```

### 테스트 구조
```
test/
├── unit/                    # 단위 테스트
│   ├── models/
│   ├── services/
│   └── providers/
├── widget/                  # 위젯 테스트
│   ├── components/
│   └── screens/
└── integration/             # 통합 테스트
    ├── auth_flow_test.dart
    └── item_rental_flow_test.dart
```

이 아키텍처는 확장성, 유지보수성, 테스트 가능성을 고려하여 설계되었으며, 현대적인 Flutter 개발 모범 사례를 따릅니다.