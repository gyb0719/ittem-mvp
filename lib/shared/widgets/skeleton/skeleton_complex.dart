import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../teal_card.dart';
import 'skeleton_base.dart';
import 'skeleton_shimmer.dart';

/// ItemCard용 스켈레톤 (이미지 + 텍스트 조합)
/// 기존 ItemTealCard와 동일한 레이아웃을 가진 스켈레톤
class SkeletonItemCard extends StatelessWidget {
  final bool shimmer;
  final TealCardType cardType;

  const SkeletonItemCard({
    super.key,
    this.shimmer = true,
    this.cardType = TealCardType.elevated,
  });

  @override
  Widget build(BuildContext context) {
    return TealCard(
      type: cardType,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 스켈레톤 (정사각형 비율)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: SkeletonBox(
                    width: double.infinity,
                    borderRadius: 12,
                    shimmer: shimmer,
                  ),
                ),
              ),
              // 상태 뱃지 스켈레톤
              Positioned(
                top: 8,
                right: 8,
                child: SkeletonBox(
                  width: 60,
                  height: 20,
                  borderRadius: 12,
                  shimmer: shimmer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 제목 스켈레톤 (2줄)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText.title(
                width: double.infinity,
                shimmer: shimmer,
              ),
              const SizedBox(height: 4),
              SkeletonText.title(
                width: 150,
                shimmer: shimmer,
              ),
            ],
          ),
          const SizedBox(height: 6),
          
          // 가격 스켈레톤
          SkeletonText(
            width: 100,
            height: 20,
            shimmer: shimmer,
          ),
          const SizedBox(height: 8),
          
          // 위치와 평점 스켈레톤
          Row(
            children: [
              SkeletonCircle.icon(
                size: 14,
                shimmer: shimmer,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SkeletonText.caption(
                  height: 12,
                  shimmer: shimmer,
                ),
              ),
              const SizedBox(width: 8),
              SkeletonCircle.icon(
                size: 14,
                shimmer: shimmer,
              ),
              const SizedBox(width: 2),
              SkeletonText.caption(
                width: 20,
                height: 12,
                shimmer: shimmer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 리스트뷰용 스켈레톤
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final bool shimmer;
  final Widget Function(BuildContext context, int index)? itemBuilder;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.padding,
    this.shimmer = true,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: itemBuilder ?? _defaultItemBuilder,
    );
  }

  Widget _defaultItemBuilder(BuildContext context, int index) {
    return Container(
      height: itemHeight,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.surfaceDark 
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.tealPale,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 왼쪽 이미지 스켈레톤
          SkeletonBox(
            width: itemHeight - 24,
            height: itemHeight - 24,
            borderRadius: 8,
            shimmer: shimmer,
          ),
          const SizedBox(width: 12),
          
          // 오른쪽 텍스트 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonText.title(
                  width: double.infinity,
                  shimmer: shimmer,
                ),
                const SizedBox(height: 6),
                SkeletonText.body(
                  width: 120,
                  shimmer: shimmer,
                ),
                const SizedBox(height: 6),
                SkeletonText.caption(
                  width: 80,
                  shimmer: shimmer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 그리드뷰용 스켈레톤
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final bool shimmer;
  final Widget Function(BuildContext context, int index)? itemBuilder;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.padding,
    this.mainAxisSpacing = 12.0,
    this.crossAxisSpacing = 12.0,
    this.shimmer = true,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder ?? _defaultItemBuilder,
    );
  }

  Widget _defaultItemBuilder(BuildContext context, int index) {
    return SkeletonItemCard(shimmer: shimmer);
  }
}

/// 프로필 헤더용 스켈레톤
class SkeletonProfileHeader extends StatelessWidget {
  final bool shimmer;

  const SkeletonProfileHeader({
    super.key,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // 프로필 이미지 스켈레톤
          SkeletonCircle(
            size: 80,
            shimmer: shimmer,
          ),
          const SizedBox(width: 16),
          
          // 프로필 정보 스켈레톤
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText.title(
                  width: 120,
                  height: 20,
                  shimmer: shimmer,
                ),
                const SizedBox(height: 8),
                SkeletonText.body(
                  width: 200,
                  shimmer: shimmer,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SkeletonText.caption(
                      width: 60,
                      shimmer: shimmer,
                    ),
                    const SizedBox(width: 16),
                    SkeletonText.caption(
                      width: 60,
                      shimmer: shimmer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 채팅 메시지용 스켈레톤
class SkeletonChatMessage extends StatelessWidget {
  final bool isMe;
  final bool shimmer;

  const SkeletonChatMessage({
    super.key,
    this.isMe = false,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            SkeletonCircle.avatar(
              size: 32,
              shimmer: shimmer,
            ),
            const SizedBox(width: 8),
          ],
          
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.tealPale,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText.body(
                  width: 150,
                  shimmer: shimmer,
                ),
                const SizedBox(height: 4),
                SkeletonText.body(
                  width: 100,
                  shimmer: shimmer,
                ),
              ],
            ),
          ),
          
          if (isMe) ...[
            const SizedBox(width: 8),
            SkeletonCircle.avatar(
              size: 32,
              shimmer: shimmer,
            ),
          ],
        ],
      ),
    );
  }
}

/// 뉴스/피드 아이템용 스켈레톤
class SkeletonFeedItem extends StatelessWidget {
  final bool shimmer;

  const SkeletonFeedItem({
    super.key,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.surfaceDark 
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.tealPale,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (프로필 + 이름)
          Row(
            children: [
              SkeletonCircle.avatar(
                size: 40,
                shimmer: shimmer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText.subtitle(
                      width: 120,
                      shimmer: shimmer,
                    ),
                    const SizedBox(height: 4),
                    SkeletonText.caption(
                      width: 80,
                      shimmer: shimmer,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 본문 텍스트
          SkeletonParagraph(
            lines: 3,
            lineHeight: 16,
            shimmer: shimmer,
          ),
          const SizedBox(height: 12),
          
          // 이미지 (옵션)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SkeletonBox(
              width: double.infinity,
              height: 200,
              shimmer: shimmer,
            ),
          ),
          const SizedBox(height: 12),
          
          // 액션 버튼들
          Row(
            children: [
              SkeletonText.caption(
                width: 50,
                shimmer: shimmer,
              ),
              const SizedBox(width: 16),
              SkeletonText.caption(
                width: 50,
                shimmer: shimmer,
              ),
              const SizedBox(width: 16),
              SkeletonText.caption(
                width: 50,
                shimmer: shimmer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}