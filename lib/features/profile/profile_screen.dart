import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '김사용자',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '강남구 역삼동',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(context, '신뢰도', '4.8'),
                          _buildStatItem(context, '거래횟수', '23'),
                          _buildStatItem(context, '대여중', '3'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      Icons.shopping_bag,
                      '내 아이템',
                      '등록한 물건 관리',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.history,
                      '대여 내역',
                      '지난 거래 내역 확인',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.favorite,
                      '관심 목록',
                      '찜한 아이템 보기',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.star,
                      '리뷰 관리',
                      '받은 리뷰 및 작성한 리뷰',
                      () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      Icons.account_balance_wallet,
                      '결제 관리',
                      '결제 수단 및 내역',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.security,
                      '본인 인증',
                      '신원 인증 관리',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.location_on,
                      '위치 설정',
                      '동네 범위 설정',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.notifications,
                      '알림 설정',
                      '푸시 알림 관리',
                      () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      Icons.help,
                      '고객센터',
                      '문의 및 신고',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.info,
                      '앱 정보',
                      '버전 및 약관',
                      () {},
                    ),
                    _buildMenuItem(
                      context,
                      Icons.logout,
                      '로그아웃',
                      '',
                      () {},
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}