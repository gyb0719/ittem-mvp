import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/item_card.dart';
import '../../shared/models/item_model.dart';
import '../../app/routes/app_routes.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = '전체';
  String _sortBy = '거리순';

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
      appBar: AppBar(
        title: const Text('대여 목록'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '내 대여'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showCategoryFilter,
                    icon: const Icon(Icons.filter_list),
                    label: Text(_selectedCategory),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showSortOptions,
                    icon: const Icon(Icons.sort),
                    label: Text(_sortBy),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItemGrid(),
                _buildMyRentals(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.addItem),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _dummyItems.length,
        itemBuilder: (context, index) {
          return ItemCard(item: _dummyItems[index]);
        },
      ),
    );
  }

  Widget _buildMyRentals() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        final item = _dummyItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.price.toString()}원/일',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '대여중',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final categories = ['전체', '카메라', '스포츠', '도구', '주방용품', '완구', '악기'];
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '카테고리 선택',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final sortOptions = ['거리순', '가격 낮은순', '가격 높은순', '평점순', '최신순'];
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '정렬 기준',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...sortOptions.map((option) {
                final isSelected = option == _sortBy;
                return ListTile(
                  title: Text(option),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _sortBy = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

final List<ItemModel> _dummyItems = [
  ItemModel(
    id: '1',
    title: '캐논 DSLR 카메라',
    description: '여행용으로 완벽한 DSLR 카메라입니다. 렌즈 포함',
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
  ItemModel(
    id: '5',
    title: '어쿠스틱 기타',
    description: '초보자도 쉽게 배울 수 있는 어쿠스틱 기타',
    price: 18000,
    imageUrl: '',
    category: '악기',
    location: '강남구 신사동',
    rating: 4.5,
    reviewCount: 18,
  ),
  ItemModel(
    id: '6',
    title: '레고 테크닉 세트',
    description: '아이들이 좋아하는 레고 테크닉 큰 세트',
    price: 10000,
    imageUrl: '',
    category: '완구',
    location: '강남구 압구정동',
    rating: 4.9,
    reviewCount: 27,
  ),
];