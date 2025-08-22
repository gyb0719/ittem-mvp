import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> with SingleTickerProviderStateMixin {
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
          '리뷰 관리',
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
          labelColor: const Color(0xFFF59E0B),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFFF59E0B),
          tabs: const [
            Tab(text: '받은 리뷰'),
            Tab(text: '작성한 리뷰'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 리뷰 통계
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('평균 평점', '4.8', '⭐', const Color(0xFFF59E0B)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('받은 리뷰', '12개', '📝', const Color(0xFF3B82F6)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('작성한 리뷰', '8개', '✏️', const Color(0xFF10B981)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReceivedReviews(),
                _buildWrittenReviews(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedReviews() {
    final receivedReviews = [
      {
        'reviewer': '박민수',
        'item': '전자 키보드',
        'rating': 5,
        'date': '2024.12.20',
        'comment': '깨끗하게 관리되어 있고, 시간 약속도 잘 지켜주셨어요. 물건 상태도 설명과 동일했습니다. 다음에도 이용하고 싶네요!',
        'type': '빌려줌',
        'helpful': 3,
      },
      {
        'reviewer': '김지영',
        'item': '캠핑용 텐트',
        'rating': 5,
        'date': '2024.12.18',
        'comment': '친절하고 물건도 정말 좋았어요. 설명도 자세히 해주시고 반납도 편하게 해주셨습니다. 강력 추천!',
        'type': '빌려줌',
        'helpful': 5,
      },
      {
        'reviewer': '이영희',
        'item': '미러리스 카메라',
        'rating': 4,
        'date': '2024.12.15',
        'comment': '사진 품질이 정말 좋네요. 다만 사용법을 좀 더 자세히 알려주시면 좋을 것 같아요.',
        'type': '빌림',
        'helpful': 2,
      },
      {
        'reviewer': '최수진',
        'item': '게임용 의자',
        'rating': 5,
        'date': '2024.12.12',
        'comment': '정말 편안했어요! 장시간 앉아있어도 피곤하지 않았습니다. 감사합니다.',
        'type': '빌려줌',
        'helpful': 4,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: receivedReviews.length,
      itemBuilder: (context, index) {
        final review = receivedReviews[index];
        return _buildReviewCard(review, true);
      },
    );
  }

  Widget _buildWrittenReviews() {
    final writtenReviews = [
      {
        'reviewee': '김철수',
        'item': '드론',
        'rating': 5,
        'date': '2024.12.19',
        'comment': '설명해주신 대로 조작하기 쉬웠고, 영상 품질도 정말 좋았어요. 친절하게 사용법까지 알려주셨습니다!',
        'type': '빌림',
        'helpful': 2,
      },
      {
        'reviewee': '정민호',
        'item': '캠핑용 의자',
        'rating': 4,
        'date': '2024.12.16',
        'comment': '편안하고 가벼워서 좋았어요. 다만 약간의 사용감이 있었습니다.',
        'type': '빌림',
        'helpful': 1,
      },
      {
        'reviewee': '안소영',
        'item': '아기 유모차',
        'rating': 5,
        'date': '2024.12.10',
        'comment': '아기가 편안해했어요. 깨끗하게 관리되어 있고 모든 기능이 완벽했습니다.',
        'type': '빌림',
        'helpful': 3,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: writtenReviews.length,
      itemBuilder: (context, index) {
        final review = writtenReviews[index];
        return _buildReviewCard(review, false);
      },
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, bool isReceived) {
    final personKey = isReceived ? 'reviewer' : 'reviewee';
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                  child: Text(
                    review[personKey][0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5CF6),
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
                          Text(
                            review[personKey],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: review['type'] == '빌림' 
                                  ? const Color(0xFF3B82F6).withOpacity(0.1)
                                  : const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              review['type'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: review['type'] == '빌림' 
                                    ? const Color(0xFF3B82F6)
                                    : const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review['item'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  review['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review['rating'] ? Icons.star : Icons.star_border,
                      size: 20,
                      color: const Color(0xFFF59E0B),
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  '${review['rating']}.0',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['comment'],
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF3F4F6)),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showReportDialog(context, review),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.flag_outlined,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '신고',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '도움됨 ${review['helpful']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (isReceived)
                  GestureDetector(
                    onTap: () => _showReplyDialog(context, review),
                    child: const Text(
                      '답글 작성',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _showEditReviewDialog(context, review),
                    child: const Text(
                      '수정',
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
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context, Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰 신고'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('신고 사유를 선택해주세요:'),
            const SizedBox(height: 16),
            ...['스팸/광고', '허위 정보', '욕설/비방', '기타'].map((reason) =>
              ListTile(
                title: Text(reason),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$reason 사유로 신고가 접수되었습니다')),
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

  void _showReplyDialog(BuildContext context, Map<String, dynamic> review) {
    final TextEditingController replyController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('답글 작성'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${review['reviewer']}님의 리뷰에 답글을 작성합니다.'),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '정중하고 건설적인 답글을 작성해주세요.',
                border: OutlineInputBorder(),
              ),
            ),
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
                const SnackBar(content: Text('답글이 작성되었습니다')),
              );
            },
            child: const Text('답글 작성'),
          ),
        ],
      ),
    );
  }

  void _showEditReviewDialog(BuildContext context, Map<String, dynamic> review) {
    int rating = review['rating'];
    final TextEditingController commentController = TextEditingController(text: review['comment']);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('리뷰 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${review['item']}에 대한 리뷰를 수정합니다.'),
              const SizedBox(height: 16),
              const Text('평점'),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: const Color(0xFFF59E0B),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text('리뷰 내용'),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '솔직한 후기를 작성해주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
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
                  const SnackBar(content: Text('리뷰가 수정되었습니다')),
                );
              },
              child: const Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}