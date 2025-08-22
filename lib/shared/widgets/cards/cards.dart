// 🎴 Item Card Components
// 다양한 레이아웃과 스타일의 아이템 카드 컴포넌트들

export 'item_card.dart';
export 'item_card_compact.dart';
export 'item_card_featured.dart';
export 'item_card_grid.dart';

/// ## ItemCard 사용 가이드
/// 
/// ### 기본 카드 (ItemCard)
/// - **용도**: 일반적인 아이템 표시 (홈 화면, 카테고리 페이지)
/// - **크기**: 세로형, 적당한 높이
/// - **특징**: 애니메이션 효과, 상태 배지, 즐겨찾기 기능
/// 
/// ```dart
/// ItemCard(
///   item: item,
///   showFavorite: true,
///   onFavoriteToggled: (isFavorite) => handleFavorite(isFavorite),
/// )
/// ```
/// 
/// ### 컴팩트 카드 (ItemCardCompact)
/// - **용도**: 리스트 뷰, 검색 결과 목록
/// - **크기**: 가로형, 고정 높이 120px
/// - **특징**: 작은 이미지 + 핵심 정보만 표시
/// 
/// ```dart
/// ItemCardCompact(
///   item: item,
///   showFavorite: true,
///   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
/// )
/// ```
/// 
/// ### 피처드 카드 (ItemCardFeatured)
/// - **용도**: 홈 화면 추천 아이템, 인기 아이템
/// - **크기**: 큰 세로형, 고정 높이 380px
/// - **특징**: 큰 이미지, 강화된 배지 시스템, 카테고리 표시
/// 
/// ```dart
/// ItemCardFeatured(
///   item: item,
///   showFavorite: true,
///   showOwnerInfo: true,
///   margin: EdgeInsets.all(16),
/// )
/// ```
/// 
/// ### 그리드 카드 (ItemCardGrid)
/// - **용도**: 검색 결과 그리드, 카테고리 페이지 그리드
/// - **크기**: 그리드에 최적화된 비율 (기본 0.75)
/// - **특징**: 작은 크기에 최적화된 레이아웃
/// 
/// ```dart
/// GridView.builder(
///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2,
///     childAspectRatio: 0.75,
///   ),
///   itemBuilder: (context, index) => ItemCardGrid(
///     item: items[index],
///     showFavorite: true,
///   ),
/// )
/// ```
/// 
/// ## 공통 기능
/// 
/// ### 상태 배지
/// - 🟢 대여가능: 초록색
/// - 🟡 대여중: 노란색
/// 
/// ### 스마트 배지
/// - 🆕 NEW: 7일 이내 등록된 아이템
/// - 🔥 인기: 평점 4.5+ & 리뷰 10+ 아이템
/// - ⭐ FEATURED: 피처드 카드에서만 표시
/// 
/// ### 인터랙션
/// - 터치 애니메이션: scale down + elevation up
/// - 즐겨찾기: 하트 아이콘 토글
/// - 자동 네비게이션: ItemDetail 화면으로 이동
/// 
/// ### 가격 포맷팅
/// - 1,000 이하: "1,000"
/// - 10,000 이상: "1만", "1만 2,000"
/// 
/// ### 접근성
/// - 적절한 터치 영역 (최소 44x44)
/// - 의미있는 라벨
/// - 색상 대비 WCAG 준수
/// 
/// ### 성능 최적화
/// - 이미지 캐싱: ImageCacheService 사용
/// - 불필요한 rebuild 방지
/// - const 생성자 활용
/// - 메모리 효율적인 이미지 로딩