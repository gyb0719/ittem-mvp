import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class TealTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final String? errorText;
  final bool required;
  final List<dynamic>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const TealTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.errorText,
    this.required = false,
    this.inputFormatters,
    this.validator,
  });

  @override
  State<TealTextField> createState() => _TealTextFieldState();
}

class _TealTextFieldState extends State<TealTextField> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        if (widget.labelText != null) ...[
          Row(
            children: [
              Text(
                widget.labelText!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              if (widget.required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // 텍스트 필드
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: widget.enabled ? Colors.white : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError
                      ? AppColors.error
                      : _isFocused
                          ? AppColors.primary
                          : AppColors.separator,
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: [
                  if (_isFocused && !hasError)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  if (hasError)
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters?.cast(),
                style: TextStyle(
                  fontSize: 16,
                  color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 16,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused 
                              ? AppColors.primary 
                              : hasError
                                  ? AppColors.error
                                  : AppColors.textTertiary,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.prefixIcon != null ? 12 : 16,
                    vertical: 16,
                  ),
                  counterStyle: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
        
        // 에러 메시지
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 틸 색상 드롭다운
class TealDropdown<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final bool required;
  final String? errorText;
  final IconData? prefixIcon;

  const TealDropdown({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.required = false,
    this.errorText,
    this.prefixIcon,
  });

  @override
  State<TealDropdown<T>> createState() => _TealDropdownState<T>();
}

class _TealDropdownState<T> extends State<TealDropdown<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        if (widget.labelText != null) ...[
          Row(
            children: [
              Text(
                widget.labelText!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              if (widget.required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // 드롭다운
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : _isFocused
                      ? AppColors.primary
                      : AppColors.separator,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: [
              if (_isFocused && !hasError)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            initialValue: widget.value,
            items: widget.items,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 16,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused 
                          ? AppColors.primary 
                          : hasError
                              ? AppColors.error
                              : AppColors.textTertiary,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.prefixIcon != null ? 12 : 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            dropdownColor: Colors.white,
            focusColor: Colors.transparent,
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
          ),
        ),
        
        // 에러 메시지
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}