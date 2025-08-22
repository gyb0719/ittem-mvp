# Teal UI 컴포넌트 가이드

Ittem MVP는 일관된 디자인을 위해 Teal 디자인 시스템을 사용합니다. 이 가이드는 모든 Teal 컴포넌트의 사용법을 설명합니다.

## 🎨 디자인 시스템 개요

Teal 디자인 시스템은 GPT 아이콘에서 영감을 받은 teal/turquoise 색상을 기반으로 하며, 현대적이고 깔끔한 UI를 제공합니다.

### 색상 팔레트

```dart
// Primary Colors (4-tier teal system)
AppColors.primary        // #5CBDBD - Main teal
AppColors.primaryVariant // #4A9E9E - Dark teal
AppColors.secondary      // #72D5D5 - Light teal
AppColors.accent         // #45A5A5 - Darker accent
AppColors.tealPale       // #E5F7F7 - Pale background

// System Colors
AppColors.success        // #10B981 - Green
AppColors.error          // #EF4444 - Red
AppColors.warning        // #F59E0B - Amber
AppColors.info           // #3B82F6 - Blue
```

## 📦 컴포넌트 Import

```dart
// 개별 컴포넌트 import
import 'package:ittem_app/shared/widgets/teal_button.dart';
import 'package:ittem_app/shared/widgets/teal_card.dart';

// 모든 컴포넌트 한번에 import (권장)
import 'package:ittem_app/shared/widgets/teal_components.dart';
```

## 🔘 TealButton

다양한 스타일과 크기를 제공하는 버튼 컴포넌트입니다.

### 기본 사용법

```dart
// Primary 버튼 (기본)
TealButton(
  text: '로그인',
  onPressed: () => print('로그인'),
)

// Secondary 버튼
TealButton(
  text: '취소',
  type: TealButtonType.secondary,
  onPressed: () => print('취소'),
)

// Outline 버튼
TealButton(
  text: '더보기',
  type: TealButtonType.outline,
  onPressed: () => print('더보기'),
)
```

### 버튼 타입

```dart
enum TealButtonType {
  primary,    // 주요 액션 (teal 배경)
  secondary,  // 보조 액션 (회색 배경)
  outline,    // 테두리만 있는 버튼
  text,       // 텍스트만 있는 버튼
  danger,     // 위험한 액션 (빨간색)
  success,    // 성공 액션 (초록색)
}

// 사용 예시
TealButton(
  text: '계정 삭제',
  type: TealButtonType.danger,
  onPressed: () => _deleteAccount(),
)

TealButton(
  text: '저장 완료',
  type: TealButtonType.success,
  onPressed: () => _saveData(),
)
```

### 버튼 크기

```dart
enum TealButtonSize { small, medium, large }

// 작은 버튼
TealButton(
  text: '확인',
  size: TealButtonSize.small,
  onPressed: () {},
)

// 큰 버튼
TealButton(
  text: '시작하기',
  size: TealButtonSize.large,
  fullWidth: true, // 전체 너비
  onPressed: () {},
)
```

### 아이콘 버튼

```dart
// 아이콘과 텍스트
TealButton(
  text: '사진 업로드',
  iconData: Icons.upload,
  onPressed: () {},
)

// 아이콘만
TealButton.icon(
  icon: Icons.favorite,
  onPressed: () {},
  tooltip: '좋아요',
)

// 로딩 상태
TealButton(
  text: '처리 중...',
  isLoading: true,
  onPressed: null, // 비활성화
)
```

## 📄 TealCard

그림자와 둥근 모서리를 가진 카드 컴포넌트입니다.

### 기본 사용법

```dart
// 표준 카드
TealCard(
  child: Column(
    children: [
      Text('카드 제목'),
      Text('카드 내용...'),
    ],
  ),
)

// 클릭 가능한 카드
TealCard(
  onTap: () => print('카드 클릭됨'),
  child: ListTile(
    title: Text('클릭할 수 있는 카드'),
    trailing: Icon(Icons.arrow_forward),
  ),
)
```

### 카드 타입

