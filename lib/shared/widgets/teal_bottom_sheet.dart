import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TealBottomSheetType { standard, modal, draggable }

class TealBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    TealBottomSheetType type = TealBottomSheetType.standard,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    String? barrierLabel,
    double? maxHeight,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? 
        (isDarkMode ? AppColors.surfaceDark : AppColors.surface),
      elevation: elevation ?? 8,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      barrierLabel: barrierLabel,
      constraints: maxHeight != null ? BoxConstraints(
        maxHeight: maxHeight,
      ) : null,
      builder: (context) => _TealBottomSheetContent(
        type: type,
        child: child,
      ),
    );
  }

  static Future<T?> showDraggable<T>({
    required BuildContext context,
    required Widget Function(BuildContext, ScrollController) builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
    bool expand = false,
    Color? backgroundColor,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: expand,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? 
              (isDarkMode ? AppColors.surfaceDark : AppColors.surface),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: builder(context, scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.separator,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _TealBottomSheetContent extends StatelessWidget {
  final TealBottomSheetType type;
  final Widget child;

  const _TealBottomSheetContent({
    required this.type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TealBottomSheetType.standard:
        return _buildStandardContent();
      case TealBottomSheetType.modal:
        return _buildModalContent();
      case TealBottomSheetType.draggable:
        return _buildDraggableContent();
    }
  }

  Widget _buildStandardContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildModalContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.separator,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: child,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDraggableContent() {
    return Column(
      children: [
        TealBottomSheet._buildDragHandle(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ],
    );
  }
}

// 미리 정의된 바텀시트들
class TealBottomSheetTemplates {
  // 선택 목록 바텀시트
  static Future<T?> showSelectionSheet<T>({
    required BuildContext context,
    required String title,
    required List<TealSelectionItem<T>> items,
    T? selectedValue,
    bool showSearchBar = false,
  }) {
    return TealBottomSheet.show<T>(
      context: context,
      isScrollControlled: true,
      child: _SelectionBottomSheet<T>(
        title: title,
        items: items,
        selectedValue: selectedValue,
        showSearchBar: showSearchBar,
      ),
    );
  }

  // 확인/취소 바텀시트
  static Future<bool?> showConfirmationSheet({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool isDestructive = false,
  }) {
    return TealBottomSheet.show<bool>(
      context: context,
      child: _ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
  }
}

class TealSelectionItem<T> {
  final T value;
  final String label;
  final Widget? icon;
  final String? description;

  const TealSelectionItem({
    required this.value,
    required this.label,
    this.icon,
    this.description,
  });
}

class _SelectionBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<TealSelectionItem<T>> items;
  final T? selectedValue;
  final bool showSearchBar;

  const _SelectionBottomSheet({
    required this.title,
    required this.items,
    this.selectedValue,
    this.showSearchBar = false,
  });

  @override
  State<_SelectionBottomSheet<T>> createState() => _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<_SelectionBottomSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<TealSelectionItem<T>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) =>
          item.label.toLowerCase().contains(query.toLowerCase()) ||
          (item.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // 검색바
          if (widget.showSearchBar) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: '검색...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.separator),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // 아이템 목록
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = item.value == widget.selectedValue;
                
                return ListTile(
                  leading: item.icon,
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  subtitle: item.description != null 
                    ? Text(item.description!) 
                    : null,
                  trailing: isSelected 
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                  selected: isSelected,
                  selectedTileColor: AppColors.tealPale.withValues(alpha: 0.3),
                  onTap: () => Navigator.of(context).pop(item.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  const _ConfirmationBottomSheet({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDestructive,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}