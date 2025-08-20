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
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 데이터 로딩 시뮬레이션 (실제로는 Supabase에서 데이터를 가져옴)
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 임시로 샘플 데이터 사용 (데이터베이스 설정 완료 후 실제 데이터로 교체)
      
    } catch (e) {
      print('Get items error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
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
          // 검색창
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '어떤 물건을 찾고 계신가요?',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          
          // 카테고리 섹션
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '전체보기',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryIcon(Icons.apps, '전체', Colors.blue),
                    _buildCategoryIcon(Icons.camera_alt, '카메라', Colors.orange),
                    _buildCategoryIcon(Icons.sports_basketball, '스포츠', Colors.green),
                    _buildCategoryIcon(Icons.home, '도구', Colors.purple),
                    _buildCategoryIcon(Icons.shopping_bag, '주방용품', Colors.red),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 내 주변 인기 아이템 섹션
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '내 주변 인기 아이템',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
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

  Widget _buildCategoryIcon(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle category selection
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
                  if (!mounted) return;
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