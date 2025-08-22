import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';

class SocialLoginScreen extends ConsumerStatefulWidget {
  const SocialLoginScreen({super.key});

  @override
  ConsumerState<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends ConsumerState<SocialLoginScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Luna 스타일 로고와 배경 장식
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 배경 원형 그라데이션
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.heroGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 50,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          
                          // 중앙 다이아몬드 모양
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.diamond_outlined,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          
                          // 배경 별 장식들
                          ..._buildStarDecorations(),
                        ],
                      ),
                    ),
                  ),
                  
                  // 타이틀과 설명
                  const Text(
                    'Ittem에 오신 것을 환영합니다',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  const Text(
                    '동네 이웃과 함께하는\n물건 대여 서비스',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // 소셜 로그인 버튼들
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildSocialLoginButton(
                          'Kakao로 시작하기',
                          Colors.yellow[600]!,
                          Colors.black87,
                          Icons.chat_bubble,
                          () => _handleKakaoLogin(),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildSocialLoginButton(
                          'Naver로 시작하기', 
                          const Color(0xFF03C75A),
                          Colors.white,
                          Icons.login,
                          () => _handleNaverLogin(),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildSocialLoginButton(
                          'Google로 시작하기',
                          Colors.white,
                          Colors.black87,
                          Icons.g_mobiledata,
                          () => _handleGoogleLogin(),
                          hasBorder: true,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 약관 동의
                  const Text(
                    '계속 진행하면 서비스 이용약관 및 개인정보처리방침에 동의하는 것으로 간주됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(
    String text,
    Color backgroundColor,
    Color textColor,
    IconData icon,
    VoidCallback onPressed, {
    bool hasBorder = false,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: hasBorder ? Border.all(color: AppColors.separator) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStarDecorations() {
    final stars = <Widget>[];
    final positions = [
      const Offset(-80, -120),
      const Offset(90, -100),
      const Offset(-100, -40),
      const Offset(110, 40),
      const Offset(-90, 100),
      const Offset(80, 120),
    ];
    
    for (int i = 0; i < positions.length; i++) {
      stars.add(
        Positioned(
          left: 100 + positions[i].dx,
          top: 100 + positions[i].dy,
          child: Icon(
            Icons.auto_awesome,
            size: 12 + (i % 3) * 4,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
      );
    }
    
    return stars;
  }

  void _handleKakaoLogin() async {
    // 카카오 로그인 구현
    _showComingSoonDialog('카카오 로그인');
  }

  void _handleNaverLogin() async {
    // 네이버 로그인 구현
    _showComingSoonDialog('네이버 로그인');
  }

  void _handleGoogleLogin() async {
    // 구글 로그인 구현
    _showComingSoonDialog('구글 로그인');
  }

  void _showComingSoonDialog(String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$provider 준비중'),
        content: const Text('해당 기능은 곧 제공될 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}