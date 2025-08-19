import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';
import '../../shared/widgets/item_card.dart';
import '../../shared/models/item_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            const Text(
              '강남구 역삼동',
              style: TextStyle(fontSize: 16),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.go(AppRoutes.map),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '어떤 물건을 찾고 계신가요?',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '카테고리',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('전체보기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryItem(context, Icons.camera_alt, '카메라'),
                        _buildCategoryItem(context, Icons.sports_basketball, '스포츠'),
                        _buildCategoryItem(context, Icons.home_repair_service, '도구'),
                        _buildCategoryItem(context, Icons.kitchen, '주방용품'),
                        _buildCategoryItem(context, Icons.toys, '완구'),
                        _buildCategoryItem(context, Icons.music_note, '악기'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '내 주변 인기 아이템',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.items),
                        child: const Text('더보기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _dummyItems[index % _dummyItems.length];
                  return ItemCard(item: item);
                },
                childCount: 6,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, IconData icon, String label) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

final List<ItemModel> _dummyItems = [
  ItemModel(
    id: '1',
    title: '캐논 DSLR 카메라',
    description: '여행용으로 완벽한 DSLR 카메라',
    price: 15000,
    imageUrl: '',
    category: '카메라',
    location: '강남구 역삼동',
    rating: 4.8,
    reviewCount: 23,
  ),
  ItemModel(
    id: '2',
    title: '캠핑 텐트 (4인용)',
    description: '가족 캠핑에 완벽한 대형 텐트',
    price: 25000,
    imageUrl: '',
    category: '스포츠',
    location: '강남구 논현동',
    rating: 4.9,
    reviewCount: 45,
  ),
  ItemModel(
    id: '3',
    title: '전동 드릴',
    description: '가정용 DIY에 최적화된 전동 드릴',
    price: 8000,
    imageUrl: '',
    category: '도구',
    location: '강남구 삼성동',
    rating: 4.7,
    reviewCount: 12,
  ),
  ItemModel(
    id: '4',
    title: '에어프라이어',
    description: '건강한 요리를 위한 대용량 에어프라이어',
    price: 12000,
    imageUrl: '',
    category: '주방용품',
    location: '강남구 청담동',
    rating: 4.6,
    reviewCount: 34,
  ),
];