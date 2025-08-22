import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteItems = [
    {
      'id': '1',
      'name': '미러리스 카메라',
      'description': '소니 A7 III, 렌즈 포함',
      'price': '25,000원/일',
      'location': '신촌',
      'distance': '1.2km',
      'rating': 4.8,
      'reviewCount': 23,
      'image': 'https://via.placeholder.com/120x120',
      'owner': '김철수',
      'isAvailable': true,
      'category': '카메라',
    },
    {
      'id': '2',
      'name': '캠핑용 의자 세트',
      'description': '4개 세트, 접이식',
      'price': '8,000원/일',
      'location': '강남',
      'distance': '2.8km',
      'rating': 4.9,
      'reviewCount': 15,
      'image': 'https://via.placeholder.com/120x120',
      'owner': '이영희',
      'isAvailable': false,
      'category': '캠핑',
    },
    {
      'id': '3',
      'name': '아기 유모차',
      'description': '신생아용 고급형 유모차',
      'price': '12,000원/일',
      'location': '잠실',
      'distance': '0.5km',
      'rating': 5.0,
      'reviewCount': 8,
      'image': 'https://via.placeholder.com/120x120',
      'owner': '박민수',
      'isAvailable': true,
      'category': '육아',
    },
    {
      'id': '4',
      'name': '전기 자전거',
      'description': '접이식 전기자전거',
      'price': '15,000원/일',
      'location': '홍대',
      'distance': '3.2km',
      'rating': 4.7,
      'reviewCount': 32,
      'image': 'https://via.placeholder.com/120x120',
      'owner': '최수진',
      'isAvailable': true,
      'category': '교통',
    },
  ];

  String selectedFilter = '전체';
  final List<String> filterOptions = ['전체', '대여 가능', '대여중', '카테고리별'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '관심 목록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1F2937)),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 바
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  '필터: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filterOptions.map((option) {
                        final isSelected = selectedFilter == option;
                        return GestureDetector(
                          onTap: () => setState(() => selectedFilter = option),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFEC4899) : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 통계 정보
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  '총 ${favoriteItems.length}개 아이템',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                Text(
                  '대여 가능: ${favoriteItems.where((item) => item['isAvailable']).length}개',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 아이템 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getFilteredItems().length,
              itemBuilder: (context, index) {
                final item = _getFilteredItems()[index];
                return _buildFavoriteItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    switch (selectedFilter) {
      case '대여 가능':
        return favoriteItems.where((item) => item['isAvailable']).toList();
      case '대여중':
        return favoriteItems.where((item) => !item['isAvailable']).toList();
      default:
        return favoriteItems;
    }
  }

  Widget _buildFavoriteItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 아이템 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: const Color(0xFFF3F4F6),
                child: const Icon(
                  Icons.image,
                  color: Color(0xFF6B7280),
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // 아이템 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item['isAvailable'] 
                              ? const Color(0xFF10B981).withOpacity(0.1)
                              : const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['isAvailable'] ? '대여 가능' : '대여중',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: item['isAvailable'] 
                                ? const Color(0xFF10B981) 
                                : const Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _removeFavorite(item['id']),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFEC4899),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['rating']} (${item['reviewCount']})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${item['location']} · ${item['distance']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        item['price'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                      const Spacer(),
                      if (item['isAvailable'])
                        ElevatedButton(
                          onPressed: () => _showRentalDialog(context, item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            '대여하기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => _showNotificationDialog(context, item),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF6B7280)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            '알림 설정',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFavorite(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('관심 목록에서 제거'),
        content: const Text('이 아이템을 관심 목록에서 제거하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                favoriteItems.removeWhere((item) => item['id'] == itemId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('관심 목록에서 제거되었습니다')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('제거', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRentalDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${item['name']} 대여'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('대여자: ${item['owner']}'),
            Text('위치: ${item['location']} (${item['distance']})'),
            Text('일일 대여료: ${item['price']}'),
            const SizedBox(height: 16),
            const Text('대여하시겠습니까?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('대여 요청이 전송되었습니다')),
              );
            },
            child: const Text('대여 요청'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대여 가능 알림'),
        content: Text('${item['name']}이(가) 대여 가능해지면 알림을 받으시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림이 설정되었습니다')),
              );
            },
            child: const Text('알림 설정'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('관심 목록 검색'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: '아이템명, 카테고리 등을 검색하세요',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('검색 기능을 구현 예정입니다')),
              );
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }
}