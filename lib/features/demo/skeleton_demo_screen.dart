import 'package:flutter/material.dart';
import '../../shared/widgets/skeleton/skeleton_widgets.dart';
import '../../theme/colors.dart';

/// Skeleton UI 시스템을 시연하는 데모 화면
class SkeletonDemoScreen extends StatefulWidget {
  const SkeletonDemoScreen({super.key});

  @override
  State<SkeletonDemoScreen> createState() => _SkeletonDemoScreenState();
}

class _SkeletonDemoScreenState extends State<SkeletonDemoScreen> {
  bool _showSkeletons = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeleton UI Demo'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Switch(
            value: _showSkeletons,
            onChanged: (value) {
              setState(() {
                _showSkeletons = value;
              });
            },
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: 16),
        ],
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 설명
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tealPale,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skeleton UI 데모',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '위의 스위치를 사용하여 Skeleton UI와 실제 콘텐츠를 비교해볼 수 있습니다. '
                    'Shimmer 효과가 적용된 세련된 로딩 상태를 확인하세요.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 기본 컴포넌트들
            _buildSection(
              '기본 컴포넌트',
              Column(
                children: [
                  _buildDemoCard(
                    'SkeletonBox',
                    '사각형 스켈레톤 (카드, 이미지용)',
                    _showSkeletons
                        ? const Row(
                            children: [
                              SkeletonBox(width: 100, height: 60, borderRadius: 8),
                              SizedBox(width: 12),
                              SkeletonBox(width: 80, height: 60, borderRadius: 12),
                              SizedBox(width: 12),
                              SkeletonBox(width: 120, height: 60, borderRadius: 16),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                width: 100,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text('이미지', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 80,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text('카드', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text('배너', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                  ),
                  
                  _buildDemoCard(
                    'SkeletonText',
                    '텍스트 스켈레톤 (제목, 본문용)',
                    _showSkeletons
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonText.title(width: 200),
                              SizedBox(height: 8),
                              SkeletonText.subtitle(width: 150),
                              SizedBox(height: 8),
                              SkeletonText.body(width: 300),
                              SizedBox(height: 4),
                              SkeletonText.body(width: 250),
                              SizedBox(height: 8),
                              SkeletonText.caption(width: 100),
                            ],
                          )
                        : const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skeleton UI 시스템 완성',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '현대적인 로딩 상태',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '이제 앱의 모든 로딩 상태가 세련된 Skeleton UI로 표현됩니다. Shimmer 효과가 적용되어 사용자 경험이 크게 향상되었습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '작은 텍스트 예시',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                  ),
                  
                  _buildDemoCard(
                    'SkeletonCircle',
                    '원형 스켈레톤 (아바타, 아이콘용)',
                    _showSkeletons
                        ? const Row(
                            children: [
                              SkeletonCircle.avatar(size: 60),
                              SizedBox(width: 16),
                              SkeletonCircle.avatar(size: 40),
                              SizedBox(width: 16),
                              SkeletonCircle.icon(size: 24),
                              SizedBox(width: 16),
                              SkeletonCircle.icon(size: 32),
                            ],
                          )
                        : Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.primary,
                                child: const Text('김', style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.secondary,
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.accent,
                                child: const Icon(Icons.star, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.warning,
                                child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // 복합 컴포넌트들
            _buildSection(
              '복합 컴포넌트',
              Column(
                children: [
                  _buildDemoCard(
                    'SkeletonItemCard',
                    'ItemCard용 스켈레톤',
                    SizedBox(
                      height: 280,
                      child: _showSkeletons
                          ? const SkeletonItemCard()
                          : Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.tealPale),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: AspectRatio(
                                          aspectRatio: 1.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [AppColors.primary, AppColors.secondary],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 48,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.available,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            '대여가능',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    '캐논 DSLR 카메라',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    '15,000원/일',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      const Expanded(
                                        child: Text(
                                          '잠실동',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: AppColors.warning,
                                      ),
                                      const SizedBox(width: 2),
                                      const Text(
                                        '4.8',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  
                  _buildDemoCard(
                    'SkeletonParagraph',
                    '다중 라인 텍스트 스켈레톤',
                    _showSkeletons
                        ? const SkeletonParagraph(
                            lines: 4,
                            lineHeight: 16,
                            lineSpacing: 8,
                          )
                        : const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skeleton UI 시스템이 성공적으로 구현되었습니다.',
                                style: TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '이제 모든 로딩 상태가 부드러운 Shimmer 효과와 함께 표시됩니다.',
                                style: TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '사용자 경험이 크게 향상되어 앱이 더욱 전문적으로 보입니다.',
                                style: TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Expedia 수준의 세련된 디자인을 달성했습니다.',
                                style: TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
                              ),
                            ],
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

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildDemoCard(String title, String description, Widget content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.separator),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}