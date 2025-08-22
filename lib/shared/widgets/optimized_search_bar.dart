import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import 'optimized_buttons.dart';

/// Optimized search bar with 44x44 minimum touch targets
class OptimizedSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSubmitted;
  final TextEditingController? controller;
  final bool autofocus;
  final bool showFilter;
  
  const OptimizedSearchBar({
    super.key,
    this.hintText = '원하는 물건을 검색해보세요',
    this.onChanged,
    this.onFilterTap,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
    this.showFilter = true,
  });

  @override
  State<OptimizedSearchBar> createState() => _OptimizedSearchBarState();
}

class _OptimizedSearchBarState extends State<OptimizedSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }
  
  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged?.call(_controller.text);
  }
  
  void _handleSubmit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmitted?.call();
      _focusNode.unfocus();
    }
  }
  
  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    HapticFeedback.lightImpact();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44, // Adjusted to prevent overflow while maintaining touch target
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Search icon (non-interactive, for visual only)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
          
          // Text input
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              onSubmitted: (_) => _handleSubmit(),
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.5, // 150% line height
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppColors.textTertiary,
                  height: 1.5,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12, // Ensure proper vertical padding
                ),
              ),
            ),
          ),
          
          // Clear button (with 44x44 touch target)
          if (_hasText)
            OptimizedIconButton(
              icon: Icons.clear,
              onPressed: _clearText,
              size: 20,
              color: AppColors.textSecondary,
              tooltip: '검색어 지우기',
            ),
          
          // Filter button (with 44x44 touch target)
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: OptimizedIconButton(
                icon: Icons.tune,
                onPressed: widget.onFilterTap,
                size: 20,
                color: AppColors.primary,
                showBackground: true,
                tooltip: '필터 설정',
              ),
            ),
        ],
      ),
    );
  }
}

/// Quick filter chips with proper touch targets
class OptimizedFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  
  const OptimizedFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44, // Minimum touch target height
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : AppColors.separator.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}