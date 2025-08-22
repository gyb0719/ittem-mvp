import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';

class VerificationScreen extends StatefulWidget {
  final String? email;
  final String? phone;
  
  const VerificationScreen({super.key, this.email, this.phone});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<String> _digits = List.filled(6, '');
  int _currentIndex = 0;
  bool _isProcessing = false;
  int _updateCounter = 0; // 강제 리빌드용

  @override
  void dispose() {
    super.dispose();
  }


  void _onKeypadPressed(String value) {
    if (_isProcessing) return;
    
    print('🔢 키패드 입력: $value');
    print('🔢 현재 인덱스: $_currentIndex');
    print('🔢 현재 digits: $_digits');
    
    setState(() {
      if (value == 'backspace') {
        // 백스페이스 처리
        if (_currentIndex > 0) {
          _currentIndex--;
          _digits[_currentIndex] = '';
        } else if (_digits[0].isNotEmpty) {
          _digits[0] = '';
        }
      } else {
        // 숫자 입력
        if (_currentIndex < 6) {
          _digits[_currentIndex] = value;
          if (_currentIndex < 5) {
            _currentIndex++;
          }
        }
      }
      _updateCounter++; // 강제 리빌드
    });
    
    HapticFeedback.lightImpact();
    
    final code = _digits.join();
    print('🔢 업데이트된 코드: $code (${code.length}/6)');
    
    // 6자리 완성되면 자동으로 다음 단계 진행
    if (code.length == 6 && !_isProcessing) {
      print('✅ 6자리 완성! 자동으로 다음 단계 진행');
      setState(() {
        _isProcessing = true;
      });
      
      // 즉시 다음 단계 진행
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          print('🚀 다음 단계로 이동 시작: $code');
          _onNext(code);
        }
      });
    }
  }

  void _onNext([String? code]) {
    final verificationCode = code ?? _digits.join();
    print('🎯 _onNext 호출: 코드 = $verificationCode, 길이 = ${verificationCode.length}, _isProcessing = $_isProcessing');
    
    if (!mounted) {
      print('❌ Widget이 unmounted 상태입니다');
      return;
    }
    
    if (verificationCode.length == 6) {
      print('✅ 인증코드 검증 성공: $verificationCode');
      
      // 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ 인증이 완료되었습니다!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      
      // 프로필 설정 화면으로 이동
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          print('🚀 프로필 설정 화면으로 이동');
          
          try {
            if (widget.email != null) {
              print('📧 이메일로 프로필 설정: ${widget.email}');
              context.go('${AppRoutes.profileSetup}?email=${widget.email}');
            } else if (widget.phone != null) {
              print('📱 전화번호로 프로필 설정: ${widget.phone}');
              context.go('${AppRoutes.profileSetup}?phone=${widget.phone}');
            } else {
              print('⚠️ 기본 프로필 설정으로 이동');
              context.go(AppRoutes.profileSetup);
            }
          } catch (e) {
            print('❌ 화면 이동 중 오류: $e');
          }
          
          setState(() {
            _isProcessing = false;
          });
        }
      });
    } else {
      print('❌ 인증코드 길이 부족: ${verificationCode.length}/6');
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('6자리 인증코드를 모두 입력해주세요'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildDigitBox(int index) {
    final digit = _digits[index];
    final hasDigit = digit.isNotEmpty;
    final isCurrent = _currentIndex == index;
    
    print('🔥 _buildDigitBox($index): digit="$digit", hasDigit=$hasDigit, isCurrent=$isCurrent');
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color: hasDigit ? const Color(0xFF4F46E5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasDigit 
              ? const Color(0xFF4F46E5) 
              : (isCurrent ? const Color(0xFF8B5CF6) : const Color(0xFFD1D5DB)),
          width: hasDigit ? 2 : (isCurrent ? 2 : 1),
        ),
        boxShadow: hasDigit ? [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Center(
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: hasDigit ? Colors.white : Colors.transparent,
          ),
        ),
      ),
    );
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
            print('뒤로가기 버튼 클릭');
            // 이메일인지 전화번호인지에 따라 적절한 화면으로 돌아가기
            if (widget.email != null) {
              context.go(AppRoutes.signup);
            } else if (widget.phone != null) {
              context.go(AppRoutes.phoneLogin);
            } else {
              context.go(AppRoutes.welcome);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            
            const SizedBox(height: 20),
            
            const Text(
              '인증코드 입력',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              widget.email != null 
                ? '이메일로 전송된 6자리 인증코드를 입력하세요\n${widget.email}'
                : 'SMS로 전송된 6자리 인증코드를 입력하세요\n${widget.phone}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 코드 입력 필드들 - 더 눈에 잘 보이게
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDigitBox(0),
                  _buildDigitBox(1),
                  _buildDigitBox(2),
                  _buildDigitBox(3),
                  _buildDigitBox(4),
                  _buildDigitBox(5),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Spacer(),
            
            // Next 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _digits.join().length == 6 ? _onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
      
      // 커스텀 키패드
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 숫자 키패드
              ...List.generate(3, (row) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
                  child: Row(
                    children: List.generate(3, (col) {
                      final number = (row * 3 + col + 1).toString();
                      final letters = _getLetters(row * 3 + col + 1);
                      
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                          child: _buildKeypadButton(
                            context,
                            number: number,
                            letters: letters,
                            onPressed: () => _onKeypadPressed(number),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
              
              // 마지막 줄 (0과 백스페이스)
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
                child: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                        child: _buildKeypadButton(
                          context,
                          number: '0',
                          letters: '',
                          onPressed: () => _onKeypadPressed('0'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                        child: _buildKeypadButton(
                          context,
                          icon: Icons.backspace_outlined,
                          onPressed: () => _onKeypadPressed('backspace'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLetters(int number) {
    switch (number) {
      case 2: return 'ABC';
      case 3: return 'DEF';
      case 4: return 'GHI';
      case 5: return 'JKL';
      case 6: return 'MNO';
      case 7: return 'PQRS';
      case 8: return 'TUV';
      case 9: return 'WXYZ';
      default: return '';
    }
  }

  Widget _buildKeypadButton(
    BuildContext context, {
    String? number,
    String? letters,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = screenWidth * 0.15; // 화면 너비의 15%
    final fontSize = screenWidth * 0.06; // 화면 너비의 6%
    final letterFontSize = screenWidth * 0.025; // 화면 너비의 2.5%
    final iconSize = screenWidth * 0.06; // 화면 너비의 6%

    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F2937),
          overlayColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
        ),
        child: icon != null
            ? Icon(icon, size: iconSize)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number!,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (letters != null && letters.isNotEmpty)
                    Text(
                      letters,
                      style: TextStyle(
                        fontSize: letterFontSize,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}