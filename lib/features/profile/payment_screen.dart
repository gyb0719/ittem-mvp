import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> with SingleTickerProviderStateMixin {
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
          '결제 관리',
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
          labelColor: const Color(0xFF10B981),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF10B981),
          tabs: const [
            Tab(text: '결제 수단'),
            Tab(text: '결제 내역'),
            Tab(text: '정산 내역'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaymentMethods(),
          _buildPaymentHistory(),
          _buildEarningsHistory(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {
        'type': 'card',
        'name': '신한카드',
        'number': '**** **** **** 1234',
        'isDefault': true,
        'icon': Icons.credit_card,
        'color': Color(0xFF1E40AF),
      },
      {
        'type': 'kakao',
        'name': '카카오페이',
        'number': 'user@kakao.com',
        'isDefault': false,
        'icon': Icons.account_balance_wallet,
        'color': Color(0xFFFDE047),
      },
      {
        'type': 'bank',
        'name': '계좌이체',
        'number': '국민은행 ****1234',
        'isDefault': false,
        'icon': Icons.account_balance,
        'color': Color(0xFF059669),
      },
    ];

    return Column(
      children: [
        // 월렛 정보
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ittem 월렛',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '잔액: 45,000원',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _showChargeDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('충전', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 결제 수단 목록
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: paymentMethods.length + 1,
            itemBuilder: (context, index) {
              if (index == paymentMethods.length) {
                return _buildAddPaymentMethodCard();
              }
              final method = paymentMethods[index];
              return _buildPaymentMethodCard(method);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: method['isDefault'] 
            ? Border.all(color: const Color(0xFF10B981), width: 2)
            : null,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (method['isDefault']) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '기본',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method['number'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Color(0xFF6B7280)),
              itemBuilder: (context) => [
                if (!method['isDefault'])
                  PopupMenuItem(
                    child: const Text('기본으로 설정'),
                    onTap: () => _setAsDefault(method),
                  ),
                PopupMenuItem(
                  child: const Text('수정'),
                  onTap: () => _editPaymentMethod(method),
                ),
                PopupMenuItem(
                  child: const Text('삭제'),
                  onTap: () => _deletePaymentMethod(method),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPaymentMethodCard() {
    return GestureDetector(
      onTap: () => _showAddPaymentMethodDialog(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF6B7280),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: Color(0xFF6B7280),
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              '새 결제 수단 추가',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistory() {
    final payments = [
      {
        'item': '미러리스 카메라',
        'amount': '25,000원',
        'date': '2024.12.20',
        'method': '신한카드 ****1234',
        'status': '완료',
        'type': '대여료',
        'period': '12/20 ~ 12/22',
      },
      {
        'item': '월렛 충전',
        'amount': '50,000원',
        'date': '2024.12.18',
        'method': '카카오페이',
        'status': '완료',
        'type': '충전',
        'period': '',
      },
      {
        'item': '게임용 의자',
        'amount': '12,000원',
        'date': '2024.12.15',
        'method': '신한카드 ****1234',
        'status': '완료',
        'type': '대여료',
        'period': '12/15 ~ 12/17',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaymentHistoryCard(payment);
      },
    );
  }

  Widget _buildPaymentHistoryCard(Map<String, dynamic> payment) {
    final isCharge = payment['type'] == '충전';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCharge 
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCharge ? Icons.add : Icons.shopping_cart,
                    color: isCharge ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['item'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payment['period'].isNotEmpty 
                            ? '대여기간: ${payment['period']}'
                            : payment['method'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isCharge ? '+' : '-'}${payment['amount']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCharge ? const Color(0xFF10B981) : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment['date'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!isCharge) ...[
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFF3F4F6)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '결제수단: ${payment['method']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showReceiptDialog(context, payment),
                    child: const Text(
                      '영수증 보기',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsHistory() {
    final earnings = [
      {
        'item': '전자 키보드',
        'amount': '16,000원',
        'commission': '1,600원',
        'net': '14,400원',
        'date': '2024.12.20',
        'renter': '박민수',
        'period': '12/18 ~ 12/20',
        'status': '정산 완료',
      },
      {
        'item': '드론',
        'amount': '45,000원',
        'commission': '4,500원',
        'net': '40,500원',
        'date': '2024.12.16',
        'renter': '김지영',
        'period': '12/14 ~ 12/16',
        'status': '정산 완료',
      },
      {
        'item': '캠핑용 텐트',
        'amount': '30,000원',
        'commission': '3,000원',
        'net': '27,000원',
        'date': '2024.12.12',
        'renter': '이영희',
        'period': '12/10 ~ 12/12',
        'status': '정산 완료',
      },
    ];

    return Column(
      children: [
        // 정산 요약
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '이번 달 수익',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '81,900원',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE5E7EB),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '정산 예정',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '12,000원',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: earnings.length,
            itemBuilder: (context, index) {
              final earning = earnings[index];
              return _buildEarningCard(earning);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEarningCard(Map<String, dynamic> earning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        earning['item'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '대여자: ${earning['renter']} · ${earning['period']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+${earning['net']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        earning['status'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF3F4F6)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '총 대여료: ${earning['amount']}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 16),
                Text(
                  '수수료: ${earning['commission']}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                const Spacer(),
                Text(
                  earning['date'],
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dialog methods
  void _showChargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('월렛 충전'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('충전할 금액을 선택하세요:'),
            const SizedBox(height: 16),
            ...['10,000원', '30,000원', '50,000원', '100,000원'].map((amount) =>
              ListTile(
                title: Text(amount),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$amount 충전이 완료되었습니다')),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('결제 수단 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('신용/체크카드'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('카드 등록 화면으로 이동합니다')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('계좌이체'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계좌 등록 화면으로 이동합니다')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(Map<String, dynamic> method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${method['name']}이(가) 기본 결제 수단으로 설정되었습니다')),
    );
  }

  void _editPaymentMethod(Map<String, dynamic> method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${method['name']} 정보를 수정합니다')),
    );
  }

  void _deletePaymentMethod(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('결제 수단 삭제'),
        content: Text('${method['name']}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('결제 수단이 삭제되었습니다')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('결제 영수증'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('상품명: ${payment['item']}'),
              Text('대여기간: ${payment['period']}'),
              Text('결제금액: ${payment['amount']}'),
              Text('결제수단: ${payment['method']}'),
              Text('결제일시: ${payment['date']}'),
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