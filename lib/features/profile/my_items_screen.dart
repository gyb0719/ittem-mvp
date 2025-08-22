import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyItemsScreen extends ConsumerStatefulWidget {
  const MyItemsScreen({super.key});

  @override
  ConsumerState<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends ConsumerState<MyItemsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '내 아이템',
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
            icon: const Icon(Icons.add, color: Color(0xFF1F2937)),
            onPressed: () => _showAddItemDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF8B5CF6),
          tabs: const [
            Tab(text: '대여 가능'),
            Tab(text: '대여중'),
            Tab(text: '예약중'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAvailableItems(),
          _buildRentedItems(),
          _buildReservedItems(),
        ],
      ),
    );
  }

  Widget _buildAvailableItems() {
    final availableItems = [
      {
        'name': '전자 키보드',
        'description': '88건반 디지털 피아노',
        'price': '8,000원/일',
        'image': 'https://via.placeholder.com/80x80',
        'category': '악기',
        'views': 15,
        'likes': 3,
      },
      {
        'name': '캠핑용 의자',
        'description': '접이식 편안한 의자',
        'price': '3,000원/일',
        'image': 'https://via.placeholder.com/80x80',
        'category': '캠핑',
        'views': 8,
        'likes': 1,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableItems.length,
      itemBuilder: (context, index) {
        final item = availableItems[index];
        return _buildItemCard(item, '대여 가능', const Color(0xFF10B981));
      },
    );
  }

  Widget _buildRentedItems() {
    final rentedItems = [
      {
        'name': '캐논 DSLR 카메라',
        'description': '여행 촬영용',
        'price': '15,000원/일',
        'image': 'https://via.placeholder.com/80x80',
        'category': '사진',
        'renter': '박민수',
        'period': '12/20 ~ 12/22',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rentedItems.length,
      itemBuilder: (context, index) {
        final item = rentedItems[index];
        return _buildItemCard(item, '대여중', const Color(0xFFF59E0B));
      },
    );
  }

  Widget _buildReservedItems() {
    final reservedItems = [
      {
        'name': '캠핑용 텐트 세트',
        'description': '4인용 완전 세트',
        'price': '20,000원/일',
        'image': 'https://via.placeholder.com/80x80',
        'category': '캠핑',
        'renter': '김지영',
        'period': '12/25 ~ 12/27',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservedItems.length,
      itemBuilder: (context, index) {
        final item = reservedItems[index];
        return _buildItemCard(item, '예약중', const Color(0xFF3B82F6));
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, String status, Color statusColor) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (status == '대여 가능')
                        Text(
                          '👁 ${item['views']} ❤️ ${item['likes']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
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
                      if (item.containsKey('renter'))
                        Text(
                          '${item['renter']} · ${item['period']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Color(0xFF6B7280)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('수정'),
                  onTap: () => _showEditItemDialog(context, item),
                ),
                PopupMenuItem(
                  child: const Text('삭제'),
                  onTap: () => _showDeleteItemDialog(context, item),
                ),
                if (status == '대여 가능')
                  PopupMenuItem(
                    child: const Text('일시정지'),
                    onTap: () => _showPauseItemDialog(context, item),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 아이템 등록'),
        content: const Text('아이템 등록 화면으로 이동하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('아이템 등록 화면으로 이동합니다')),
              );
            },
            child: const Text('등록하기'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이템 수정'),
        content: Text('${item['name']}을(를) 수정하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('아이템이 수정되었습니다')),
              );
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  void _showDeleteItemDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이템 삭제'),
        content: Text('${item['name']}을(를) 삭제하시겠습니까?\n\n삭제된 아이템은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('아이템이 삭제되었습니다')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showPauseItemDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이템 일시정지'),
        content: Text('${item['name']}의 대여를 일시정지하시겠습니까?\n\n일시정지 중에는 다른 사용자가 대여할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('아이템이 일시정지되었습니다')),
              );
            },
            child: const Text('일시정지'),
          ),
        ],
      ),
    );
  }
}