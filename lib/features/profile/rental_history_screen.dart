import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RentalHistoryScreen extends ConsumerStatefulWidget {
  const RentalHistoryScreen({super.key});

  @override
  ConsumerState<RentalHistoryScreen> createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends ConsumerState<RentalHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          '대여 내역',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF3B82F6),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF3B82F6),
          tabs: const [
            Tab(text: '대여한 내역'),
            Tab(text: '빌려준 내역'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBorrowedHistory(),
          _buildLentHistory(),
        ],
      ),
    );
  }

  Widget _buildBorrowedHistory() {
    final borrowedItems = [
      {
        'name': '미러리스 카메라',
        'owner': '김철수',
        'period': '2024.12.15 ~ 2024.12.17',
        'price': '25,000원',
        'status': '완료',
        'rating': 5,
        'location': '신촌',
        'image': 'https://via.placeholder.com/60x60',
      },
      {
        'name': '게임용 의자',
        'owner': '이영희',
        'period': '2024.12.10 ~ 2024.12.12',
        'price': '12,000원',
        'status': '완료',
        'rating': 4,
        'location': '강남',
        'image': 'https://via.placeholder.com/60x60',
      },
      {
        'name': '캠핑용 텐트',
        'owner': '박민수',
        'period': '2024.12.05 ~ 2024.12.07',
        'price': '30,000원',
        'status': '완료',
        'rating': 5,
        'location': '홍대',
        'image': 'https://via.placeholder.com/60x60',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: borrowedItems.length,
      itemBuilder: (context, index) {
        final item = borrowedItems[index];
        return _buildHistoryCard(item, true);
      },
    );
  }

  Widget _buildLentHistory() {
    final lentItems = [
      {
        'name': '전자 키보드',
        'renter': '최수진',
        'period': '2024.12.18 ~ 2024.12.20',
        'price': '16,000원',
        'status': '완료',
        'rating': 5,
        'location': '잠실',
        'image': 'https://via.placeholder.com/60x60',
      },
      {
        'name': '드론',
        'renter': '정민호',
        'period': '2024.12.12 ~ 2024.12.14',
        'price': '45,000원',
        'status': '완료',
        'rating': 4,
        'location': '강남',
        'image': 'https://via.placeholder.com/60x60',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lentItems.length,
      itemBuilder: (context, index) {
        final item = lentItems[index];
        return _buildHistoryCard(item, false);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, bool isBorrowed) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFF3F4F6),
                    child: const Icon(
                      Icons.image,
                      color: Color(0xFF6B7280),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['status'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < item['rating'] ? Icons.star : Icons.star_border,
                                size: 16,
                                color: const Color(0xFFF59E0B),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBorrowed 
                            ? '대여자: ${item['owner']} (${item['location']})'
                            : '임대자: ${item['renter']} (${item['location']})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF3F4F6)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Text(
                  item['period'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                Text(
                  '총 ${item['price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showReceiptDialog(context, item),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6B7280)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '영수증 보기',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showReviewDialog(context, item, isBorrowed),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '리뷰 보기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('거래 영수증'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildReceiptRow('대여 기간', item['period']),
              _buildReceiptRow('일일 대여료', '15,000원'),
              _buildReceiptRow('대여 일수', '3일'),
              const Divider(),
              _buildReceiptRow('소계', '45,000원'),
              _buildReceiptRow('서비스 수수료', '2,250원'),
              _buildReceiptRow('보험료', '1,350원'),
              const Divider(),
              _buildReceiptRow('총 결제금액', item['price'], isBold: true),
              const SizedBox(height: 16),
              const Text(
                '결제 방법: 신한카드 ****1234',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              const Text(
                '거래 ID: TXN-20241215-001234',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('영수증이 이메일로 발송되었습니다')),
              );
            },
            child: const Text('이메일 발송'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1F2937),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, Map<String, dynamic> item, bool isBorrowed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('거래 리뷰'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBorrowed ? '${item['owner']}님에게 받은 리뷰' : '${item['renter']}님에게 받은 리뷰',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < item['rating'] ? Icons.star : Icons.star_border,
                        size: 20,
                        color: const Color(0xFFF59E0B),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item['rating']}.0',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '"깨끗하게 관리되어 있고, 시간 약속도 잘 지켜주셨어요. 물건 상태도 설명과 동일했습니다. 다음에도 이용하고 싶네요!"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isBorrowed ? '${item['owner']}님에게 작성한 리뷰' : '${item['renter']}님에게 작성한 리뷰',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 5 ? Icons.star : Icons.star_border,
                        size: 20,
                        color: const Color(0xFFF59E0B),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '5.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '"친절하고 물건도 정말 깨끗했어요. 설명해주신 대로 사용하기 쉬웠고, 반납도 편하게 해주셨습니다. 추천합니다!"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}