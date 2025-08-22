import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/item_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../services/image_cache_service.dart';
import '../../../theme/colors.dart';

class ItemCardCompact extends StatefulWidget {
  final ItemModel item;
  final VoidCallback? onTap;
  final bool showFavorite;
  final ValueChanged<bool>? onFavoriteToggled;
  final EdgeInsetsGeometry? margin;

  const ItemCardCompact({
    super.key,
    required this.item,
    this.onTap,
    this.showFavorite = false,
    this.onFavoriteToggled,
    this.margin,
  });

  @override
  State<ItemCardCompact> createState() => _ItemCardCompactState();
}

class _ItemCardCompactState extends State<ItemCardCompact>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      context.go(AppRoutes.itemDetail(widget.item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // 높이 축소 (120 -> 100)
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // 마진 축소
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              elevation: 2.0,
              shadowColor: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              child: InkWell(
                onTap: _onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.separator.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildImageSection(),
                      _buildContentSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 100, // 너비 축소 (120 -> 100)
      height: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: widget.item.imageUrl.isNotEmpty
                  ? ImageCacheService.optimizedThumbnail(
                      imageUrl: widget.item.imageUrl,
                      size: 200,
                      fit: BoxFit.cover,
                      errorWidget: _buildPlaceholderImage(),
                      placeholder: _buildSkeletonImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          
          // 상태 배지
          Positioned(
            top: 8,
            left: 8,
            child: _buildStatusBadge(),
          ),

          // 신규 배지
          if (_isNewItem())
            Positioned(
              top: 8,
              right: 8,
              child: _buildNewBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10), // 패딩 축소 (12 -> 10)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목과 즐겨찾기 버튼
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 14, // 큰기 축소 (15 -> 14)
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.5, // 150% 라인 높이
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.showFavorite) ...[
                  const SizedBox(width: 8),
                  _buildFavoriteButton(),
                ],
              ],
            ),
            const SizedBox(height: 4), // 간격 축소

            // 가격
            Text(
              '${_formatPrice(widget.item.price)}원/일',
              style: const TextStyle(
                fontSize: 15, // 크기 축소 (16 -> 15)
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.5, // 150% 라인 높이
              ),
            ),
            const Spacer(),

            // 하단 정보
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.item.location,
                    style: TextStyle(
                      fontSize: 11, // 크기 축소 (12 -> 11)
                      color: AppColors.textSecondary.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      height: 1.5, // 150% 라인 높이
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 2),
                Text(
                  widget.item.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 11, // 크기 축소 (12 -> 11)
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    height: 1.5, // 150% 라인 높이
                  ),
                ),
                if (_isPopularItem()) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '인기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    String text;

    if (widget.item.isAvailable) {
      backgroundColor = AppColors.success;
      text = '가능';
    } else {
      backgroundColor = AppColors.warning;
      text = '대여중';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        setState(() => _isFavorite = !_isFavorite);
        widget.onFavoriteToggled?.call(_isFavorite);
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: _isFavorite ? AppColors.error : AppColors.textSecondary,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.info,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.3),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tealPale,
            AppColors.tealPale.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 32,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildSkeletonImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.separator.withValues(alpha: 0.3),
            AppColors.separator.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  bool _isNewItem() {
    final now = DateTime.now();
    final createdAt = widget.item.createdAt;
    final difference = now.difference(createdAt).inDays;
    return difference <= 7;
  }

  bool _isPopularItem() {
    return widget.item.rating >= 4.5 && widget.item.reviewCount >= 10;
  }

  String _formatPrice(int price) {
    if (price >= 10000) {
      final man = price ~/ 10000;
      final remainder = price % 10000;
      if (remainder == 0) {
        return '$man만';
      } else {
        return '$man만 ${_formatThousands(remainder)}';
      }
    }
    return _formatThousands(price);
  }

  String _formatThousands(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}