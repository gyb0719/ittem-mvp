import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/models/user_model.dart';
import '../../app/routes/app_routes.dart';
import '../../shared/widgets/simple_button.dart';
import 'settings_screen.dart';
import 'my_items_screen.dart';
import 'rental_history_screen.dart';
import 'favorites_screen.dart';
import 'reviews_screen.dart';
import 'payment_screen.dart';
import 'help_center_screen.dart';

class ProfileSimpleScreen extends ConsumerStatefulWidget {
  const ProfileSimpleScreen({super.key});

  @override
  ConsumerState<ProfileSimpleScreen> createState() => _ProfileSimpleScreenState();
}

class _ProfileSimpleScreenState extends ConsumerState<ProfileSimpleScreen> {
  bool _isLoading = true;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      final authState = ref.read(authStateProvider);
      
      setState(() {
        _user = authState is AuthStateAuthenticated 
            ? authState.user 
            : UserModel(
                id: 'default-user',
                name: '김사용자',
                email: 'user@example.com',
                phoneNumber: '010-1234-5678',
                location: '강남구 역삼동',
                rating: 4.8,
                transactionCount: 12,
                isVerified: true,
                createdAt: DateTime.now().subtract(const Duration(days: 30)),
                lastLoginAt: DateTime.now(),
              );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('프로필'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF5CBDBD),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5CBDBD), Color(0xFF48A3A3)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _user!.name.isNotEmpty ? _user!.name[0] : 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _user!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _user!.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Stats
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('신뢰도', '${_user!.rating}'),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _buildStatItem('거래', '${_user!.transactionCount}회'),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _buildStatItem('대여중', '3개'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Quick actions
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '빠른 실행',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        '내 아이템',
                        '등록한 물건 관리',
                        Icons.inventory_2_outlined,
                        const Color(0xFF8B5CF6),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyItemsScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        '대여 내역',
                        '지난 거래 확인',
                        Icons.history,
                        const Color(0xFF3B82F6),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RentalHistoryScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Menu items
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildMenuItem(
                  Icons.favorite_outline,
                  '관심 목록',
                  '찜한 아이템',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                  ),
                ),
                _buildMenuItem(
                  Icons.star_outline,
                  '리뷰 관리',
                  '받은 리뷰와 작성한 리뷰',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReviewsScreen()),
                  ),
                ),
                _buildMenuItem(
                  Icons.payment_outlined,
                  '결제 관리',
                  '결제 수단 및 내역',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentScreen()),
                  ),
                ),
                _buildMenuItem(
                  Icons.help_outline,
                  '고객센터',
                  '문의하기 및 도움말',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                  ),
                ),
                _buildMenuItem(
                  Icons.animation_outlined,
                  'Korean Animations Demo',
                  '한국 모바일 UX 애니메이션 데모',
                  () => context.push(AppRoutes.animationsDemo),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5CBDBD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Account section
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildMenuItem(
                  Icons.verified_user_outlined,
                  '본인 인증',
                  '인증 완료',
                  () => _showVerificationInfo(),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildMenuItem(
                  Icons.logout,
                  '로그아웃',
                  '',
                  () => _showLogoutDialog(),
                  textColor: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? const Color(0xFF5CBDBD)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: textColor ?? const Color(0xFF5CBDBD),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: subtitle.isNotEmpty 
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ) 
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showVerificationInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('본인 인증'),
        content: const Text(
          '✅ 본인 인증이 완료되었습니다.\n\n'
          '• 신분증 인증: 완료\n'
          '• 휴대폰 인증: 완료\n'
          '• 계좌 인증: 완료\n\n'
          '인증 완료일: 2024년 11월 20일'
        ),
        actions: [
          SimpleButton.primary(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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
          SimpleButton.primary(
            onPressed: () {
              ref.read(authStateProvider.notifier).signOut();
              Navigator.pop(context);
              context.go(AppRoutes.welcome);
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}