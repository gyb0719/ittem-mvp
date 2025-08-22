import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TealAppBarType { standard, gradient, transparent }

class TealAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final TealAppBarType type;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double toolbarHeight;

  const TealAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.elevation,
    this.type = TealAppBarType.standard,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
  );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    switch (type) {
      case TealAppBarType.standard:
        return _buildStandardAppBar(context, isDarkMode);
      case TealAppBarType.gradient:
        return _buildGradientAppBar(context, isDarkMode);
      case TealAppBarType.transparent:
        return _buildTransparentAppBar(context, isDarkMode);
    }
  }

  AppBar _buildStandardAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      title: _buildTitle(isDarkMode),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? 
        (isDarkMode ? AppColors.backgroundDark : AppColors.surface),
      foregroundColor: foregroundColor ?? 
        (isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildGradientAppBar(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: AppBar(
        title: _buildTitle(false, Colors.white),
        actions: actions?.map((action) => 
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: action,
          ),
        ).toList(),
        leading: leading != null ? Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: leading!,
        ) : null,
        automaticallyImplyLeading: automaticallyImplyLeading,
        bottom: bottom,
        elevation: 0,
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        toolbarHeight: toolbarHeight,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  AppBar _buildTransparentAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      title: _buildTitle(isDarkMode),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      elevation: 0,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor ?? 
        (isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary),
      toolbarHeight: toolbarHeight,
    );
  }

  Widget? _buildTitle(bool isDarkMode, [Color? textColor]) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;
    
    return Text(
      title!,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textColor ?? 
          (isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary),
      ),
    );
  }
}

// 검색 기능이 있는 앱바
class TealSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? hintText;
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double toolbarHeight;

  const TealSearchAppBar({
    super.key,
    this.hintText = '검색...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  State<TealSearchAppBar> createState() => _TealSearchAppBarState();
}

class _TealSearchAppBarState extends State<TealSearchAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: _buildSearchField(isDarkMode),
      actions: [
        if (_isSearchActive) ...[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _isSearchActive = false;
                _focusNode.unfocus();
              });
              widget.onSearchChanged?.call('');
            },
          ),
        ],
        ...?widget.actions,
      ],
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      elevation: 0,
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.surface,
      foregroundColor: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary,
      toolbarHeight: widget.toolbarHeight,
    );
  }

  Widget _buildSearchField(bool isDarkMode) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isSearchActive ? AppColors.primary : AppColors.separator,
          width: _isSearchActive ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: (value) {
          setState(() {
            _isSearchActive = value.isNotEmpty;
          });
          widget.onSearchChanged?.call(value);
        },
        onSubmitted: widget.onSearchSubmitted,
        style: TextStyle(
          color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDarkMode ? AppColors.textTertiaryDark : AppColors.textTertiary,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _isSearchActive ? AppColors.primary : AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}