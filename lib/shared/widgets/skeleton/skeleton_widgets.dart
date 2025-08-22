/// Skeleton UI System for Ittem MVP
/// 
/// 현대적인 로딩 상태를 표현하는 Skeleton UI 컴포넌트들을 제공합니다.
/// Expedia 수준의 세련된 스켈레톤 로딩 시스템을 구현하였습니다.
/// 
/// ## 주요 컴포넌트
/// 
/// ### 기본 컴포넌트
/// - [SkeletonBox]: 사각형 스켈레톤 (카드, 이미지용)
/// - [SkeletonText]: 텍스트 스켈레톤 (제목, 본문용)
/// - [SkeletonCircle]: 원형 스켈레톤 (아바타, 아이콘용)
/// - [SkeletonLine]: 라인 스켈레톤 (구분선용)
/// - [SkeletonParagraph]: 다중 라인 텍스트 스켈레톤
/// 
/// ### 복합 컴포넌트
/// - [SkeletonItemCard]: ItemCard용 스켈레톤
/// - [SkeletonList]: 리스트뷰용 스켈레톤
/// - [SkeletonGrid]: 그리드뷰용 스켈레톤
/// - [SkeletonProfileHeader]: 프로필 헤더용 스켈레톤
/// - [SkeletonChatMessage]: 채팅 메시지용 스켈레톤
/// - [SkeletonFeedItem]: 뉴스/피드 아이템용 스켈레톤
/// 
/// ### 애니메이션 시스템
/// - [SkeletonShimmer]: Shimmer 효과 제공
/// - [SkeletonColors]: 테마별 색상 관리
/// 
/// ## 사용 예시
/// 
/// ```dart
/// // 기본 사용
/// SkeletonBox(width: 100, height: 100)
/// 
/// // ItemCard 스켈레톤
/// SkeletonItemCard()
/// 
/// // 리스트 스켈레톤
/// SkeletonList(itemCount: 5)
/// 
/// // 그리드 스켈레톤
/// SkeletonGrid(itemCount: 6, crossAxisCount: 2)
/// ```
/// 
/// ## 특징
/// 
/// - **테마 지원**: 라이트/다크 모드 자동 적용
/// - **접근성**: Screen reader 친화적
/// - **성능 최적화**: 메모리 누수 방지 및 효율적 애니메이션
/// - **커스터마이징**: 색상, 크기, 애니메이션 속도 조절 가능
/// - **일관성**: 기존 Teal 디자인 시스템과 완벽 통합

library skeleton_widgets;

// 기본 컴포넌트들
export 'skeleton_base.dart';

// Shimmer 효과
export 'skeleton_shimmer.dart';

// 복합 컴포넌트들
export 'skeleton_complex.dart';