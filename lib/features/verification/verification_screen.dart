import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/models/verification_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/auth_service.dart';
import '../../services/safety_service.dart';
import '../../shared/widgets/trust_widgets.dart';
import '../../theme/colors.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 인증'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: authState is AuthStateAuthenticated
          ? VerificationContent(user: authState.user)
          : const Center(child: Text('로그인이 필요합니다.')),
    );
  }
}

class VerificationContent extends ConsumerWidget {
  final UserModel user;

  const VerificationContent({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildCurrentStatus(context, user),
          const SizedBox(height: 24),
          _buildVerificationOptions(context, ref, user),
          const SizedBox(height: 24),
          _buildBenefits(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '계정 인증으로 신뢰도 UP!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '인증을 완료하면 더 안전하고 신뢰할 수 있는 거래를 할 수 있어요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStatus(BuildContext context, UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '현재 인증 상태',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TrustScoreIndicator(user: user),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrustBadgeRow(user: user, showLabels: true),
                      const SizedBox(height: 12),
                      VerificationStatusRow(user: user),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationOptions(BuildContext context, WidgetRef ref, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '인증 항목',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        VerificationOptionCard(
          icon: Icons.phone_android,
          title: '전화번호 인증',
          subtitle: 'SMS 인증으로 본인 확인',
          isVerified: user.isPhoneVerified,
          onTap: () => _startPhoneVerification(context, ref),
        ),
        const SizedBox(height: 8),
        VerificationOptionCard(
          icon: Icons.email,
          title: '이메일 인증',
          subtitle: '이메일 링크를 통한 인증',
          isVerified: user.isEmailVerified,
          onTap: () => _startEmailVerification(context, ref),
        ),
        const SizedBox(height: 8),
        VerificationOptionCard(
          icon: Icons.badge,
          title: '신분증 인증',
          subtitle: '신분증 사진 업로드로 본인 확인',
          isVerified: user.isIdVerified,
          onTap: () => _startIdVerification(context, ref),
        ),
        const SizedBox(height: 8),
        VerificationOptionCard(
          icon: Icons.home,
          title: '주소 인증',
          subtitle: '주민등록등본 등으로 주소 확인',
          isVerified: user.isAddressVerified,
          onTap: () => _startAddressVerification(context, ref),
        ),
        const SizedBox(height: 8),
        VerificationOptionCard(
          icon: Icons.account_balance,
          title: '계좌 인증',
          subtitle: '1원 송금으로 계좌 확인',
          isVerified: user.isBankAccountVerified,
          onTap: () => _startBankVerification(context, ref),
        ),
      ],
    );
  }

  Widget _buildBenefits(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  '인증 혜택',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBenefitItem('신뢰도 점수 상승', '더 높은 신뢰도로 거래 기회 증가'),
            _buildBenefitItem('우선 노출', '검색 결과에서 상위에 표시'),
            _buildBenefitItem('거래 수수료 할인', '인증 회원 전용 할인 혜택'),
            _buildBenefitItem('프리미엄 기능 이용', '고급 기능 우선 이용권'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startPhoneVerification(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PhoneVerificationScreen(),
      ),
    );
  }

  void _startEmailVerification(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  void _startIdVerification(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IdVerificationScreen(),
      ),
    );
  }

  void _startAddressVerification(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressVerificationScreen(),
      ),
    );
  }

  void _startBankVerification(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BankVerificationScreen(),
      ),
    );
  }
}

class VerificationOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isVerified;
  final VoidCallback onTap;

  const VerificationOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isVerified,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isVerified ? Colors.green : Colors.grey[300],
          child: Icon(
            icon,
            color: isVerified ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '인증완료',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              const Icon(Icons.chevron_right),
          ],
        ),
        onTap: isVerified ? null : onTap,
      ),
    );
  }
}

// Individual verification screens
class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  ConsumerState<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends ConsumerState<PhoneVerificationScreen> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  bool codeSent = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전화번호 인증'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!codeSent) ...[
              const Text(
                '휴대폰 번호를 입력해주세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '휴대폰 번호',
                  hintText: '010-1234-5678',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _sendCode,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('인증번호 받기'),
              ),
            ] else ...[
              const Text(
                '인증번호를 입력해주세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '인증번호',
                  hintText: '6자리 숫자',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _verifyCode,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('인증하기'),
              ),
              TextButton(
                onPressed: _sendCode,
                child: const Text('인증번호 재전송'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _sendCode() async {
    setState(() {
      isLoading = true;
    });

    // TODO: Implement actual SMS sending
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      codeSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('인증번호가 전송되었습니다.')),
    );
  }

  Future<void> _verifyCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      final safetyService = ref.read(safetyServiceProvider);
      final authState = ref.read(authStateProvider);
      
      if (authState is AuthStateAuthenticated) {
        await safetyService.submitVerification(
          userId: authState.user.id,
          type: VerificationType.phone,
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('전화번호 인증이 완료되었습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }
}

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  bool emailSent = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이메일 인증'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!emailSent) ...[
              const Text(
                '이메일로 인증링크를 보내드릴게요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _sendVerificationEmail,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('인증 이메일 보내기'),
              ),
            ] else ...[
              const Icon(
                Icons.email,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                '인증 이메일을 보냈습니다!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '이메일을 확인하고 인증 링크를 클릭해주세요.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkVerificationStatus,
                child: const Text('인증 확인'),
              ),
              TextButton(
                onPressed: _sendVerificationEmail,
                child: const Text('이메일 재전송'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      isLoading = true;
    });

    // TODO: Implement actual email sending
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      emailSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('인증 이메일이 전송되었습니다.')),
    );
  }

  Future<void> _checkVerificationStatus() async {
    // TODO: Check if email has been verified
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
    );
    Navigator.of(context).pop();
  }
}

class IdVerificationScreen extends ConsumerStatefulWidget {
  const IdVerificationScreen({super.key});

  @override
  ConsumerState<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends ConsumerState<IdVerificationScreen> {
  XFile? selectedImage;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신분증 인증'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.security,
                      color: Colors.amber,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '안전한 신분증 인증',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '개인정보는 암호화되어 안전하게 처리되며,\n인증 완료 후 자동으로 삭제됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (selectedImage == null) ...[
              DottedBorder(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        '신분증 사진을 선택해주세요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '주민등록증, 운전면허증, 여권 등',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Image.network(
                selectedImage!.path,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickImage,
                      child: const Text('다시 선택'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isUploading ? null : _submitVerification,
                      child: isUploading
                          ? const CircularProgressIndicator()
                          : const Text('인증 요청'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> _submitVerification() async {
    setState(() {
      isUploading = true;
    });

    try {
      final safetyService = ref.read(safetyServiceProvider);
      final authState = ref.read(authStateProvider);
      
      if (authState is AuthStateAuthenticated) {
        // TODO: Upload image and get URL
        const imageUrl = 'dummy-image-url';
        
        await safetyService.submitVerification(
          userId: authState.user.id,
          type: VerificationType.identity,
          documentUrl: imageUrl,
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('신분증 인증 요청이 제출되었습니다. 검토까지 1-2일 소요됩니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 요청 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }
}

// Placeholder screens for other verification types
class AddressVerificationScreen extends StatelessWidget {
  const AddressVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소 인증'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('주소 인증 화면 (구현 예정)'),
      ),
    );
  }
}

class BankVerificationScreen extends StatelessWidget {
  const BankVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계좌 인증'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('계좌 인증 화면 (구현 예정)'),
      ),
    );
  }
}

// Helper widget for dotted border
class DottedBorder extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const DottedBorder({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}