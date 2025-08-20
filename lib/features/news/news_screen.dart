import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final List<Map<String, dynamic>> _newsItems = [
    {
      'id': '1',
      'title': '잠실동 새로운 카페 오픈!',
      'content': '동네에 새로운 카페가 문을 열었어요. 분위기도 좋고 커피도 맛있답니다 ☕',
      'author': '커피러버',
      'location': '잠실동',
      'timeAgo': '2시간 전',
      'likes': 12,
      'comments': 5,
      'isLiked': false,
    },
    {
      'id': '2',
      'title': '우리 동네 산책로 추천',
      'content': '날씨 좋은 날 산책하기 좋은 코스를 소개해드릴게요. 석촌호수 둘레길이 정말 예뻐요 🌸',
      'author': '산책매니아',
      'location': '잠실동',
      'timeAgo': '4시간 전',
      'likes': 24,
      'comments': 8,
      'isLiked': true,
    },
    {
      'id': '3',
      'title': '분실물을 찾습니다',
      'content': '어제 저녁 롯데월드타워 근처에서 검은색 지갑을 잃어버렸어요. 혹시 주우신 분 계시면 연락 부탁드립니다 😭',
      'author': '잃어버린사람',
      'location': '잠실동',
      'timeAgo': '6시간 전',
      'likes': 8,
      'comments': 3,
      'isLiked': false,
    },
    {
      'id': '4',
      'title': '맛집 추천합니다!',
      'content': '석촌역 근처 파스타집 진짜 맛있어요! 가격도 합리적이고 양도 많아요 🍝',
      'author': '맛집헌터',
      'location': '잠실동',
      'timeAgo': '8시간 전',
      'likes': 31,
      'comments': 12,
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '동네소식',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 새로고침 로직
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _newsItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = _newsItems[index];
            return _buildNewsCard(item);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글 작성하기
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item) {
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작성자 정보
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    item['author'].toString().substring(0, 1),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['author'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${item['location']} · ${item['timeAgo']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 제목
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 내용
            Text(
              item['content'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 액션 버튼들
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isLiked'] = !item['isLiked'];
                      if (item['isLiked']) {
                        item['likes']++;
                      } else {
                        item['likes']--;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: item['isLiked'] 
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item['isLiked'] ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: item['isLiked'] ? AppColors.primary : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item['likes']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: item['isLiked'] ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['comments']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}