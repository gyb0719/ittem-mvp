import 'package:flutter/material.dart';
import '../../theme/colors.dart';

enum TealButtonType { primary, secondary, outline, text, danger, success }
enum TealButtonSize { small, medium, large }

class TealButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TealButtonType type;
  final TealButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final IconData? iconData;
  final bool iconOnly;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  const TealButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = TealButtonType.primary,
    this.size = TealButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.iconData,
    this.iconOnly = false,
    this.width,
    this.height,
    this.padding,
    this.fullWidth = false,
  });

  // 팩토리 생성자들
  factory TealButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    TealButtonType? type,
    TealButtonSize? size,
    bool? isLoading,
    String? tooltip,
  }) = _TealIconButton;

  factory TealButton.outline({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    TealButtonSize? size,
    bool? isLoading,
    Widget? icon,
    IconData? iconData,
    bool? fullWidth,
  }) => TealButton(
    key: key,
    text: text,
    onPressed: onPressed,
    type: TealButtonType.outline,
    size: size ?? TealButtonSize.medium,
    isLoading: isLoading ?? false,
    icon: icon,
    iconData: iconData,
    fullWidth: fullWidth ?? false,
  );

  factory TealButton.text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool? isLoading,
    Widget? icon,
  }) = _TealTextButton;

  @override
  State<TealButton> createState() => _TealButtonState();
}

class _TealButtonState extends State<TealButton> 
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (widget.isLoading) {
      return _buildLoadingButton(context, isDarkMode);
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (widget.onPressed != null) {
                setState(() => _isPressed = true);
                _animationController.forward();
              }
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            child: _buildButton(context, isDarkMode),
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, bool isDarkMode) {
    switch (widget.type) {
      case TealButtonType.primary:
        return _buildPrimaryButton(context, isDarkMode);
      case TealButtonType.secondary:
        return _buildSecondaryButton(context, isDarkMode);
      case TealButtonType.outline:
        return _buildOutlineButton(context, isDarkMode);
      case TealButtonType.text:
        return _buildTextButton(context, isDarkMode);
      case TealButtonType.danger:
        return _buildDangerButton(context, isDarkMode);
      case TealButtonType.success:
        return _buildSuccessButton(context, isDarkMode);
    }
  }

  // 사이즈별 속성 가져오기
  Map<String, dynamic> _getSizeProperties() {
    switch (widget.size) {
      case TealButtonSize.small:
        return {
          'padding': const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          'fontSize': 14.0,
          'iconSize': 16.0,
          'borderRadius': 8.0,
        };
      case TealButtonSize.medium:
        return {
          'padding': const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          'fontSize': 16.0,
          'iconSize': 20.0,
          'borderRadius': 12.0,
        };
      case TealButtonSize.large:
        return {
          'padding': const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          'fontSize': 18.0,
          'iconSize': 24.0,
          'borderRadius': 16.0,
        };
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(props['borderRadius']),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: _buildButtonContent(
          Colors.white, 
          props['fontSize'], 
          props['iconSize']
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? AppColors.surfaceDark : AppColors.tealPale,
          foregroundColor: AppColors.primary,
          elevation: 0,
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: _buildButtonContent(
          AppColors.primary, 
          props['fontSize'], 
          props['iconSize']
        ),
      ),
    );
  }

  Widget _buildOutlineButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: _buildButtonContent(
          AppColors.primary, 
          props['fontSize'], 
          props['iconSize']
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: _buildButtonContent(
          AppColors.primary, 
          props['fontSize'], 
          props['iconSize']
        ),
      ),
    );
  }

  Widget _buildDangerButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(props['borderRadius']),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: _buildButtonContent(
          Colors.white, 
          props['fontSize'], 
          props['iconSize']
        ),
      ),
    );
  }

  Widget _buildSuccessButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(props['borderRadius']),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: _buildButtonContent(
          Colors.white, 
          props['fontSize'], 
          props['iconSize']
        ),
      ),
    );
  }

  Widget _buildLoadingButton(BuildContext context, bool isDarkMode) {
    final props = _getSizeProperties();
    return Container(
      width: widget.fullWidth ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(props['borderRadius']),
      ),
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: widget.padding ?? props['padding'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(props['borderRadius']),
          ),
        ),
        child: SizedBox(
          height: props['iconSize'],
          width: props['iconSize'],
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor, double fontSize, double iconSize) {
    if (widget.iconOnly) {
      return Icon(
        widget.iconData,
        size: iconSize,
        color: textColor,
      );
    }
    
    if (widget.icon != null || widget.iconData != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon ?? Icon(
            widget.iconData,
            size: iconSize,
            color: textColor,
          ),
          if (!widget.iconOnly) ...[
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      );
    }
    
    return Text(
      widget.text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// 아이콘 전용 버튼
class _TealIconButton extends TealButton {
  final String? tooltip;

  const _TealIconButton({
    super.key,
    required IconData icon,
    required super.onPressed,
    TealButtonType? type,
    TealButtonSize? size,
    bool? isLoading,
    this.tooltip,
  }) : super(
          text: '',
          iconData: icon,
          iconOnly: true,
          type: type ?? TealButtonType.primary,
          size: size ?? TealButtonSize.medium,
          isLoading: isLoading ?? false,
        );

  @override
  Widget build(BuildContext context) {
    Widget button = TealButton(
      text: text,
      onPressed: onPressed,
      type: type,
      size: size,
      isLoading: isLoading,
      iconData: iconData,
      iconOnly: iconOnly,
    );
    
    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    
    return button;
  }
}

// 텍스트 전용 버튼
class _TealTextButton extends TealButton {
  const _TealTextButton({
    super.key,
    required super.text,
    required super.onPressed,
    bool? isLoading,
    super.icon,
  }) : super(
          type: TealButtonType.text,
          isLoading: isLoading ?? false,
        );
}