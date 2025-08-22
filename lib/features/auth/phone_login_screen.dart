import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  bool _isValidPhone = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    final isValid = phone.length >= 10 && phone.length <= 11;
    setState(() {
      _isValidPhone = isValid;
    });
  }

  String _formatPhoneNumber(String value) {
    // 숫자만 추출
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.isEmpty) return '';
    
    // 포맷팅 적용 (010 자동 추가 제거)
    String formatted = numbers;
    
    if (formatted.length <= 3) {
      return formatted;
    } else if (formatted.length <= 7) {
      return '${formatted.substring(0, 3)}-${formatted.substring(3)}';
    } else if (formatted.length <= 11) {
      return '${formatted.substring(0, 3)}-${formatted.substring(3, 7)}-${formatted.substring(7)}';
    } else {
      // 11자리 초과시 잘라내기
      formatted = formatted.substring(0, 11);
      return '${formatted.substring(0, 3)}-${formatted.substring(3, 7)}-${formatted.substring(7)}';
    }
  }

  Future<void> _continueWithPhone() async {
    if (_isValidPhone && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 전화번호 인증코드 발송
        await _sendPhoneVerification();
        
        if (mounted) {
          // 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📱 인증코드가 SMS로 발송되었습니다!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          
          // 인증 화면으로 이동
          await Future.delayed(const Duration(milliseconds: 1000));
          if (mounted) {
            context.go('${AppRoutes.verification}?phone=${_phoneController.text}');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ 인증코드 발송 실패: $e'),
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

  Future<void> _sendPhoneVerification() async {
    // API 호출 시뮬레이션 (실제로는 SMS 서비스 호출)
    await Future<void>.delayed(const Duration(seconds: 2));
    
    // 실제 구현 예시:
    // await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: _phoneController.text);
    // 또는 Twilio, AWS SNS 등의 SMS 서비스 사용
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
              '전화번호 입력',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              '전화번호를 입력하시면 인증코드를 발송해드립니다.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // 전화번호 입력 필드
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              onChanged: (value) {
                final formatted = _formatPhoneNumber(value);
                if (formatted != _phoneController.text) {
                  _phoneController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
                _validatePhone();
              },
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
              decoration: InputDecoration(
                hintText: '010-1234-5678',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '+82',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
            
            const Spacer(),
            
            // Continue 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_isValidPhone && !_isLoading) ? _continueWithPhone : null,
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
                        '인증코드 받기',
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