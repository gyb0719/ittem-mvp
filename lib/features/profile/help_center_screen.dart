import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpCenterScreen extends ConsumerStatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  ConsumerState<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends ConsumerState<HelpCenterScreen> with SingleTickerProviderStateMixin {
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
          '고객센터',
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
          labelColor: const Color(0xFF64748B),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF64748B),
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: '문의하기'),
            Tab(text: '신고하기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFAQSection(),
          _buildInquirySection(),
          _buildReportSection(),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'category': '대여',
        'question': '물건은 어떻게 대여하나요?',
        'answer': '앱에서 원하는 물건을 찾고 대여 요청을 보내면, 물건 소유자가 승인 후 대여가 시작됩니다. 결제는 자동으로 진행되며, 약속된 장소에서 물건을 수령할 수 있습니다.',
      },
      {
        'category': '결제',
        'question': '대여료는 언제 결제되나요?',
        'answer': '대여 요청이 승인되면 즉시 결제가 진행됩니다. 결제는 등록된 결제 수단으로 자동 처리되며, 대여가 취소되면 전액 환불됩니다.',
      },
      {
        'category': '보험',
        'question': '물건이 손상되거나 분실되면 어떻게 하나요?',
        'answer': '모든 대여는 보험이 적용됩니다. 손상이나 분실 시 즉시 신고해주시면, 보험사에서 처리해드립니다. 고의적인 손상이 아닌 경우 추가 비용이 발생하지 않습니다.',
      },
      {
        'category': '계정',
        'question': '본인 인증은 어떻게 하나요?',
        'answer': '프로필 > 설정 > 본인 인증에서 신분증과 휴대폰 인증을 완료할 수 있습니다. 본인 인증을 완료하면 더 많은 물건을 대여할 수 있고, 신뢰도가 높아집니다.',
      },
      {
        'category': '대여',
        'question': '대여 기간을 연장할 수 있나요?',
        'answer': '대여 중인 물건의 연장은 물건 소유자와 협의 후 가능합니다. 채팅으로 연장 요청을 보내시거나, 앱에서 연장 신청을 할 수 있습니다.',
      },
      {
        'category': '결제',
        'question': '환불은 어떻게 받나요?',
        'answer': '대여가 취소되거나 물건에 문제가 있는 경우, 결제한 수단으로 3-5일 내에 환불됩니다. 부분 환불의 경우 사용하지 않은 기간에 대해 일할 계산하여 환불됩니다.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return _buildFAQCard(faq);
      },
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq) {
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF64748B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  faq['category'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  faq['question'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInquirySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 연락처 정보
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '연락처 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactItem(Icons.email, '이메일', 'help@ittem.com'),
                _buildContactItem(Icons.phone, '전화', '1588-1234'),
                _buildContactItem(Icons.chat, '카카오톡', '@ittem'),
                _buildContactItem(Icons.access_time, '운영시간', '평일 09:00 - 18:00'),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 문의하기 폼
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '문의하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: '문의 유형',
                    border: OutlineInputBorder(),
                  ),
                  items: ['대여 문의', '결제 문의', '계정 문의', '기타'].map((type) =>
                    DropdownMenuItem(value: type, child: Text(type)),
                  ).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: '제목',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: '문의 내용',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submitInquiry(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '문의 보내기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF64748B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '신고하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '부적절한 행위나 내용을 발견하셨나요?\n아래 양식을 통해 신고해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: '신고 유형',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    '사기/허위 매물',
                    '욕설/비방',
                    '스팸/광고',
                    '불법 물품',
                    '기타'
                  ].map((type) =>
                    DropdownMenuItem(value: type, child: Text(type)),
                  ).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: '신고 대상 (사용자명, 아이템명 등)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: '신고 내용',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    hintText: '구체적인 신고 사유를 작성해주세요.',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.warning,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '허위 신고는 제재를 받을 수 있습니다.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0x00f59e0b),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submitReport(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '신고 접수',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitInquiry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('문의 접수 완료'),
        content: const Text('문의가 접수되었습니다.\n24시간 내에 답변드리겠습니다.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('신고 접수 완료'),
        content: const Text('신고가 접수되었습니다.\n검토 후 적절한 조치를 취하겠습니다.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}