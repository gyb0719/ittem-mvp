import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';

// 커뮤니티 포스트 모델
class CommunityPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String location;
  final String time;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final List<String> tags;

  CommunityPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.location,
    required this.time,
    this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.tags,
  });
}

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = '전체';
  
  // 커뮤니티 포스트 데이터
  final List<CommunityPost> _allPosts = [
    CommunityPost(
      id: '1',
      title: '잠실동 카페 추천해주세요!',
      content: '새로 이사온 동네 주민입니다. 분위기 좋은 카페 아시는 분 계신가요? 원두도 맛있고 조용한 곳으로요 🍰',
      author: '신규주민',
      location: '잠실동',
      time: '10분 전',
      likeCount: 8,
      commentCount: 12,
      isLiked: false,
      tags: ['카페', '추천'],
    ),
    CommunityPost(
      id: '2',
      title: '우리 동네 벚꽃이 정말 예뻐요 🌸',
      content: '석촌호수 벚꽃이 활짝 폈네요! 주말에 가족과 산책하기 좋을 것 같아요. 사진 찍으러 오세요~',
      author: '벚꽃사랑',
      location: '잠실동',
      time: '1시간 전',
      imageUrl: 'https://via.placeholder.com/300x200/FFB6C1/FFFFFF?text=벚꽃',
      likeCount: 24,
      commentCount: 6,
      isLiked: true,
      tags: ['벚꽃', '산책'],
    ),
    CommunityPost(
      id: '3',
      title: '잠실역 근처 주차장 정보',
      content: '매번 주차하기 어려워서 고민이었는데, 지하 공영주차장이 생각보다 저렴하더라구요. 시간당 500원이에요!',
      author: '드라이버',
      location: '잠실역',
      time: '2시간 전',
      likeCount: 15,
      commentCount: 8,
      isLiked: false,
      tags: ['주차', '정보'],
    ),
    CommunityPost(
      id: '4',
      title: '아이와 함께 갈 만한 놀이터 추천',
      content: '5살 아이가 있는데, 안전하고 재미있는 놀이터 추천해주세요. 요즘 미세먼지도 걱정이고...',
      author: '육아맘',
      location: '잠실동',
      time: '3시간 전',
      likeCount: 11,
      commentCount: 14,
      isLiked: false,
      tags: ['육아', '놀이터'],
    ),
    CommunityPost(
      id: '5',
      title: '동네 맛집 발견! 🍜',
      content: '새로 생긴 라면집 진짜 맛있어요! 사장님도 친절하시고 가격도 착해요. 강추합니다!',
      author: '맛집탐험가',
      location: '잠실동',
      time: '5시간 전',
      imageUrl: 'https://via.placeholder.com/300x200/FF6347/FFFFFF?text=라면',
      likeCount: 32,
      commentCount: 18,
      isLiked: true,
      tags: ['맛집', '라면'],
    ),
  ];

  final List<String> _filterOptions = ['전체', '맛집', '정보', '추천', '질문', '일상'];

  List<CommunityPost> get _filteredPosts {
    var posts = _allPosts;
    
    // 검색 필터
    if (_searchController.text.isNotEmpty) {
      posts = posts.where((post) =>
        post.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        post.content.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        post.tags.any((tag) => tag.toLowerCase().contains(_searchController.text.toLowerCase()))
      ).toList();
    }
    
    // 카테고리 필터
    if (_selectedFilter != '전체') {
      posts = posts.where((post) => 
        post.tags.any((tag) => tag.contains(_selectedFilter))
      ).toList();
    }
    
    return posts;
  }

  void _toggleLike(String postId) {
    setState(() {
      final index = _allPosts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _allPosts[index];
        _allPosts[index] = CommunityPost(
          id: post.id,
          title: post.title,
          content: post.content,
          author: post.author,
          location: post.location,
          time: post.time,
          imageUrl: post.imageUrl,
          likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
          commentCount: post.commentCount,
          isLiked: !post.isLiked,
          tags: post.tags,
        );
      }
    });
    
    // 햅틱 피드백
    HapticFeedback.lightImpact();
  }

  void _showComments(CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCommentsSheet(post),
    );
  }

  void _createNewPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCreatePostSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '동네 소식',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Color(0xFF1F2937)),
            onPressed: _createNewPost,
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색창과 필터
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 검색창
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: '궁금한 것을 검색해보세요',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 필터 태그들
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = _filterOptions[index];
                      final isSelected = _selectedFilter == filter;
                      
                      return Container(
                        margin: EdgeInsets.only(
                          right: index < _filterOptions.length - 1 ? 8 : 0,
                        ),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: const Color(0xFF8B5CF6),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF6B7280),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // 포스트 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredPosts.length,
              itemBuilder: (context, index) {
                final post = _filteredPosts[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index < _filteredPosts.length - 1 ? 12 : 0,
                  ),
                  child: _buildPostCard(post),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 포스트 카드 위젯
  Widget _buildPostCard(CommunityPost post) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 작성자 정보
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF8B5CF6),
                child: Text(
                  post.author[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${post.location} · ${post.time}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: Colors.grey[400],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 포스트 내용
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          
          // 이미지가 있는 경우
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          ],
          
          // 태그들
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: post.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // 좋아요 및 댓글 버튼
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(post.id),
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likeCount}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              GestureDetector(
                onTap: () => _showComments(post),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.commentCount}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              Icon(
                Icons.share,
                color: Colors.grey[600],
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 댓글 바텀시트
  Widget _buildCommentsSheet(CommunityPost post) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들바
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '댓글',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // 댓글 목록 (임시 데이터)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue[300],
                        child: const Text('댓', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '댓글작성자${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '좋은 정보 감사합니다! 저도 한번 가봐야겠어요.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${index + 5}분 전',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // 댓글 입력창
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // 댓글 작성 로직
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('댓글이 작성되었습니다')),
                    );
                  },
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 새 포스트 작성 바텀시트
  Widget _buildCreatePostSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들바
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                const Spacer(),
                const Text(
                  '새 글 작성',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('글이 작성되었습니다')),
                    );
                  },
                  child: const Text('완료'),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // 작성 폼
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '제목을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: '우리 동네 이야기를 들려주세요...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.image),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}