```dart
enum TealCardType { standard, elevated, accent }

// 표준 카드 (테두리만)
TealCard(
  type: TealCardType.standard,
  child: Text('표준 카드'),
)

// 그림자가 있는 카드
TealCard(
  type: TealCardType.elevated,
  child: Text('그림자 카드'),
)

// 강조 카드 (teal 배경)
TealCard(
  type: TealCardType.accent,
  child: Text('강조 카드', style: TextStyle(color: Colors.white)),
)
```

### 커스터마이징

```dart
TealCard(
  padding: EdgeInsets.all(24),
  borderRadius: 12,
  child: Column(
    children: [
      Text('사용자 정의 카드'),
      SizedBox(height: 16),
      TealButton(text: '액션', onPressed: () {}),
    ],
  ),
)
```

## ✏️ TealTextField

일관된 디자인의 입력 필드입니다.

### 기본 사용법

```dart
TealTextField(
  labelText: '이메일',
  hintText: 'example@email.com',
  onChanged: (value) => print(value),
)

// 비밀번호 필드
TealTextField(
  labelText: '비밀번호',
  obscureText: true,
  suffixIcon: Icons.visibility,
  onChanged: (value) => _password = value,
)

// 여러 줄 텍스트
TealTextField(
  labelText: '설명',
  maxLines: 4,
  keyboardType: TextInputType.multiline,
)
```

### 유효성 검사

```dart
TealTextField(
  labelText: '이름',
  validator: (value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요';
    }
    return null;
  },
  errorText: _nameError, // 에러 메시지 표시
)
```

## 📱 TealAppBar

커스텀 앱 바 컴포넌트입니다.

### 기본 사용법

```dart
Scaffold(
  appBar: TealAppBar(
    title: '홈',
    showBackButton: true,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {},
      ),
    ],
  ),
  body: ...,
)

// 그라데이션 앱 바
TealAppBar(
  title: '지도',
  useGradient: true,
  centerTitle: true,
)
```

## 📄 TealBottomSheet

하단 시트 컴포넌트입니다.

### 기본 사용법

```dart
// 기본 하단 시트
void _showBottomSheet() {
  TealBottomSheet.show(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.share),
          title: Text('공유하기'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('링크 복사'),
          onTap: () {},
        ),
      ],
    ),
  );
}

// 드래그 가능한 하단 시트
TealBottomSheet.draggable(
  context: context,
  initialChildSize: 0.3,
  maxChildSize: 0.9,
  builder: (context, scrollController) => ListView(
    controller: scrollController,
    children: [
      Text('드래그해서 크기 조절'),
      // ... 더 많은 콘텐츠
    ],
  ),
)
```

## 🔔 TealDialog

모달 다이얼로그 컴포넌트입니다.

### 기본 사용법

```dart
// 알림 다이얼로그
TealDialog.alert(
  context: context,
  title: '알림',
  content: '작업이 완료되었습니다.',
  onConfirm: () => Navigator.pop(context),
)

// 확인 다이얼로그
TealDialog.confirm(
  context: context,
  title: '삭제 확인',
  content: '정말로 삭제하시겠습니까?',
  onConfirm: () => _deleteItem(),
  onCancel: () => Navigator.pop(context),
)

// 커스텀 다이얼로그
TealDialog.custom(
  context: context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('커스텀 다이얼로그'),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TealButton(text: '취소', onPressed: () {}),
          TealButton(text: '확인', onPressed: () {}),
        ],
      ),
    ],
  ),
)
```

## 🏷️ TealChip

선택 가능한 칩 컴포넌트입니다.

### 기본 사용법

```dart
// 기본 칩
TealChip(
  label: '카테고리',
  isSelected: true,
  onSelected: (selected) => print('선택됨: $selected'),
)

// 삭제 가능한 칩
TealChip(
  label: '태그',
  showDeleteIcon: true,
  onDeleted: () => print('삭제됨'),
)

// 칩 그룹
Wrap(
  spacing: 8,
  children: categories.map((category) => TealChip(
    label: category.name,
    isSelected: category.isSelected,
    onSelected: (selected) => _toggleCategory(category),
  )).toList(),
)
```

## 🔍 TealSearch

검색 입력 필드입니다.

