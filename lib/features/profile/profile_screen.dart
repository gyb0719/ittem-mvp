import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/services/auth_service.dart';
import '../../app/routes/app_routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    // 로그인하지 않은 경우
    if (authState is! AuthStateAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('프로필'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'Ittem에 로그인하세요',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '로그인하면 더 많은 기능을 이용할 수 있어요',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('로그인'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(AppRoutes.signup),
                    child: const Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 로그인한 경우
    final user = authState.user;
    
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
                        user.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(context, '신뢰도', user.rating.toString()),
                          _buildStatItem(context, '거래횟수', user.transactionCount.toString()),
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
                      () {
                        _showLogoutDialog(context, ref);
                      },
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

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).signOut();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}