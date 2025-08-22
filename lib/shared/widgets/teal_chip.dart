import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TealChipType { primary, secondary, outline, success, warning, error }
enum TealChipSize { small, medium, large }

class TealChip extends StatelessWidget {
  final String label;
  final Widget? avatar;
  final IconData? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final TealChipType type;
  final TealChipSize size;
  final bool isSelected;
  final Color? backgroundColor;
  final Color? labelColor;
  final EdgeInsetsGeometry? padding;

  const TealChip({
    super.key,
    required this.label,
    this.avatar,
    this.icon,
    this.onPressed,
    this.onDeleted,
    this.type = TealChipType.primary,
    this.size = TealChipSize.medium,
    this.isSelected = false,
    this.backgroundColor,
    this.labelColor,
    this.padding,
  });

  // 팩토리 생성자들
  factory TealChip.filter({
    Key? key,
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
    Widget? avatar,
    IconData? icon,
    TealChipSize? size,
  }) = _TealFilterChip;

  factory TealChip.choice({
    Key? key,
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    Widget? avatar,
    IconData? icon,
    TealChipSize? size,
  }) = _TealChoiceChip;

  factory TealChip.action({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    Widget? avatar,
    IconData? icon,
    TealChipType? type,
    TealChipSize? size,
  }) = _TealActionChip;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chipStyle = _getChipStyle(isDarkMode);
    