### 기본 사용법

```dart
TealSearch(
  hintText: '아이템 검색...',
  onChanged: (query) => _searchItems(query),
  onSubmitted: (query) => _performSearch(query),
)

// 필터 버튼이 있는 검색
TealSearch(
  hintText: '검색어 입력',
  showFilterButton: true,
  onFilterPressed: () => _showFilterDialog(),
  onChanged: (query) => _updateSearchQuery(query),
)
```

## ⏳ TealLoading

로딩 인디케이터입니다.

### 기본 사용법

```dart
// 기본 로딩
TealLoading()

// 메시지가 있는 로딩
TealLoading(message: '데이터를 불러오는 중...')

// 페이지 전체 로딩 오버레이
TealLoading.overlay(
  context: context,
  message: '처리 중...',
)

// 버튼 내 로딩
TealButton(
  text: '저장',
  isLoading: _isLoading,
  onPressed: _isLoading ? null : _saveData,
)
```

## 🔔 TealNotification

알림/토스트 메시지입니다.

### 기본 사용법

```dart
// 성공 알림
TealNotification.success(
  context: context,
  message: '저장되었습니다.',
)

// 에러 알림
TealNotification.error(
  context: context,
  message: '오류가 발생했습니다.',
)

// 경고 알림
TealNotification.warning(
  context: context,
  message: '주의가 필요합니다.',
)

// 정보 알림
TealNotification.info(
  context: context,
  message: '새로운 메시지가 있습니다.',
  action: TealNotificationAction(
    text: '보기',
    onPressed: () => _viewMessage(),
  ),
)
```

## 👤 TealAvatar

사용자 아바타 컴포넌트입니다.

### 기본 사용법

```dart
// 이미지 아바타
TealAvatar(
  imageUrl: user.avatarUrl,
  size: AvatarSize.medium,
)

// 이니셜 아바타
TealAvatar.initials(
  name: user.name,
  size: AvatarSize.large,
)

// 아이콘 아바타
TealAvatar.icon(
  icon: Icons.person,
  backgroundColor: AppColors.tealPale,
)
```

## 📊 TealStatus

상태 표시 컴포넌트입니다.

### 기본 사용법

```dart
// 아이템 상태
TealStatus(
  status: 'available',
  text: '대여 가능',
  color: AppColors.success,
)

// 사용자 온라인 상태
TealStatus.online(isOnline: user.isOnline)

// 배지 형태
TealBadge(
  count: unreadCount,
  child: Icon(Icons.notifications),
)
```

## 🎯 실제 사용 예시

### 아이템 카드

```dart
class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TealCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12),
          
          // 제목과 상태
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TealStatus(
                status: item.status,
                text: item.statusText,
              ),
            ],
          ),
          
          SizedBox(height: 4),
          Text(
            '₩${item.price.toStringAsFixed(0)}/일',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          
          SizedBox(height: 8),
          Row(
            children: [
              TealAvatar(
                imageUrl: item.owner.avatarUrl,
                size: AvatarSize.small,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.owner.name,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TealChip(
                label: item.category,
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 검색 화면

```dart
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TealAppBar(title: '검색'),
      body: Column(
        children: [
          // 검색 입력
          Padding(
            padding: EdgeInsets.all(16),
            child: TealSearch(
              hintText: '무엇을 찾고 계신가요?',
              showFilterButton: true,
              onChanged: (query) => setState(() => _searchQuery = query),
              onFilterPressed: _showFilterDialog,
            ),
          ),
          
          // 카테고리 필터
          if (_selectedCategories.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _selectedCategories.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: TealChip(
                    label: _selectedCategories[index],
                    isSelected: true,
                    showDeleteIcon: true,
                    onDeleted: () => _removeCategory(index),
                  ),
                ),
              ),
            ),
          
          // 검색 결과
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}
```

이 가이드를 통해 Teal 디자인 시스템의 모든 컴포넌트를 일관성 있게 사용할 수 있습니다. 각 컴포넌트는 접근성과 사용성을 고려하여 설계되었으며, 프로젝트 전반에 걸쳐 일관된 사용자 경험을 제공합니다.