import 'package:flutter/material.dart';
import '../../shared/animations/korean_animation_manager.dart';
import '../../theme/colors.dart';

/// Korean Animation System Demo Screen
/// 모든 한국 모바일 UX 애니메이션을 시연하는 화면
class KoreanAnimationsDemo extends StatefulWidget {
  const KoreanAnimationsDemo({super.key});

  @override
  State<KoreanAnimationsDemo> createState() => _KoreanAnimationsDemoState();
}

class _KoreanAnimationsDemoState extends State<KoreanAnimationsDemo>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isLiked = false;
  double _rating = 3.0;
  String _searchQuery = '';
  List<String> _selectedFilters = [];
  bool _showSuccessAnimation = false;
  int _currentStep = 1;
  String _pinValue = '';

  final List<String> _demoItems = [
    '당근마켓 스타일 애니메이션',
    '쿠팡 스타일 인터랙션',
    '카카오톡 버블 효과',
    '토스 성공 애니메이션',
    '네이버 검색 확장',
  ];

  final List<String> _filterOptions = [
    '전체', '의류', '전자제품', '가구', '도서', '스포츠', '기타'
  ];

  final List<String> _searchSuggestions = [
    '아이폰', '맥북', '의자', '책상', '운동기구', '옷장'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the animation manager
    KoreanAnimationManager.instance.initialize(
      performanceMode: false,
      reduceMotion: false,
      animationScale: 1.0,
      enableHaptics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KoreanAnimationMonitor(
      showStats: true,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Korean UX Animations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            // Tab navigation
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.separator, width: 0.5),
                ),
              ),
              child: KoreanAnimatedNavigationBar(
                currentIndex: _currentTabIndex,
                onTap: (index) => setState(() => _currentTabIndex = index),
                items: const [
                  KoreanNavItem(
                    icon: Icons.touch_app_outlined,
                    activeIcon: Icons.touch_app,
                    label: '터치',
                  ),
                  KoreanNavItem(
                    icon: Icons.list_outlined,
                    activeIcon: Icons.list,
                    label: '리스트',
                  ),
                  KoreanNavItem(
                    icon: Icons.edit_outlined,
                    activeIcon: Icons.edit,
                    label: '폼',
                  ),
                  KoreanNavItem(
                    icon: Icons.image_outlined,
                    activeIcon: Icons.image,
                    label: '콘텐츠',
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildTouchInteractionsTab();
      case 1:
        return _buildListAnimationsTab();
      case 2:
        return _buildFormInteractionsTab();
      case 3:
        return _buildContentInteractionsTab();
      default:
        return Container();
    }
  }

  Widget _buildTouchInteractionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('터치 인터랙션'),
        const SizedBox(height: 16),
        
        // Heart animation
        _buildDemoCard(
          title: '당근마켓 스타일 하트 애니메이션',
          description: '탭하면 하트가 바운스 효과와 함께 애니메이션됩니다',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KoreanHeartButton(
                isLiked: _isLiked,
                size: 32,
                onTap: () => setState(() => _isLiked = !_isLiked),
              ),
              const SizedBox(width: 20),
              Text(
                _isLiked ? '좋아요!' : '하트를 탭해보세요',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Premium button
        _buildDemoCard(
          title: '네이버 스타일 프리미엄 버튼',
          description: '누르면 스케일과 그림자 효과가 적용됩니다',
          child: Center(
            child: KoreanPremiumButton(
              onPressed: () {
                KoreanAnimationUtils.haptic(HapticType.medium);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('버튼이 눌렸습니다!')),
                );
              },
              child: const Text(
                '프리미엄 버튼',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Price highlight
        _buildDemoCard(
          title: '쿠팡 스타일 가격 하이라이트',
          description: '가격이 강조되며 애니메이션됩니다',
          child: Center(
            child: KoreanPriceHighlight(
              price: '29,900원',
              originalPrice: '39,900원',
              animate: true,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Success animation
        _buildDemoCard(
          title: '토스 스타일 성공 애니메이션',
          description: '체크마크가 그려지며 성공을 알립니다',
          child: Column(
            children: [
              KoreanSuccessAnimation(
                show: _showSuccessAnimation,
                onComplete: () {
                  setState(() => _showSuccessAnimation = false);
                },
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.separator),
                  ),
                  child: const Center(
                    child: Text(
                      '결제 완료!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => _showSuccessAnimation = true);
                },
                child: const Text('성공 애니메이션 실행'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListAnimationsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('리스트 & 카드 애니메이션'),
        const SizedBox(height: 16),
        
        // Staggered list
        _buildDemoCard(
          title: '당근마켓 스타일 스태거드 리스트',
          description: '아이템들이 순차적으로 나타납니다',
          child: KoreanStaggeredList(
            children: _demoItems.map((item) => _buildListItem(item)).toList(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Interactive cards
        _buildDemoCard(
          title: '쿠팡 스타일 인터랙티브 카드',
          description: '마우스 호버시 그림자와 스케일 효과가 적용됩니다',
          child: Column(
            children: [
              KoreanInteractiveCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('카드가 클릭되었습니다!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    children: [
                      Icon(Icons.shopping_bag, color: AppColors.primary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '상품명',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '상품 설명이 들어갑니다',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '15,000원',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Chat bubbles
        _buildDemoCard(
          title: '카카오톡 스타일 채팅 버블',
          description: '메시지가 순차적으로 나타납니다',
          child: Column(
            children: [
              KoreanChatBubble(
                isOwn: false,
                animationIndex: 0,
                child: const Text(
                  '안녕하세요! 상품 문의드립니다.',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              KoreanChatBubble(
                isOwn: true,
                animationIndex: 1,
                child: const Text(
                  '네, 무엇이 궁금하신가요?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              KoreanChatBubble(
                isOwn: false,
                animationIndex: 2,
                child: const Text(
                  '가격 조정 가능한가요?',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormInteractionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('폼 인터랙션'),
        const SizedBox(height: 16),
        
        // Animated text field
        _buildDemoCard(
          title: '토스 스타일 텍스트 필드',
          description: '포커스시 라벨이 위로 이동하고 검증 애니메이션이 적용됩니다',
          child: KoreanAnimatedTextField(
            labelText: '이메일',
            hintText: 'example@example.com',
            errorText: '올바른 이메일 형식을 입력해주세요',
            validationRules: const ['email'],
            enableValidation: true,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Progress indicator
        _buildDemoCard(
          title: '뱅크샐러드 스타일 진행 표시기',
          description: '단계별 진행상황을 애니메이션으로 표시합니다',
          child: Column(
            children: [
              KoreanProgressIndicator(
                currentStep: _currentStep,
                totalSteps: 4,
                stepLabels: const ['기본정보', '사진업로드', '가격설정', '완료'],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _currentStep > 1 
                        ? () => setState(() => _currentStep--)
                        : null,
                    child: const Text('이전'),
                  ),
                  ElevatedButton(
                    onPressed: _currentStep < 4
                        ? () => setState(() => _currentStep++)
                        : null,
                    child: const Text('다음'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // PIN input
        _buildDemoCard(
          title: '카카오페이 스타일 PIN 입력',
          description: '숫자를 입력하면 원형 필드가 채워집니다',
          child: Column(
            children: [
              KoreanPinInput(
                length: 6,
                onChanged: (value) => setState(() => _pinValue = value),
                onCompleted: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PIN 입력 완료: $value')),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'PIN: $_pinValue',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentInteractionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('콘텐츠 인터랙션'),
        const SizedBox(height: 16),
        
        // Expandable search
        _buildDemoCard(
          title: '네이버 스타일 검색바 확장',
          description: '검색 아이콘을 탭하면 검색바가 확장됩니다',
          child: KoreanExpandableSearchBar(
            hintText: '상품명을 입력하세요',
            suggestions: _searchSuggestions,
            onChanged: (value) => setState(() => _searchQuery = value),
            onSubmitted: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('검색: $_searchQuery')),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Filter chips
        _buildDemoCard(
          title: '당근마켓 스타일 필터 칩',
          description: '탭하면 선택상태가 애니메이션으로 변경됩니다',
          child: KoreanFilterChips(
            filters: _filterOptions,
            selectedFilters: _selectedFilters,
            onChanged: (selected) => setState(() => _selectedFilters = selected),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Rating widget
        _buildDemoCard(
          title: '평점 인터랙션 애니메이션',
          description: '별점을 탭하면 스케일 효과가 적용됩니다',
          child: Column(
            children: [
              KoreanRatingWidget(
                rating: _rating,
                size: 32,
                onRatingChanged: (rating) => setState(() => _rating = rating),
              ),
              const SizedBox(height: 8),
              Text(
                '현재 평점: ${_rating.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Image viewer demo
        _buildDemoCard(
          title: '인스타그램 스타일 이미지 뷰어',
          description: '이미지를 탭하면 풀스크린으로 확장됩니다',
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, _, __) => KoreanImageViewer(
                      imageUrl: 'https://picsum.photos/400/300',
                      heroTag: 'demo_image',
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'demo_image',
                child: Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/400/300'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDemoCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.separator, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.separator, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}