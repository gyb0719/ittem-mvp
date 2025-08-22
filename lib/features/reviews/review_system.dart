import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/models/review_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/auth_service.dart';
import '../../services/safety_service.dart';
import '../../shared/widgets/trust_widgets.dart';
import '../../theme/colors.dart';

class ReviewWriteScreen extends ConsumerStatefulWidget {
  final String transactionId;
  final UserModel reviewedUser;
  final String itemTitle;
  final ReviewType reviewType;

  const ReviewWriteScreen({
    super.key,
    required this.transactionId,
    required this.reviewedUser,
    required this.itemTitle,
    required this.reviewType,
  });

  @override
  ConsumerState<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends ConsumerState<ReviewWriteScreen> {
  final _contentController = TextEditingController();
  double _rating = 5.0;
  List<String> _selectedTags = [];
  List<XFile> _selectedImages = [];
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final List<String> _positiveTagsForRenter = [
    '시간 약속을 잘 지켜요',
    '친절하고 매너가 좋아요',
    '아이템을 깨끗하게 사용했어요',
    '소통이 원활해요',
    '반납을 정확히 했어요',
  ];

  final List<String> _positiveTagsForOwner = [
    '설명과 실제가 같아요',
    '아이템 상태가 좋아요',
    '친절하고 매너가 좋아요',
    '시간 약속을 잘 지켜요',
    '소통이 원활해요',
  ];

  final List<String> _negativeTagsForRenter = [
    '시간 약속을 안 지켜요',
    '소통이 어려워요',
    '아이템을 거칠게 다뤄요',
    '반납이 늦어요',
    '매너가 부족해요',
  ];

  final List<String> _negativeTagsForOwner = [
    '설명과 다른 점이 있어요',
    '아이템 상태가 아쉬워요',
    '시간 약속을 안 지켜요',
    '소통이 어려워요',
    '매너가 부족해요',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 작성'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitReview,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 24),
            _buildRatingSection(),
            const SizedBox(height: 24),
            _buildTagSelection(),
            const SizedBox(height: 24),
            _buildReviewContent(),
            const SizedBox(height: 24),
            _buildPhotoSection(),
            const SizedBox(height: 24),
            _buildOptions(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: widget.reviewedUser.profileImageUrl != null
                  ? NetworkImage(widget.reviewedUser.profileImageUrl!)
                  : null,
              child: widget.reviewedUser.profileImageUrl == null
                  ? Text(
                      widget.reviewedUser.name.substring(0, 1),
                      style: const TextStyle(fontSize: 20),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.reviewedUser.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.itemTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TrustBadgeRow(
                    user: widget.reviewedUser,
                    showLabels: true,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '거래는 어떠셨나요?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1.0),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          size: 40,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getRatingText(_rating),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagSelection() {
    final isPositive = _rating >= 4.0;
    final availableTags = widget.reviewType == ReviewType.forRenter
        ? (isPositive ? _positiveTagsForRenter : _negativeTagsForRenter)
        : (isPositive ? _positiveTagsForOwner : _negativeTagsForOwner);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPositive ? '어떤 점이 좋았나요?' : '어떤 점이 아쉬웠나요?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        if (_selectedTags.length < 3) {
                          _selectedTags.add(tag);
                        }
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor: isPositive 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  checkmarkColor: isPositive ? Colors.green : Colors.orange,
                );
              }).toList(),
            ),
            if (_selectedTags.length >= 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '최대 3개까지 선택 가능합니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '자세한 후기를 남겨주세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '거래 경험을 구체적으로 작성해주세요. '
                    '다른 사용자들에게 도움이 되는 정보를 포함해주세요.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${_contentController.text.length}/500',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '건전한 리뷰 문화를 만들어주세요',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '사진 첨부',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '선택사항',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '거래한 아이템이나 만남 장소 사진을 올려주세요',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedImages.length) {
                    return GestureDetector(
                      onTap: _addPhoto,
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.grey),
                            SizedBox(height: 4),
                            Text(
                              '사진 추가',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(_selectedImages[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('익명으로 작성'),
              subtitle: const Text('내 이름 대신 "익명"으로 표시됩니다'),
              value: _isAnonymous,
              onChanged: (value) => setState(() => _isAnonymous = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _canSubmit() ? _submitReview : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          '리뷰 등록',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    return !_isSubmitting && 
           _selectedTags.isNotEmpty && 
           _contentController.text.trim().length >= 10;
  }

  String _getRatingText(double rating) {
    if (rating >= 5.0) return '최고예요!';
    if (rating >= 4.0) return '좋아요!';
    if (rating >= 3.0) return '보통이에요';
    if (rating >= 2.0) return '별로예요';
    return '너무 안 좋아요';
  }

  Future<void> _addPhoto() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최대 3장까지 첨부 가능합니다')),
      );
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitReview() async {
    if (!_canSubmit()) return;

    setState(() => _isSubmitting = true);

    try {
      final authState = ref.read(authStateProvider);
      if (authState is! AuthStateAuthenticated) {
        throw Exception('로그인이 필요합니다');
      }

      // TODO: Upload images and get URLs
      final imageUrls = <String>[];
      
      final review = ReviewModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        transactionId: widget.transactionId,
        reviewerId: authState.user.id,
        reviewedUserId: widget.reviewedUser.id,
        itemTitle: widget.itemTitle,
        rating: _rating,
        content: _contentController.text.trim(),
        tags: _selectedTags,
        imageUrls: imageUrls,
        isAnonymous: _isAnonymous,
        reviewType: widget.reviewType,
        isVerified: _selectedImages.isNotEmpty,
        createdAt: DateTime.now(),
      );

      // TODO: Submit review to backend
      await Future.delayed(const Duration(seconds: 2)); // Mock delay

      if (mounted) {
        Navigator.of(context).pop(review);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰가 등록되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리뷰 등록 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}

class ReviewListScreen extends ConsumerStatefulWidget {
  final String userId;
  final String? itemId;

  const ReviewListScreen({
    super.key,
    required this.userId,
    this.itemId,
  });

  @override
  ConsumerState<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends ConsumerState<ReviewListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ReviewModel> _receivedReviews = [];
  List<ReviewModel> _givenReviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReviews();
  }

  void _loadReviews() {
    // Mock reviews for demonstration
    _receivedReviews = [
      ReviewModel(
        id: '1',
        transactionId: 'tx1',
        reviewerId: 'user1',
        reviewedUserId: widget.userId,
        itemTitle: '브라이언 토이 콜더브루 세트',
        rating: 5.0,
        content: '아이템도 깨끗하고 설명대로였어요. 친절하게 응대해주셔서 감사합니다!',
        tags: ['친절하고 매너가 좋아요', '아이템 상태가 좋아요', '소통이 원활해요'],
        imageUrls: [],
        isAnonymous: false,
        reviewType: ReviewType.forOwner,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        reviewerName: '김철수',
      ),
      ReviewModel(
        id: '2',
        transactionId: 'tx2',
        reviewerId: 'user2',
        reviewedUserId: widget.userId,
        itemTitle: '무늬 몬스테라',
        rating: 4.0,
        content: '대체로 만족합니다. 다음에도 이용하고 싶어요.',
        tags: ['시간 약속을 잘 지켜요', '소통이 원활해요'],
        imageUrls: [],
        isAnonymous: true,
        reviewType: ReviewType.forOwner,
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        reviewerName: null,
      ),
    ];
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: '받은 리뷰 (${_receivedReviews.length})'),
            Tab(text: '쓴 리뷰 (${_givenReviews.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReviewList(_receivedReviews),
          _buildReviewList(_givenReviews),
        ],
      ),
    );
  }

  Widget _buildReviewList(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '아직 리뷰가 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadReviews();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ReviewCard(review: reviews[index]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildRating(),
            const SizedBox(height: 8),
            _buildTags(),
            const SizedBox(height: 12),
            _buildContent(),
            if (review.imageUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildImages(),
            ],
            const SizedBox(height: 8),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          child: Text(
            review.isAnonymous 
                ? '익'
                : (review.reviewerName?.substring(0, 1) ?? 'U'),
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
                    review.isAnonymous ? '익명' : (review.reviewerName ?? 'Unknown'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (review.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ],
                ],
              ),
              Text(
                review.itemTitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          _formatDate(review.createdAt),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < review.rating ? Icons.star : Icons.star_border,
            size: 20,
            color: Colors.amber,
          );
        }),
        const SizedBox(width: 8),
        Text(
          '${review.rating}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: review.tags.map((tag) => 
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: review.rating >= 4.0 
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: review.rating >= 4.0 
                  ? Colors.green.withOpacity(0.3)
                  : Colors.orange.withOpacity(0.3),
            ),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 10,
              color: review.rating >= 4.0 ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ).toList(),
    );
  }

  Widget _buildContent() {
    return Text(
      review.content,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildImages() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: review.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(review.imageUrls[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (review.reviewType == ReviewType.forOwner)
          const Icon(Icons.person, size: 16, color: Colors.blue)
        else
          const Icon(Icons.shopping_bag, size: 16, color: Colors.green),
        const SizedBox(width: 4),
        Text(
          review.reviewType == ReviewType.forOwner ? '대여자로서' : '소유자로서',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _showReportDialog(),
          child: const Row(
            children: [
              Icon(Icons.flag, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                '신고',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금';
    }
  }

  void _showReportDialog() {
    // TODO: Implement review report functionality
  }
}

class ReviewSummaryWidget extends StatelessWidget {
  final String userId;
  final List<ReviewModel> reviews;

  const ReviewSummaryWidget({
    super.key,
    required this.userId,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            '아직 리뷰가 없습니다',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final avgRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    final ratingDistribution = _calculateRatingDistribution();
    final topTags = _getTopTags();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < avgRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    Text(
                      '${reviews.length}개 리뷰',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: ratingDistribution.entries.map((entry) {
                      final rating = entry.key;
                      final count = entry.value;
                      final percentage = count / reviews.length;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text(
                              '$rating',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$count',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '자주 언급되는 키워드',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: topTags.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${entry.key} (${entry.value})',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Map<int, int> _calculateRatingDistribution() {
    final distribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      distribution[i] = 0;
    }
    
    for (final review in reviews) {
      final rating = review.rating.round();
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }
    
    return Map.fromEntries(
      distribution.entries.toList()..sort((a, b) => b.key.compareTo(a.key))
    );
  }

  Map<String, int> _getTopTags() {
    final tagCounts = <String, int>{};
    
    for (final review in reviews) {
      for (final tag in review.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedTags.take(5));
  }
}