    if (onDeleted != null) {
      return _buildDeletableChip(chipStyle);
    } else if (onPressed != null) {
      return _buildActionChip(chipStyle);
    } else {
      return _buildStandardChip(chipStyle);
    }
  }

  ChipStyle _getChipStyle(bool isDarkMode) {
    final sizeProps = _getSizeProperties();
    
    switch (type) {
      case TealChipType.primary:
        return ChipStyle(
          backgroundColor: isSelected 
            ? AppColors.primary 
            : (backgroundColor ?? AppColors.tealPale),
          labelColor: isSelected 
            ? Colors.white 
            : (labelColor ?? AppColors.primary),
          borderColor: AppColors.primary,
          fontSize: sizeProps['fontSize'],
          padding: padding ?? sizeProps['padding'],
          borderRadius: sizeProps['borderRadius'],
        );
      
      case TealChipType.secondary:
        return ChipStyle(
          backgroundColor: isSelected 
            ? AppColors.secondary 
            : (backgroundColor ?? (isDarkMode ? AppColors.surfaceDark : AppColors.background)),
          labelColor: isSelected 
            ? Colors.white 
            : (labelColor ?? (isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary)),
          borderColor: AppColors.secondary,
          fontSize: sizeProps['fontSize'],
          padding: padding ?? sizeProps['padding'],
          borderRadius: sizeProps['borderRadius'],
        );
      
      case TealChipType.outline:
        return ChipStyle(
          backgroundColor: backgroundColor ?? Colors.transparent,
          labelColor: labelColor ?? AppColors.primary,
          borderColor: AppColors.primary,
          fontSize: sizeProps['fontSize'],
          padding: padding ?? sizeProps['padding'],
          borderRadius: sizeProps['borderRadius'],
          showBorder: true,
        );
      
      case TealChipType.success:
        return ChipStyle(
          backgroundColor: isSelected 
            ? AppColors.success 
            : (backgroundColor ?? AppColors.success.withValues(alpha: 0.1)),
          labelColor: isSelected 
            ? Colors.white 
            : (labelColor ?? AppColors.success),
          borderColor: AppColors.success,
          fontSize: sizeProps['fontSize'],
          padding: padding ?? sizeProps['padding'],
          borderRadius: sizeProps['borderRadius'],
        );
      
      case TealChipType.warning:
        return ChipStyle(
          backgroundColor: isSelected 
            ? AppColors.warning 
            : (backgroundColor ?? AppColors.warning.withValues(alpha: 0.1)),
          labelColor: isSelected 
            ? Colors.white 
            : (labelColor ?? AppColors.warning),
          borderColor: AppColors.warning,
          fontSize: sizeProps['fontSize'],
          padding: padding ?? sizeProps['padding'],
          borderRadius: sizeProps['borderRadius'],
        );
      
      case TealChipType.error:
        return ChipStyle(
          backgroundColor: isSelected 
            ? AppColors.error 
            : (backgroundColor ?? AppColors.error.withValues(alpha: 0.1)),
          labelColor: isSelected 
            ? Colors.white 
            : (labelColor ?? AppColors.error),
          borderColor: AppColors.error,
          fontSize: sizeProps['fontSize'],
          padding: padding ?? sizeProps['padding'],
          borderRadius: sizeProps['borderRadius'],
        );
    }
  }

  Map<String, dynamic> _getSizeProperties() {
    switch (size) {
      case TealChipSize.small:
        return {
          'fontSize': 12.0,
          'padding': const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          'borderRadius': 12.0,
          'iconSize': 14.0,
        };
      case TealChipSize.medium:
        return {
          'fontSize': 14.0,
          'padding': const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          'borderRadius': 16.0,
          'iconSize': 16.0,
        };
      case TealChipSize.large:
        return {
          'fontSize': 16.0,
          'padding': const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          'borderRadius': 20.0,
          'iconSize': 18.0,
        };
    }
  }

  Widget _buildStandardChip(ChipStyle style) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: style.showBorder 
          ? Border.all(color: style.borderColor, width: 1.5)
          : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatar != null) ...[
            avatar!,
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(
              icon,
              size: _getSizeProperties()['iconSize'],
              color: style.labelColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: style.fontSize,
              fontWeight: FontWeight.w500,
              color: style.labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(ChipStyle style) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(style.borderRadius),
      child: _buildStandardChip(style),
    );
  }

  Widget _buildDeletableChip(ChipStyle style) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: style.showBorder 
          ? Border.all(color: style.borderColor, width: 1.5)
          : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatar != null) ...[
            avatar!,
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(
              icon,
              size: _getSizeProperties()['iconSize'],
              color: style.labelColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: style.fontSize,
              fontWeight: FontWeight.w500,
              color: style.labelColor,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              Icons.close,
              size: _getSizeProperties()['iconSize'],
              color: style.labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

// 필터 칩
class _TealFilterChip extends TealChip {
  final ValueChanged<bool> onSelected;

  const _TealFilterChip({
    super.key,
    required super.label,
    required super.isSelected,
    required this.onSelected,
    super.avatar,
    super.icon,
    TealChipSize? size,
  }) : super(size: size ?? TealChipSize.medium);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      avatar: avatar,
      backgroundColor: AppColors.tealPale,
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.primary,
        fontSize: _getSizeProperties()['fontSize'],
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getSizeProperties()['borderRadius']),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// 선택 칩
class _TealChoiceChip extends TealChip {
  final VoidCallback onSelected;

  const _TealChoiceChip({
    super.key,
    required super.label,
    required super.isSelected,
    required this.onSelected,
    super.avatar,
    super.icon,
    TealChipSize? size,
  }) : super(size: size ?? TealChipSize.medium);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      avatar: avatar,
      backgroundColor: AppColors.tealPale,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.primary,
        fontSize: _getSizeProperties()['fontSize'],
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getSizeProperties()['borderRadius']),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// 액션 칩
class _TealActionChip extends TealChip {
  const _TealActionChip({
    super.key,
    required super.label,
    required VoidCallback super.onPressed,
    super.avatar,
    super.icon,
    TealChipType? type,
    TealChipSize? size,
  }) : super(
          type: type ?? TealChipType.primary,
          size: size ?? TealChipSize.medium,
        );

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onPressed,
      avatar: avatar,
      backgroundColor: type == TealChipType.primary 
        ? AppColors.tealPale 
        : _getChipStyle(Theme.of(context).brightness == Brightness.dark).backgroundColor,
      labelStyle: TextStyle(
        color: AppColors.primary,
        fontSize: _getSizeProperties()['fontSize'],
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getSizeProperties()['borderRadius']),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class ChipStyle {
  final Color backgroundColor;
  final Color labelColor;
  final Color borderColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool showBorder;

  const ChipStyle({
    required this.backgroundColor,
    required this.labelColor,
    required this.borderColor,
    required this.fontSize,
    required this.padding,
    required this.borderRadius,
    this.showBorder = false,
  });
}

// 칩 그룹 위젯
class TealChipGroup extends StatefulWidget {
  final List<String> items;
  final List<String>? selectedItems;
  final ValueChanged<List<String>>? onSelectionChanged;
  final bool multiSelect;
  final TealChipType type;
  final TealChipSize size;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;

  const TealChipGroup({
    super.key,
    required this.items,
    this.selectedItems,
    this.onSelectionChanged,
    this.multiSelect = false,
    this.type = TealChipType.primary,
    this.size = TealChipSize.medium,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  State<TealChipGroup> createState() => _TealChipGroupState();
}

class _TealChipGroupState extends State<TealChipGroup> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems ?? []);
  }

  @override
  void didUpdateWidget(TealChipGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      _selectedItems = List.from(widget.selectedItems ?? []);
    }
  }

  void _onItemTapped(String item) {
    setState(() {
      if (widget.multiSelect) {
        if (_selectedItems.contains(item)) {
          _selectedItems.remove(item);
        } else {
          _selectedItems.add(item);
        }
      } else {
        if (_selectedItems.contains(item)) {
          _selectedItems.clear();
        } else {
          _selectedItems = [item];
        }
      }
    });
    widget.onSelectionChanged?.call(_selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: widget.alignment,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: widget.items.map((item) {
        final isSelected = _selectedItems.contains(item);
        return TealChip(
          label: item,
          type: widget.type,
          size: widget.size,
          isSelected: isSelected,
          onPressed: () => _onItemTapped(item),
        );
      }).toList(),
    );
  }
}