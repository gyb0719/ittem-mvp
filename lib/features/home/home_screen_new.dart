import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../theme/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // 샘플 데이터 (실제로는 Supabase에서 가져올 예정)
  final List<Map<String, dynamic>> _sampleItems = [
    {
      'id': '1',
      'title': '브라이언 토이 콜더브루 세트',
      'price': 325000,
      'location': '당산동',
      'timeAgo': '방금 전',
      'image': 'assets/images/item1.jpg',
      'isLiked': false,
    },
    {
      'id': '2',
      'title': '무늬 몬스테라',
      'price': 10000,
      'location': '합정동',
      'timeAgo': '10분 전',
      'image': 'assets/images/item2.jpg',
      'isLiked': true,
    },
    {
      'id': '3',
      'title': '체어 드라이팅 주머니',
      'price': 7000,
      'location': '홍대입구동',
      'timeAgo': '30분 전',
      'image': 'assets/images/item3.jpg',
      'isLiked': false,
    },
    {
      'id': '4',
      'title': '반려동물용 침대',
      'price': 15000,
      'location': '연남동',
      'timeAgo': '1시간 전',
      'image': 'assets/images/item4.jpg',
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              '잠실동',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textPrimary,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 카테고리 탭 섹션
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryTab('전체', true),
                const SizedBox(width: 20),
                _buildCategoryTab('부동산', false),
                const SizedBox(width: 20),
                _buildCategoryTab('중고차', false),
              ],
            ),
          ),
          
          const Divider(height: 1, color: AppColors.separator),
          
          // 아이템 리스트
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _sampleItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _sampleItems[index];
                return _buildItemCard(item, numberFormat);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add item screen
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle category selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, NumberFormat numberFormat) {
    return GestureDetector(
      onTap: () {
        // Navigate to item detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.separator,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: AppColors.separator,
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 콘텐츠
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // 위치 및 시간
                    Text(
                      '${item['location']} · ${item['timeAgo']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 가격
                    Text(
                      '${numberFormat.format(item['price'])}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 하트 아이콘
              IconButton(
                onPressed: () {
                  setState(() {
                    _sampleItems[_sampleItems.indexOf(item)]['isLiked'] = 
                        !item['isLiked'];
                  });
                },
                icon: Icon(
                  item['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  color: item['isLiked'] ? Colors.red : AppColors.textTertiary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}