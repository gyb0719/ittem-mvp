import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  bool _isValidEmail = false;
  bool _isLoading = false;
  bool _showDomainSuggestions = false;
  
  final List<String> _popularDomains = [
    'naver.com',
    'gmail.com',
    'daum.net',
    'hanmail.net',
    'kakao.com',
    'nate.com',
    'yahoo.co.kr',
    'hotmail.com',
    'outlook.com',
  ];

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    
    // @ 입력 시 도메인 제안 표시
    final shouldShowSuggestions = email.contains('@') && !email.contains('.') && email.split('@').length == 2;
    
    setState(() {
      _isValidEmail = isValid;
      _showDomainSuggestions = shouldShowSuggestions;
    });
  }

  void _selectDomain(String domain) {
    final currentText = _emailController.text;
    if (currentText.contains('@')) {
      final parts = currentText.split('@');
      final newEmail = '${parts[0]}@$domain';
      _emailController.text = newEmail;
      _validateEmail();
      setState(() {
        _showDomainSuggestions = false;
      });
    }
  }

  Future<void> _continueWithEmail() async {
    if (_isValidEmail && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 이메일 인증코드 발송
        await _sendEmailVerification();
        
        if (mounted) {
          // 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📧 인증코드가 이메일로 발송되었습니다!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          
          // 인증 화면으로 이동
          await Future.delayed(const Duration(milliseconds: 1000));
          if (mounted) {
            context.go('${AppRoutes.verification}?email=${_emailController.text}');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ 이메일 발송 실패: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _sendEmailVerification() async {
    // API 호출 시뮬레이션 (실제로는 이메일 서비스 호출)
    await Future<void>.delayed(const Duration(seconds: 2));
    
    // 실제 구현 예시:
    // await EmailService.sendVerificationCode(_emailController.text);
    // 또는 SendGrid, AWS SES 등의 이메일 서비스 사용
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
          onPressed: () {
            context.go(AppRoutes.welcome);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            
            const Text(
              '계정 만들기',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              '이메일 주소를 입력해서 시작하세요.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // 이메일 입력 필드
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => _validateEmail(),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
              decoration: InputDecoration(
                hintText: '이메일을 입력하세요',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            
            // 도메인 제안 목록
            if (_showDomainSuggestions) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '인기 도메인 선택',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: _popularDomains.length,
                        itemBuilder: (context, index) {
                          final domain = _popularDomains[index];
                          return ListTile(
                            title: Text(
                              '@$domain',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            onTap: () => _selectDomain(domain),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const Spacer(),
            
            // Continue 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_isValidEmail && !_isLoading) ? _continueWithEmail : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        '계속하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 약관 동의
            const Center(
              child: Text(
                '계속 진행하면 이용약관 및 개인정보처리방침에 동의하는 것으로 간주됩니다',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}