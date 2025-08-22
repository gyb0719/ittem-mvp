import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import 'animation_config.dart';

/// 한국 모바일 앱 스타일의 폼 인터랙션 애니메이션
/// 토스, 카카오페이, 뱅크샐러드 등의 UX 패턴을 참고

/// 토스 스타일 텍스트 필드 애니메이션
class KoreanAnimatedTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<String>? validationRules;
  final bool enableValidation;
  final Duration animationDuration;

  const KoreanAnimatedTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.keyboardType,
    this.validationRules,
    this.enableValidation = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<KoreanAnimatedTextField> createState() => _KoreanAnimatedTextFieldState();
}

class _KoreanAnimatedTextFieldState extends State<KoreanAnimatedTextField>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _errorController;
  late AnimationController _successController;
  
  late Animation<double> _focusScaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _labelScaleAnimation;
  late Animation<Offset> _labelPositionAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _successScaleAnimation;

  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  bool _isValid = false;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    _initializeAnimations();
    
    if (widget.controller != null) {
      _currentText = widget.controller!.text;
      widget.controller!.addListener(_handleTextChange);
    }
  }

  void _initializeAnimations() {
    _focusController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _errorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _successController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: AnimationConfig.koreanGentle,
    ));

    _borderColorAnimation = ColorTween(
      begin: AppColors.separator,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _labelScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _labelPositionAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1.2),
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _errorController,
      curve: Curves.elasticOut,
    ));

    _successScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: AnimationConfig.koreanBounce,
    ));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusController.dispose();
    _errorController.dispose();
    _successController.dispose();
    widget.controller?.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused || _currentText.isNotEmpty) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
    
    if (_isFocused) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTextChange() {
    final newText = widget.controller?.text ?? '';
    setState(() {
      _currentText = newText;
    });
    
    if (widget.enableValidation) {
      _validateText(newText);
    }
    
    widget.onChanged?.call(newText);
    
    if (newText.isNotEmpty && !_isFocused) {
      _focusController.forward();
    } else if (newText.isEmpty && !_isFocused) {
      _focusController.reverse();
    }
  }

  void _validateText(String text) {
    if (widget.validationRules == null || text.isEmpty) {
      setState(() {
        _hasError = false;
        _isValid = false;
      });
      return;
    }

    bool isValid = true;
    for (String rule in widget.validationRules!) {
      if (!_checkValidationRule(text, rule)) {
        isValid = false;
        break;
      }
    }

    setState(() {
      _hasError = !isValid && text.isNotEmpty;
      _isValid = isValid && text.isNotEmpty;
    });

    if (_hasError) {
      _triggerShakeAnimation();
    } else if (_isValid) {
      _triggerSuccessAnimation();
    }
  }

  bool _checkValidationRule(String text, String rule) {
    switch (rule) {
      case 'required':
        return text.isNotEmpty;
      case 'email':
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text);
      case 'phone':
        return RegExp(r'^01[0-9]-?[0-9]{4}-?[0-9]{4}$').hasMatch(text);
      case 'password':
        return text.length >= 8;
      default:
        return true;
    }
  }

  void _triggerShakeAnimation() {
    _errorController.forward().then((_) {
      _errorController.reverse();
    });
    HapticFeedback.heavyImpact();
  }

  void _triggerSuccessAnimation() {
    _successController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _successController.reverse();
        }
      });
    });
    HapticFeedback.mediumImpact();
  }

  Color _getBorderColor() {
    if (_hasError) return AppColors.error;
    if (_isValid) return AppColors.success;
    return _borderColorAnimation.value ?? AppColors.separator;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _focusController,
        _errorController,
        _successController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * 8 * 
            (1 - _shakeAnimation.value) * 
            ((_shakeAnimation.value * 4).round() % 2 == 0 ? 1 : -1),
            0,
          ),
          child: Transform.scale(
            scale: _focusScaleAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Text field
                    TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      onTap: widget.onTap,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          color: AppColors.textTertiary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _getBorderColor(),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _getBorderColor(),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _getBorderColor(),
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    
                    // Floating label
                    if (widget.labelText != null)
                      Positioned(
                        left: 12,
                        top: 16,
                        child: Transform.translate(
                          offset: _labelPositionAnimation.value * 20,
                          child: Transform.scale(
                            scale: _labelScaleAnimation.value,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              color: AppColors.surface,
                              child: Text(
                                widget.labelText!,
                                style: TextStyle(
                                  color: _getBorderColor(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Success indicator
                    if (_isValid)
                      Positioned(
                        right: 12,
                        top: 16,
                        child: Transform.scale(
                          scale: _successScaleAnimation.value,
                          child: const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Helper/Error text
                if (widget.errorText != null && _hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.errorText!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                ] else if (widget.helperText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.helperText!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 뱅크샐러드 스타일 진행 표시기
class KoreanProgressIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final Duration animationDuration;

  const KoreanProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<KoreanProgressIndicator> createState() => _KoreanProgressIndicatorState();
}

class _KoreanProgressIndicatorState extends State<KoreanProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.koreanGentle,
    ));

    _updateProgress();
  }

  @override
  void didUpdateWidget(KoreanProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    final progress = (widget.currentStep - 1) / (widget.totalSteps - 1);
    _controller.animateTo(progress.clamp(0.0, 1.0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            // Progress bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: widget.inactiveColor ?? AppColors.separator,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.activeColor ?? AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Step indicators
            if (widget.stepLabels != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(widget.totalSteps, (index) {
                  final isActive = index < widget.currentStep;
                  final isCurrent = index == widget.currentStep - 1;
                  
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive 
                                ? (widget.activeColor ?? AppColors.primary)
                                : (widget.inactiveColor ?? AppColors.separator),
                            border: isCurrent ? Border.all(
                              color: widget.activeColor ?? AppColors.primary,
                              width: 2,
                            ) : null,
                          ),
                          child: isActive ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ) : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCurrent 
                                  ? (widget.activeColor ?? AppColors.primary)
                                  : AppColors.textTertiary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.stepLabels![index],
                          style: TextStyle(
                            color: isActive 
                                ? AppColors.textPrimary
                                : AppColors.textTertiary,
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// 카카오페이 스타일 PIN 입력
class KoreanPinInput extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Duration animationDuration;

  const KoreanPinInput({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.obscureText = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<KoreanPinInput> createState() => _KoreanPinInputState();
}

class _KoreanPinInputState extends State<KoreanPinInput>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Color?>> _colorAnimations;
  
  String _currentPin = '';
  List<bool> _isFilledList = [];

  @override
  void initState() {
    super.initState();
    
    _isFilledList = List.filled(widget.length, false);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AnimationConfig.koreanBounce,
      ));
    }).toList();

    _colorAnimations = _controllers.map((controller) {
      return ColorTween(
        begin: AppColors.separator,
        end: AppColors.primary,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value) {
    if (value.length <= widget.length) {
      setState(() {
        _currentPin = value;
        for (int i = 0; i < widget.length; i++) {
          final wasFilled = _isFilledList[i];
          final isFilled = i < value.length;
          _isFilledList[i] = isFilled;
          
          if (isFilled && !wasFilled) {
            _controllers[i].forward().then((_) {
              _controllers[i].reverse();
            });
            HapticFeedback.lightImpact();
          }
        }
      });
      
      widget.onChanged?.call(value);
      
      if (value.length == widget.length) {
        widget.onCompleted?.call(value);
        HapticFeedback.mediumImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.length, (index) {
            final isFilled = index < _currentPin.length;
            final isCurrent = index == _currentPin.length;
            
            return AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent 
                            ? AppColors.primary
                            : (isFilled 
                                ? AppColors.primary
                                : AppColors.separator),
                        width: isCurrent ? 2 : 1,
                      ),
                      color: isFilled ? AppColors.primary : Colors.transparent,
                    ),
                    child: Center(
                      child: widget.obscureText && isFilled
                          ? const Icon(
                              Icons.circle,
                              size: 12,
                              color: Colors.white,
                            )
                          : (isFilled
                              ? Text(
                                  _currentPin[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        
        // Hidden text field for input
        Opacity(
          opacity: 0,
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: widget.length,
            onChanged: _handleInput,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}