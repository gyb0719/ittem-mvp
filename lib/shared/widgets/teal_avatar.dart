import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'teal_badge.dart';

enum TealAvatarSize { small, medium, large, extraLarge }
enum TealAvatarType { circle, rounded, square }

class TealAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final Widget? child;
  final TealAvatarSize size;
  final TealAvatarType type;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final String? heroTag;
  final bool showBadge;
  final Widget? badge;
  final bool isOnline;
  final String? placeholderAsset;

  const TealAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.child,
    this.size = TealAvatarSize.medium,
    this.type = TealAvatarType.circle,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.heroTag,
    this.showBadge = false,
    this.badge,
    this.isOnline = false,
    this.placeholderAsset,
  });

  // 팩토리 생성자들
  factory TealAvatar.user({
    Key? key,
    String? imageUrl,
    required String name,
    TealAvatarSize size = TealAvatarSize.medium,
    VoidCallback? onTap,
    bool isOnline = false,
    String? heroTag,
  }) {
    return TealAvatar(
      key: key,
      imageUrl: imageUrl,
      name: name,
      size: size,
      onTap: onTap,
      isOnline: isOnline,
      heroTag: heroTag,
      showBadge: isOnline,
    );
  }

  factory TealAvatar.initials({
    Key? key,
    required String name,
    TealAvatarSize size = TealAvatarSize.medium,
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return TealAvatar(
      key: key,
      name: name,
      size: size,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onTap: onTap,
    );
  }

  factory TealAvatar.icon({
    Key? key,
    required IconData icon,
    TealAvatarSize size = TealAvatarSize.medium,
    Color? backgroundColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return TealAvatar(
      key: key,
      child: Icon(
        icon,
        color: iconColor ?? Colors.white,
        size: _getIconSize(size),
      ),
      size: size,
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getAvatarSize();
    final borderRadius = _getBorderRadius();
    
    Widget avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? _generateBackgroundColor(),
        borderRadius: type == TealAvatarType.circle 
          ? BorderRadius.circular(avatarSize / 2)
          : BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.separator.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: type == TealAvatarType.circle 
          ? BorderRadius.circular(avatarSize / 2)
          : BorderRadius.circular(borderRadius),
        child: _buildAvatarContent(),
      ),
    );

    // Hero 애니메이션 적용
    if (heroTag != null) {
      avatar = Hero(
        tag: heroTag!,
        child: avatar,
      );
    }

    // 온라인 상태 배지 적용
    if (showBadge || isOnline) {
      avatar = TealStatusBadge(
        isOnline: isOnline,
        size: _getBadgeSize(),
        child: avatar,
      );
    }

    // 커스텀 배지 적용
    if (badge != null) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -4,
            top: -4,
            child: badge!,
          ),
        ],
      );
    }

    // 탭 기능 적용
    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildAvatarContent() {
    // 커스텀 자식 위젯이 있는 경우
    if (child != null) {
      return Center(child: child);
    }

    // 이미지 URL이 있는 경우
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContent();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingContent();
        },
      );
    }

    // 플레이스홀더 에셋이 있는 경우
    if (placeholderAsset != null) {
      return Image.asset(
        placeholderAsset!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContent();
        },
      );
    }

    // 기본 컨텐츠 (이니셜 또는 아이콘)
    return _buildFallbackContent();
  }

  Widget _buildFallbackContent() {
    if (name != null && name!.isNotEmpty) {
      return Center(
        child: Text(
          _getInitials(name!),
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: _getTextSize(),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        Icons.person,
        color: textColor ?? Colors.white,
        size: _getIconSize(size),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: SizedBox(
        width: _getAvatarSize() * 0.4,
        height: _getAvatarSize() * 0.4,
        child: const CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words.first[0]}${words.last[0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words.first.substring(0, words.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '?';
  }

  Color _generateBackgroundColor() {
    if (name == null || name!.isEmpty) return AppColors.primary;
    
    // 이름을 기반으로 일관된 색상 생성
    final hash = name!.hashCode;
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.success,
      AppColors.info,
    ];
    return colors[hash.abs() % colors.length];
  }

  double _getAvatarSize() {
    switch (size) {
      case TealAvatarSize.small:
        return 32;
      case TealAvatarSize.medium:
        return 48;
      case TealAvatarSize.large:
        return 64;
      case TealAvatarSize.extraLarge:
        return 96;
    }
  }

  double _getBorderRadius() {
    switch (type) {
      case TealAvatarType.circle:
        return _getAvatarSize() / 2;
      case TealAvatarType.rounded:
        return 12;
      case TealAvatarType.square:
        return 4;
    }
  }

  double _getTextSize() {
    switch (size) {
      case TealAvatarSize.small:
        return 12;
      case TealAvatarSize.medium:
        return 16;
      case TealAvatarSize.large:
        return 20;
      case TealAvatarSize.extraLarge:
        return 28;
    }
  }

  static double _getIconSize(TealAvatarSize size) {
    switch (size) {
      case TealAvatarSize.small:
        return 16;
      case TealAvatarSize.medium:
        return 24;
      case TealAvatarSize.large:
        return 32;
      case TealAvatarSize.extraLarge:
        return 48;
    }
  }

  TealBadgeSize _getBadgeSize() {
    switch (size) {
      case TealAvatarSize.small:
        return TealBadgeSize.small;
      case TealAvatarSize.medium:
        return TealBadgeSize.small;
      case TealAvatarSize.large:
        return TealBadgeSize.medium;
      case TealAvatarSize.extraLarge:
        return TealBadgeSize.large;
    }
  }
}

// 아바타 그룹 위젯
class TealAvatarGroup extends StatelessWidget {
  final List<TealAvatar> avatars;
  final int maxVisible;
  final TealAvatarSize size;
  final double spacing;
  final VoidCallback? onMoreTap;
  final String Function(int)? moreBuilder;

  const TealAvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 3,
    this.size = TealAvatarSize.medium,
    this.spacing = -8,
    this.onMoreTap,
    this.moreBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatars.take(maxVisible).toList();
    final remainingCount = avatars.length - maxVisible;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...visibleAvatars.asMap().entries.map((entry) {
          final index = entry.key;
          final avatar = entry.value;
          
          return Container(
            margin: EdgeInsets.only(left: index > 0 ? spacing : 0),
            child: avatar,
          );
        }),
        
        if (remainingCount > 0) ...[
          Container(
            margin: EdgeInsets.only(left: spacing),
            child: TealAvatar(
              size: size,
              child: Text(
                moreBuilder?.call(remainingCount) ?? '+$remainingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppColors.textSecondary,
              onTap: onMoreTap,
            ),
          ),
        ],
      ],
    );
  }
}

// 편집 가능한 아바타 위젯
class TealEditableAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final TealAvatarSize size;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final bool showEditIcon;
  final bool showRemoveIcon;
  final String? heroTag;

  const TealEditableAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = TealAvatarSize.large,
    this.onEdit,
    this.onRemove,
    this.showEditIcon = true,
    this.showRemoveIcon = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TealAvatar(
          imageUrl: imageUrl,
          name: name,
          size: size,
          heroTag: heroTag,
          onTap: onEdit,
        ),
        
        if (showEditIcon) ...[
          Positioned(
            right: -4,
            bottom: -4,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
        
        if (showRemoveIcon) ...[
          Positioned(
            right: -4,
            top: -4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}