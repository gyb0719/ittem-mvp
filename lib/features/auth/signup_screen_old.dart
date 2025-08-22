import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/services/auth_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _residentNumberController = TextEditingController();
  final _locationController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  bool _phoneVerified = false;
  int _currentPage = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _residentNumberController.dispose();
    _locationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next is AuthStateAuthenticated) {
        context.go('/');
      } else if (next is AuthStateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 ${_currentPage + 1}/3'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // 진행률 표시
            LinearProgressIndicator(
              value: (_currentPage + 1) / 3,
              backgroundColor: Colors.grey[200],
            ),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildAccountInfoStep(),
                  _buildPersonalInfoStep(),
                  _buildTermsStep(),
                ],
              ),
            ),
            
            // 하단 버튼
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('이전'),
                      ),
                    ),
                  
                  if (_currentPage > 0) const SizedBox(width: 16),
                  
                  Expanded(
                    flex: _currentPage == 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: authState is AuthStateLoading ? null : _handleNext,
                      child: authState is AuthStateLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_currentPage == 2 ? '회원가입 완료' : '다음'),
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

  Widget _buildAccountInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정 정보를 입력해주세요',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Ittem에서 사용할 이메일과 비밀번호를 설정해주세요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: '이메일',
              hintText: 'example@email.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력해주세요';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return '올바른 이메일 형식을 입력해주세요';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: '비밀번호',
              hintText: '8자 이상, 영문+숫자 조합',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword 
                      ? Icons.visibility_outlined 
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              if (value.length < 8) {
                return '비밀번호는 8자 이상이어야 합니다';
              }
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                return '영문과 숫자를 포함해야 합니다';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('또는 소셜 아이디로 시작하기', style: TextStyle(color: Colors.grey)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 소셜 로그인 버튼들
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  '카카오',
                  Colors.yellow[700]!,
                  Colors.black,
                  () => _socialSignUp('카카오'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSocialButton(
                  'Google',
                  Colors.white,
                  Colors.black,
                  () => _socialSignUp('Google'),
                  showBorder: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSocialButton(
                  'Apple',
                  Colors.black,
                  Colors.white,
                  () => _socialSignUp('Apple'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: '비밀번호 확인',
              hintText: '비밀번호를 다시 입력해주세요',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword 
                      ? Icons.visibility_outlined 
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호 확인을 입력해주세요';
              }
              if (value != _passwordController.text) {
                return '비밀번호가 일치하지 않습니다';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '개인 정보를 입력해주세요',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '서비스 이용을 위한 기본 정보를 입력해주세요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '이름',
              hintText: '실명을 입력해주세요',
              prefixIcon: Icon(Icons.person_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력해주세요';
              }
              if (value.length < 2) {
                return '이름은 2자 이상이어야 합니다';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _residentNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '주민등록번호',
              hintText: '123456-1234567',
              prefixIcon: Icon(Icons.credit_card_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '주민등록번호를 입력해주세요';
              }
              if (!RegExp(r'^\d{6}-\d{7}$').hasMatch(value)) {
                return '올바른 주민등록번호 형식을 입력해주세요 (123456-1234567)';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '휴대폰 번호',
                    hintText: '010-1234-5678',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '휴대폰 번호를 입력해주세요';
                    }
                    if (!RegExp(r'^010-\d{4}-\d{4}$').hasMatch(value)) {
                      return '올바른 휴대폰 번호 형식을 입력해주세요';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _phoneController.text.isNotEmpty && !_phoneVerified
                    ? _sendPhoneVerification
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _phoneVerified ? Colors.green : null,
                ),
                child: Text(_phoneVerified ? '인증완료' : '인증'),
              ),
            ],
          ),
          
          if (!_phoneVerified && _phoneController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: '인증번호',
                        hintText: '6자리 숫자',
                        prefixIcon: Icon(Icons.security_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _verifyPhone,
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: '거주 지역',
              hintText: '예: 강남구 역삼동',
              prefixIcon: Icon(Icons.location_on_outlined),
              suffixIcon: Icon(Icons.search),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '거주 지역을 입력해주세요';
              }
              return null;
            },
            onTap: () {
              _showLocationPicker();
            },
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '약관에 동의해주세요',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Ittem 서비스 이용을 위한 약관에 동의해주세요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          CheckboxListTile(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            title: const Text('서비스 이용약관 동의'),
            subtitle: const Text('(필수)'),
            secondary: IconButton(
              icon: const Icon(Icons.article_outlined),
              onPressed: () {
                _showTermsDialog('서비스 이용약관');
              },
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          CheckboxListTile(
            value: _agreeToPrivacy,
            onChanged: (value) {
              setState(() {
                _agreeToPrivacy = value ?? false;
              });
            },
            title: const Text('개인정보 처리방침 동의'),
            subtitle: const Text('(필수)'),
            secondary: IconButton(
              icon: const Icon(Icons.privacy_tip_outlined),
              onPressed: () {
                _showTermsDialog('개인정보 처리방침');
              },
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '회원가입과 동시에 Ittem의 일반회원이 되며, 언제든지 탈퇴할 수 있습니다.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_currentPage == 0) {
      if (_validateStep1()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentPage == 1) {
      if (_validateStep2()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentPage == 2) {
      if (_validateStep3()) {
        _signUp();
      }
    }
  }

  bool _validateStep1() {
    return _emailController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty &&
           _confirmPasswordController.text.isNotEmpty &&
           _passwordController.text == _confirmPasswordController.text;
  }

  bool _validateStep2() {
    return _nameController.text.isNotEmpty && 
           _residentNumberController.text.isNotEmpty &&
           _phoneController.text.isNotEmpty &&
           _phoneVerified &&
           _locationController.text.isNotEmpty;
  }

  bool _validateStep3() {
    return _agreeToTerms && _agreeToPrivacy;
  }

  void _signUp() {
    if (_formKey.currentState!.validate() && _validateStep3()) {
      ref.read(authStateProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        residentNumber: _residentNumberController.text.trim(),
        location: _locationController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
    } else if (!_validateStep3()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('필수 약관에 동의해주세요'),
        ),
      );
    }
  }

  void _showLocationPicker() {
    final locations = [
      '강남구 역삼동',
      '강남구 논현동',
      '강남구 삼성동',
      '강남구 청담동',
      '서초구 서초동',
      '서초구 반포동',
      '송파구 잠실동',
      '송파구 석촌동',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '거주 지역 선택',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...locations.map((location) {
                return ListTile(
                  title: Text(location),
                  onTap: () {
                    _locationController.text = location;
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

  void _sendPhoneVerification() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('휴대폰 번호를 입력해주세요')),
      );
      return;
    }
    
    // 실제로는 SMS API를 통해 인증번호를 발송
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_phoneController.text}로 인증번호를 발송했습니다'),
        backgroundColor: Colors.green,
      ),
    );
    
    setState(() {
      // 인증번호 입력 필드 표시
    });
  }
  
  void _verifyPhone() {
    // 실제로는 서버에서 인증번호를 확인
    // 여기서는 임시로 인증 완료 처리
    setState(() {
      _phoneVerified = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('휴대폰 인증이 완료되었습니다'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTermsDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            title == '서비스 이용약관' 
                ? '서비스 이용약관 내용...\n\n(실제 서비스에서는 상세한 약관 내용이 표시됩니다)'
                : '개인정보 처리방침 내용...\n\n(실제 서비스에서는 상세한 개인정보 처리방침이 표시됩니다)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton(
    String provider,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed, {
    bool showBorder = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: showBorder ? const BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      child: Text(
        provider,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
  
  void _socialSignUp(String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$provider 회원가입'),
        content: Text('$provider 계정으로 간편하게 회원가입하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$provider 로그인 기능을 구현 예정입니다'),
                ),
              );
            },
            child: const Text('회원가입'),
          ),
        ],
      ),
    );
  }
}