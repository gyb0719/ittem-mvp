import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _allNewsItems = [
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
  
  List<Map<String, dynamic>> _filteredNewsItems = [];
  
  @override
  void initState() {
    super.initState();
    _filteredNewsItems = List.from(_allNewsItems);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {
              _showMoreOptions();
            },
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
          itemCount: _filteredNewsItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = _filteredNewsItems[index];
            return _buildNewsCard(item);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWritePostDialog();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        _showNewsDetail(item);
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
                    onPressed: () {
                      _showPostOptions(item);
                    },
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
                    onPressed: () {
                      _sharePost(item);
                    },
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
      ),
    );
  }
  
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시글 검색'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '검색어를 입력하세요',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              _performSearch();
              Navigator.pop(context);
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }
  
  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredNewsItems = List.from(_allNewsItems);
      } else {
        _filteredNewsItems = _allNewsItems.where((item) {
          return item['title'].toLowerCase().contains(query) ||
                 item['content'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('새로고침'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _filteredNewsItems = List.from(_allNewsItems);
                  _searchController.clear();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('필터'),
              onTap: () {
                Navigator.pop(context);
                _showFilterOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('설정 기능을 구현 예정입니다')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('정렬 순서', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('최신순'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _filteredNewsItems.sort((a, b) => a['timeAgo'].compareTo(b['timeAgo']));
                });
              },
            ),
            ListTile(
              title: const Text('인기순'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _filteredNewsItems.sort((a, b) => b['likes'].compareTo(a['likes']));
                });
              },
            ),
            ListTile(
              title: const Text('댓글순'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _filteredNewsItems.sort((a, b) => b['comments'].compareTo(a['comments']));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showPostOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('공유하기'),
              onTap: () {
                Navigator.pop(context);
                _sharePost(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('북마크 추가'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('북마크에 추가되었습니다')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('신고하기'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(item);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _sharePost(Map<String, dynamic> item) {
    final text = '${item['title']}\n\n${item['content']}\n\n- ${item['author']}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('게시글이 클립보드에 복사되었습니다')),
    );
  }
  
  void _showReportDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('신고하기'),
        content: const Text('이 게시글을 신고하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('신고가 접수되었습니다')),
              );
            },
            child: const Text('신고'),
          ),
        ],
      ),
    );
  }
  
  void _showNewsDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['title'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
                  Text(
                    item['author'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item['location']} · ${item['timeAgo']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const Divider(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    item['content'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // 좋아요 기능
                    },
                    icon: Icon(
                      item['isLiked'] ? Icons.favorite : Icons.favorite_border,
                      color: item['isLiked'] ? Colors.red : Colors.grey,
                    ),
                  ),
                  Text('${item['likes']}'),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      // 댓글 기능
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                  ),
                  Text('${item['comments']}'),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _sharePost(item),
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showWritePostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 글 쓰기'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                setState(() {
                  _allNewsItems.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'title': titleController.text,
                    'content': contentController.text,
                    'author': '나',
                    'location': '잠실동',
                    'timeAgo': '방금 전',
                    'likes': 0,
                    'comments': 0,
                    'isLiked': false,
                  });
                  _filteredNewsItems = List.from(_allNewsItems);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('게시글이 등록되었습니다')),
                );
              }
            },
            child: const Text('등록'),
          ),
        ],
      ),
    );
  }
}