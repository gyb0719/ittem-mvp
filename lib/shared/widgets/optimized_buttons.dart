import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';

/// Optimized button with minimum 44x44 touch target and improved UX
class OptimizedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDestructive;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final bool showFeedback;
  
  const OptimizedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDestructive = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.margin,
    this.showFeedback = true,
  });

  @override
  State<OptimizedButton> createState() => _OptimizedButtonState();
}

enum ButtonType { primary, secondary, text, outlined }

class _OptimizedButtonState extends State<OptimizedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null && widget.showFeedback) {
      _animationController.forward();
      setState(() => _isPressed = true);
      
      // Haptic feedback for better tactile response
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading && widget.showFeedback) {
      _animationController.reverse();
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading && widget.showFeedback) {
      _animationController.reverse();
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    return Container(
      margin: widget.margin,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: isDisabled ? null : widget.onPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                constraints: const BoxConstraints(
                  minHeight: 48, // 48px minimum height for touch target
                  minWidth: 64,  // Reasonable minimum width
                ),
                decoration: _getDecoration(isDisabled),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isDisabled ? null : widget.onPressed,
                    borderRadius: BorderRadius.circular(12),
                    splashColor: _getSplashColor(),
                    highlightColor: _getHighlightColor(),
                    child: Padding(
                      padding: _getPadding(),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: widget.isLoading
                              ? _buildLoadingIndicator()
                              : _buildContent(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 20,
            color: _getTextColor(),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
              height: 1.5, // 150% line height
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    // Add success checkmark animation when pressed
    if (_isPressed && widget.showFeedback && !widget.isLoading) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: 0.3,
            duration: const Duration(milliseconds: 100),
            child: content,
          ),
        ],
      );
    }

    return content;
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
      ),
    );
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    Color backgroundColor;
    Color borderColor;
    
    switch (widget.type) {
      case ButtonType.primary:
        backgroundColor = isDisabled
            ? AppColors.textTertiary.withValues(alpha: 0.3)
            : (widget.isDestructive ? AppColors.error : AppColors.primary);
        borderColor = backgroundColor;
        break;
      case ButtonType.secondary:
        backgroundColor = isDisabled
            ? AppColors.background
            : AppColors.tealPale;
        borderColor = isDisabled
            ? AppColors.separator
            : AppColors.primary.withValues(alpha: 0.3);
        break;
      case ButtonType.outlined:
        backgroundColor = Colors.transparent;
        borderColor = isDisabled
            ? AppColors.separator
            : (widget.isDestructive ? AppColors.error : AppColors.primary);
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        borderColor = Colors.transparent;
        break;
    }

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor,
        width: widget.type == ButtonType.outlined ? 1.5 : 0,
      ),
      boxShadow: widget.type == ButtonType.primary && !isDisabled
          ? [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ]
          : null,
    );
  }

  Color _getTextColor() {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    switch (widget.type) {
      case ButtonType.primary:
        return isDisabled
            ? AppColors.textSecondary
            : Colors.white;
      case ButtonType.secondary:
        return isDisabled
            ? AppColors.textTertiary
            : (widget.isDestructive ? AppColors.error : AppColors.primary);
      case ButtonType.outlined:
      case ButtonType.text:
        return isDisabled
            ? AppColors.textTertiary
            : (widget.isDestructive ? AppColors.error : AppColors.primary);
    }
  }

  Color _getSplashColor() {
    switch (widget.type) {
      case ButtonType.primary:
        return Colors.white.withValues(alpha: 0.2);
      case ButtonType.secondary:
      case ButtonType.outlined:
      case ButtonType.text:
        return AppColors.primary.withValues(alpha: 0.1);
    }
  }

  Color _getHighlightColor() {
    switch (widget.type) {
      case ButtonType.primary:
        return Colors.white.withValues(alpha: 0.1);
      case ButtonType.secondary:
      case ButtonType.outlined:
      case ButtonType.text:
        return AppColors.primary.withValues(alpha: 0.05);
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.outlined:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
      case ButtonType.text:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
  }
}

/// Optimized icon button with minimum 44x44 touch target
class OptimizedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;
  final bool showBackground;
  final bool isLoading;
  
  const OptimizedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = 24,
    this.showBackground = false,
    this.isLoading = false,
  });

  @override
  State<OptimizedIconButton> createState() => _OptimizedIconButtonState();
}

class _OptimizedIconButtonState extends State<OptimizedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
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

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    Widget button = GestureDetector(
      onTapDown: isDisabled ? null : (_) {
        _animationController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: isDisabled ? null : (_) => _animationController.reverse(),
      onTapCancel: isDisabled ? null : () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 44, // Minimum touch target width
              height: 44, // Minimum touch target height
              decoration: widget.showBackground
                  ? BoxDecoration(
                      color: isDisabled
                          ? AppColors.separator.withValues(alpha: 0.3)
                          : AppColors.tealPale,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDisabled
                            ? AppColors.separator
                            : AppColors.primary.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    )
                  : null,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(12),
                  splashColor: AppColors.primary.withValues(alpha: 0.2),
                  highlightColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.color ?? AppColors.primary,
                                ),
                              ),
                            )
                          : Icon(
                              widget.icon,
                              size: widget.size,
                              color: isDisabled
                                  ? AppColors.textTertiary
                                  : (widget.color ?? AppColors.textPrimary),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Optimized FAB with enhanced touch target and feedback
class OptimizedFAB extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final bool isExtended;
  final bool mini;
  
  const OptimizedFAB({
    super.key,
    required this.icon,
    this.label,
    this.onPressed,
    this.isExtended = false,
    this.mini = false,
  });

  @override
  State<OptimizedFAB> createState() => _OptimizedFABState();
}

class _OptimizedFABState extends State<OptimizedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
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

  @override
  Widget build(BuildContext context) {
    final size = widget.mini ? 48.0 : 56.0; // FAB standard sizes with touch target compliance
    
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isExtended && widget.label != null ? 20 : 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                        if (widget.isExtended && widget.label != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            widget.label!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}