import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/image_cache_service.dart';

enum TealCardType { standard, elevated, accent }

class TealCard extends StatelessWidget {
  final Widget child;
  final TealCardType type;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;

  const TealCard({
    super.key,
    required this.child,
    this.type = TealCardType.standard,
    this.padding,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TealCardType.standard:
        return _buildStandardCard(context);
      case TealCardType.elevated:
        return _buildElevatedCard(context);
      case TealCardType.accent:
        return _buildAccentCard(context);
    }
  }

  Widget _buildStandardCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        side: BorderSide(
          color: AppColors.tealPale,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildElevatedCard(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: AppColors.primary.withValues(alpha: 0.1),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildAccentCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.tealPale,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        side: BorderSide(
          color: AppColors.secondary,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
            gradient: LinearGradient(
              colors: [
                AppColors.tealPale,
                AppColors.tealPale.withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// 특화된 아이템 카드
class ItemTealCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String location;
  final double rating;
  final VoidCallback? onTap;
  final bool isAvailable;

  const ItemTealCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.location,
    required this.rating,
    this.onTap,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TealCard(
      type: TealCardType.elevated,
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지와 상태 표시
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: imageUrl.isNotEmpty
                      ? ImageCacheService.optimizedThumbnail(
                          imageUrl: imageUrl,
                          size: 200,
                          fit: BoxFit.cover,
                          errorWidget: _buildPlaceholderImage(),
                          placeholder: _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
              ),
              // 상태 표시 뱃지
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailable ? AppColors.available : AppColors.rented,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAvailable ? '대여가능' : '대여중',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 제목
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          
          // 가격
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          
          // 위치와 평점
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.star,
                size: 14,
                color: AppColors.warning,
              ),
              const SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tealPale,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}