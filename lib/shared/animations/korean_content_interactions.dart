import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import 'animation_config.dart';

/// 한국 모바일 앱 스타일의 콘텐츠 인터랙션 애니메이션
/// 인스타그램, 네이버 블로그, 당근마켓 등의 UX 패턴을 참고

/// 인스타그램 스타일 이미지 줌/팬 애니메이션
class KoreanImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final VoidCallback? onClose;
  final double minScale;
  final double maxScale;
  final Duration animationDuration;

  const KoreanImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.onClose,
    this.minScale = 1.0,
    this.maxScale = 3.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<KoreanImageViewer> createState() => _KoreanImageViewerState();
}

class _KoreanImageViewerState extends State<KoreanImageViewer>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  late TransformationController _transformController;
  double _currentScale = 1.0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    
    _transformController = TransformationController();
    
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: AnimationConfig.koreanGentle,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    _currentScale = _transformController.value.getMaxScaleOnAxis();
    
    if (_currentScale > 1.1 && !_isZoomed) {
      setState(() => _isZoomed = true);
      HapticFeedback.lightImpact();
    } else if (_currentScale <= 1.1 && _isZoomed) {
      setState(() => _isZoomed = false);
    }
  }

  void _handleDoubleTap() {
    final currentScale = _transformController.value.getMaxScaleOnAxis();
    
    if (currentScale <= widget.minScale) {
      // Zoom in
      _transformController.value = Matrix4.identity()..scale(2.0);
      HapticFeedback.mediumImpact();
    } else {
      // Zoom out
      _transformController.value = Matrix4.identity();
      HapticFeedback.lightImpact();
    }
  }

  void _handleClose() {
    _fadeController.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Stack(
              children: [
                // Background overlay
                GestureDetector(
                  onTap: _isZoomed ? null : _handleClose,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                
                // Image viewer
                Center(
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: InteractiveViewer(
                      transformationController: _transformController,
                      minScale: widget.minScale,
                      maxScale: widget.maxScale,
                      onInteractionUpdate: _handleInteractionUpdate,
                      child: GestureDetector(
                        onDoubleTap: _handleDoubleTap,
                        child: widget.heroTag != null
                            ? Hero(
                                tag: widget.heroTag!,
                                child: _buildImage(),
                              )
                            : _buildImage(),
                      ),
                    ),
                  ),
                ),
                
                // Close button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _handleClose,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                
                // Scale indicator
                if (_isZoomed)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${(_currentScale * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage() {
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.separator.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: 8),
              Text(
                '이미지를 불러올 수 없습니다',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 네이버 스타일 검색바 확장 애니메이션
class KoreanExpandableSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final VoidCallback? onClear;
  final List<String>? suggestions;
  final bool autoFocus;
  final Duration animationDuration;

  const KoreanExpandableSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.suggestions,
    this.autoFocus = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<KoreanExpandableSearchBar> createState() => _KoreanExpandableSearchBarState();
}

class _KoreanExpandableSearchBarState extends State<KoreanExpandableSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _fadeController;
  late Animation<double> _widthAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  late TextEditingController _textController;
  late FocusNode _focusNode;
  
  bool _isExpanded = false;
  bool _showSuggestions = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    
    _textController = TextEditingController();
    _focusNode = FocusNode();
    
    _textController.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
    
    _initializeAnimations();
    
    if (widget.autoFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _expand();
      });
    }
  }

  void _initializeAnimations() {
    _expandController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: 48.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: AnimationConfig.koreanGentle,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _expandController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final newQuery = _textController.text;
    setState(() {
      _currentQuery = newQuery;
      _showSuggestions = newQuery.isNotEmpty && 
                       widget.suggestions != null &&
                       widget.suggestions!.isNotEmpty;
    });
    
    widget.onChanged?.call(newQuery);
    
    if (_showSuggestions) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _currentQuery.isEmpty) {
      _collapse();
    }
  }

  void _expand() {
    setState(() => _isExpanded = true);
    _expandController.forward();
    _focusNode.requestFocus();
    HapticFeedback.lightImpact();
  }

  void _collapse() {
    setState(() {
      _isExpanded = false;
      _showSuggestions = false;
    });
    _expandController.reverse();
    _fadeController.reverse();
    _focusNode.unfocus();
  }

  void _clear() {
    _textController.clear();
    setState(() {
      _currentQuery = '';
      _showSuggestions = false;
    });
    _fadeController.reverse();
    widget.onClear?.call();
    HapticFeedback.lightImpact();
  }

  void _selectSuggestion(String suggestion) {
    _textController.text = suggestion;
    setState(() {
      _currentQuery = suggestion;
      _showSuggestions = false;
    });
    _fadeController.reverse();
    widget.onSubmitted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandController,
      builder: (context, child) {
        return Column(
          children: [
            // Search bar
            Container(
              height: 48,
              width: _isExpanded 
                  ? double.infinity 
                  : _widthAnimation.value,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isExpanded ? AppColors.primary : AppColors.separator,
                  width: 1,
                ),
                boxShadow: _isExpanded ? [
                  const BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                children: [
                  // Search icon or back button
                  GestureDetector(
                    onTap: _isExpanded ? _collapse : _expand,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Icon(
                        _isExpanded ? Icons.arrow_back : Icons.search,
                        color: _isExpanded ? AppColors.primary : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  // Text field
                  if (_isExpanded)
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: widget.hintText ?? '검색어를 입력하세요',
                          hintStyle: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        onSubmitted: (_) => widget.onSubmitted?.call(),
                      ),
                    ),
                  
                  // Clear button
                  if (_isExpanded && _currentQuery.isNotEmpty)
                    GestureDetector(
                      onTap: _clear,
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Suggestions
            if (_showSuggestions)
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: widget.suggestions!
                              .where((suggestion) => suggestion
                                  .toLowerCase()
                                  .contains(_currentQuery.toLowerCase()))
                              .take(5)
                              .map((suggestion) => _buildSuggestionItem(suggestion))
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return GestureDetector(
      onTap: () => _selectSuggestion(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.separator, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.textTertiary,
              size: 16,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.call_made,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// 당근마켓 스타일 필터 칩 애니메이션
class KoreanFilterChips extends StatefulWidget {
  final List<String> filters;
  final List<String> selectedFilters;
  final ValueChanged<List<String>>? onChanged;
  final Duration animationDuration;

  const KoreanFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilters,
    this.onChanged,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<KoreanFilterChips> createState() => _KoreanFilterChipsState();
}

class _KoreanFilterChipsState extends State<KoreanFilterChips>
    with TickerProviderStateMixin {
  late Map<String, AnimationController> _controllers;
  late Map<String, Animation<double>> _scaleAnimations;
  late Map<String, Animation<Color?>> _colorAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = {};
    _scaleAnimations = {};
    _colorAnimations = {};

    for (String filter in widget.filters) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      _controllers[filter] = controller;

      _scaleAnimations[filter] = Tween<double>(
        begin: 1.0,
        end: 1.1,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AnimationConfig.koreanBounce,
      ));

      _colorAnimations[filter] = ColorTween(
        begin: AppColors.surface,
        end: AppColors.primary,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));

      if (widget.selectedFilters.contains(filter)) {
        controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleFilter(String filter) {
    final isSelected = widget.selectedFilters.contains(filter);
    final newSelectedFilters = List<String>.from(widget.selectedFilters);

    if (isSelected) {
      newSelectedFilters.remove(filter);
      _controllers[filter]?.reverse();
    } else {
      newSelectedFilters.add(filter);
      _controllers[filter]?.forward();
    }

    widget.onChanged?.call(newSelectedFilters);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.filters.map((filter) {
        final isSelected = widget.selectedFilters.contains(filter);
        
        return AnimatedBuilder(
          animation: _controllers[filter]!,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[filter]!.value,
              child: GestureDetector(
                onTap: () => _toggleFilter(filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _colorAnimations[filter]!.value,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.separator,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// 평점 인터랙션 애니메이션
class KoreanRatingWidget extends StatefulWidget {
  final double rating;
  final ValueChanged<double>? onRatingChanged;
  final int maxRating;
  final double size;
  final bool allowHalfRating;
  final bool readOnly;

  const KoreanRatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.maxRating = 5,
    this.size = 24.0,
    this.allowHalfRating = true,
    this.readOnly = false,
  });

  @override
  State<KoreanRatingWidget> createState() => _KoreanRatingWidgetState();
}

class _KoreanRatingWidgetState extends State<KoreanRatingWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.maxRating,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.3,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AnimationConfig.koreanBounce,
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

  void _handleTap(int index) {
    if (widget.readOnly) return;

    final newRating = (index + 1).toDouble();
    setState(() => _currentRating = newRating);
    
    // Animate tapped star
    _controllers[index].forward().then((_) {
      _controllers[index].reverse();
    });
    
    widget.onRatingChanged?.call(newRating);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        final starValue = index + 1;
        final isFullStar = _currentRating >= starValue;
        final isHalfStar = widget.allowHalfRating && 
                          _currentRating >= starValue - 0.5 && 
                          _currentRating < starValue;

        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              child: GestureDetector(
                onTap: () => _handleTap(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    isFullStar
                        ? Icons.star
                        : (isHalfStar ? Icons.star_half : Icons.star_border),
                    size: widget.size,
                    color: (isFullStar || isHalfStar) 
                        ? Colors.amber 
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}