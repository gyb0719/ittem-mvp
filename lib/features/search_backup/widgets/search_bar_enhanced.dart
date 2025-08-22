import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_suggestion.dart' as suggestion_model;
import '../services/search_suggestions_service.dart';

class EnhancedSearchBar extends ConsumerStatefulWidget {
  final String? initialValue;
  final String hintText;
  final Function(String) onSubmitted;
  final Function(String)? onChanged;
  final Function(suggestion_model.SearchSuggestion)? onSuggestionSelected;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onCameraSearch;
  final bool showVoiceButton;
  final bool showCameraButton;
  final bool showSuggestions;
  final bool autofocus;
  final EdgeInsets? padding;

  const EnhancedSearchBar({
    super.key,
    this.initialValue,
    this.hintText = '찾고 있는 물건을 검색해보세요',
    required this.onSubmitted,
    this.onChanged,
    this.onSuggestionSelected,
    this.onVoiceSearch,
    this.onCameraSearch,
    this.showVoiceButton = true,
    this.showCameraButton = true,
    this.showSuggestions = true,
    this.autofocus = false,
    this.padding,
  });

  @override
  ConsumerState<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends ConsumerState<EnhancedSearchBar>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  
  bool _isExpanded = false;
  bool _showSuggestions = false;
  List<suggestion_model.SearchSuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _expandSearchBar();
      if (widget.showSuggestions) {
        _showSuggestionsOverlay();
      }
    } else {
      _collapseSearchBar();
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
    if (widget.showSuggestions && _focusNode.hasFocus) {
      _updateSuggestions(_controller.text);
    }
  }

  void _expandSearchBar() {
    setState(() => _isExpanded = true);
    _animationController.forward();
  }

  void _collapseSearchBar() {
    setState(() => _isExpanded = false);
    _animationController.reverse();
  }

  Future<void> _updateSuggestions(String query) async {
    if (!mounted) return;
    
    try {
      final suggestionsAsync = ref.read(searchSuggestionsProvider(query));
      suggestionsAsync.when(
        data: (suggestions) {
          if (mounted) {
            setState(() {
              _suggestions = suggestions;
              _showSuggestions = suggestions.isNotEmpty;
            });
            _updateOverlay();
          }
        },
        loading: () {},
        error: (error, stack) {
          if (mounted) {
            setState(() {
              _suggestions = [];
              _showSuggestions = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _showSuggestions = false;
        });
      }
    }
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: _buildSuggestionsPanel(),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSuggestionTap(suggestion_model.SearchSuggestion suggestion) {
    _controller.text = suggestion.text;
    widget.onSuggestionSelected?.call(suggestion);
    widget.onSubmitted(suggestion.text);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Container(
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isExpanded 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: _isExpanded ? 2 : 1,
                ),
                boxShadow: _isExpanded ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                children: [
                  // 검색 아이콘
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.search,
                      color: _isExpanded 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  
                  // 검색 입력 필드
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: widget.autofocus,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onSubmitted: widget.onSubmitted,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  
                  // 지우기 버튼 (텍스트가 있을 때만)
                  if (_controller.text.isNotEmpty)
                    AnimatedScale(
                      scale: _expandAnimation.value,
                      duration: const Duration(milliseconds: 150),
                      child: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _controller.clear();
                          widget.onChanged?.call('');
                        },
                        splashRadius: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  
                  // 음성 검색 버튼
                  if (widget.showVoiceButton)
                    AnimatedScale(
                      scale: _isExpanded ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 150),
                      child: IconButton(
                        icon: const Icon(Icons.mic, size: 20),
                        onPressed: widget.onVoiceSearch ?? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('음성 검색 기능 준비 중입니다')),
                          );
                        },
                        splashRadius: 20,
                        color: _isExpanded
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  
                  // 카메라 검색 버튼
                  if (widget.showCameraButton)
                    AnimatedScale(
                      scale: _isExpanded ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 150),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          onPressed: widget.onCameraSearch ?? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('이미지 검색 기능 준비 중입니다')),
                            );
                          },
                          splashRadius: 20,
                          color: _isExpanded
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuggestionsPanel() {
    if (!_showSuggestions || _suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 제안 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  '검색 제안',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // 제안 리스트
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return _buildSuggestionItem(suggestion);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(suggestion_model.SearchSuggestion suggestion) {
    IconData icon;
    Color iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
    
    switch (suggestion.type) {
      case suggestion_model.SearchSuggestionType.recent:
        icon = Icons.history;
        break;
      case suggestion_model.SearchSuggestionType.popular:
        icon = Icons.trending_up;
        iconColor = Theme.of(context).colorScheme.primary;
        break;
      case suggestion_model.SearchSuggestionType.category:
        icon = Icons.category;
        break;
      case suggestion_model.SearchSuggestionType.brand:
        icon = Icons.business;
        break;
      case suggestion_model.SearchSuggestionType.location:
        icon = Icons.location_on;
        break;
      default:
        icon = Icons.search;
    }

    return ListTile(
      dense: true,
      leading: Icon(icon, size: 18, color: iconColor),
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: _highlightSearchTerm(suggestion.text, _controller.text),
        ),
      ),
      subtitle: suggestion.resultsCount > 0
          ? Text(
              '${suggestion.resultsCount}개 결과',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: suggestion.type == suggestion_model.SearchSuggestionType.recent
          ? IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () {
                // TODO: 최근 검색어에서 제거
              },
              splashRadius: 16,
            )
          : null,
      onTap: () => _onSuggestionTap(suggestion),
    );
  }

  List<TextSpan> _highlightSearchTerm(String text, String searchTerm) {
    if (searchTerm.isEmpty) {
      return [TextSpan(text: text)];
    }

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerSearchTerm = searchTerm.toLowerCase();
    
    int start = 0;
    int index = lowerText.indexOf(lowerSearchTerm);
    
    while (index >= 0) {
      // 매치 이전 텍스트
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      // 매치된 텍스트 (하이라이트)
      spans.add(TextSpan(
        text: text.substring(index, index + searchTerm.length),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ));
      
      start = index + searchTerm.length;
      index = lowerText.indexOf(lowerSearchTerm, start);
    }
    
    // 남은 텍스트
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return spans;
  }
}