import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/auth_service.dart';
import '../../services/safety_service.dart';
import '../../shared/widgets/trust_widgets.dart';
import '../../theme/colors.dart';

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    if (authState is! AuthStateAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('개인정보 설정'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('로그인이 필요합니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 보호'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showPrivacyHelp(context),
          ),
        ],
      ),
      body: PrivacySettingsContent(user: authState.user),
    );
  }

  void _showPrivacyHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PrivacyHelpDialog(),
    );
  }
}

class PrivacySettingsContent extends ConsumerStatefulWidget {
  final UserModel user;

  const PrivacySettingsContent({super.key, required this.user});

  @override
  ConsumerState<PrivacySettingsContent> createState() => _PrivacySettingsContentState();
}

class _PrivacySettingsContentState extends ConsumerState<PrivacySettingsContent> {
  late bool _allowDirectContact;
  late bool _showExactLocation;
  late bool _allowRatingDisplay;
  late bool _showOnlineStatus;
  late bool _allowProfileViewing;
  late bool _showTransactionHistory;

  @override
  void initState() {
    super.initState();
    _allowDirectContact = widget.user.allowDirectContact;
    _showExactLocation = widget.user.showExactLocation;
    _allowRatingDisplay = widget.user.allowRatingDisplay;
    _showOnlineStatus = true; // TODO: Add to user model
    _allowProfileViewing = true; // TODO: Add to user model
    _showTransactionHistory = false; // TODO: Add to user model
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrivacyOverview(),
          const SizedBox(height: 24),
          _buildVisibilitySettings(),
          const SizedBox(height: 24),
          _buildContactSettings(),
          const SizedBox(height: 24),
          _buildLocationSettings(),
          const SizedBox(height: 24),
          _buildDataSettings(),
          const SizedBox(height: 24),
          _buildBlockedUsers(),
          const SizedBox(height: 24),
          _buildPrivacyActions(),
        ],
      ),
    );
  }

  Widget _buildPrivacyOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.privacy_tip,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '개인정보 보호 현황',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPrivacyScore(),
            const SizedBox(height: 12),
            Text(
              '안전한 거래를 위해 개인정보 공개 수준을 조절하세요.',
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

  Widget _buildPrivacyScore() {
    final score = _calculatePrivacyScore();
    final color = _getPrivacyScoreColor(score);
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '프라이버시 점수',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '$score/100',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getPrivacyLevel(score),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 6,
              ),
              Icon(
                Icons.security,
                color: color,
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilitySettings() {
    return _buildSettingSection(
      '공개 범위 설정',
      Icons.visibility,
      [
        _buildSwitchTile(
          '온라인 상태 표시',
          '다른 사용자에게 내 온라인 상태를 보여줍니다',
          _showOnlineStatus,
          (value) => setState(() => _showOnlineStatus = value),
        ),
        _buildSwitchTile(
          '프로필 조회 허용',
          '다른 사용자가 내 프로필을 볼 수 있습니다',
          _allowProfileViewing,
          (value) => setState(() => _allowProfileViewing = value),
        ),
        _buildSwitchTile(
          '평점 공개',
          '내 평점과 리뷰를 다른 사용자에게 보여줍니다',
          _allowRatingDisplay,
          (value) => setState(() => _allowRatingDisplay = value),
        ),
        _buildSwitchTile(
          '거래 이력 공개',
          '거래 횟수와 성공률을 공개합니다',
          _showTransactionHistory,
          (value) => setState(() => _showTransactionHistory = value),
        ),
      ],
    );
  }

  Widget _buildContactSettings() {
    return _buildSettingSection(
      '연락처 설정',
      Icons.contact_phone,
      [
        _buildSwitchTile(
          '직접 연락 허용',
          '다른 사용자가 직접 연락할 수 있습니다',
          _allowDirectContact,
          (value) => setState(() => _allowDirectContact = value),
        ),
        ListTile(
          title: const Text('연락 가능 시간'),
          subtitle: const Text('오전 9시 - 오후 9시'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showContactTimeSettings(),
        ),
        ListTile(
          title: const Text('자동 응답 메시지'),
          subtitle: const Text('부재중일 때 보낼 메시지를 설정하세요'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAutoReplySettings(),
        ),
      ],
    );
  }

  Widget _buildLocationSettings() {
    return _buildSettingSection(
      '위치 설정',
      Icons.location_on,
      [
        _buildSwitchTile(
          '정확한 위치 공개',
          '상세 주소 대신 동네 이름만 표시합니다',
          !_showExactLocation,
          (value) => setState(() => _showExactLocation = !value),
        ),
        ListTile(
          title: const Text('위치 공개 범위'),
          subtitle: Text(_showExactLocation ? '상세 주소 공개' : '동네 이름만 공개'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLocationSettings(),
        ),
        ListTile(
          title: const Text('안전 장소 추천'),
          subtitle: const Text('근처 안전한 만남 장소를 추천받습니다'),
          trailing: Switch(
            value: true,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildDataSettings() {
    return _buildSettingSection(
      '데이터 관리',
      Icons.data_usage,
      [
        ListTile(
          title: const Text('내 데이터 다운로드'),
          subtitle: const Text('내가 제공한 모든 정보를 다운로드합니다'),
          trailing: const Icon(Icons.download),
          onTap: () => _requestDataDownload(),
        ),
        ListTile(
          title: const Text('계정 비활성화'),
          subtitle: const Text('계정을 일시적으로 비활성화합니다'),
          trailing: const Icon(Icons.pause),
          onTap: () => _showDeactivateDialog(),
        ),
        ListTile(
          title: const Text('계정 삭제'),
          subtitle: const Text('모든 데이터를 영구 삭제합니다'),
          trailing: Icon(Icons.delete, color: Colors.red[600]),
          onTap: () => _showDeleteAccountDialog(),
        ),
      ],
    );
  }

  Widget _buildBlockedUsers() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.block, color: Colors.red),
                const SizedBox(width: 12),
                const Text(
                  '차단된 사용자',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.user.blockedUsers.length}명',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.user.blockedUsers.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '차단된 사용자가 없습니다',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: widget.user.blockedUsers.take(3).map((userId) => 
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(userId.substring(0, 1).toUpperCase()),
                    ),
                    title: Text('사용자 $userId'),
                    trailing: TextButton(
                      onPressed: () => _unblockUser(userId),
                      child: const Text('차단해제'),
                    ),
                  )
                ).toList(),
              ),
            if (widget.user.blockedUsers.length > 3)
              TextButton(
                onPressed: () => _showAllBlockedUsers(),
                child: Text('${widget.user.blockedUsers.length - 3}명 더 보기'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text(
                  '도움말 및 지원',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text('개인정보처리방침'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPrivacyPolicy(),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('보안 가이드'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSecurityGuide(),
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('개인정보 신고'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _reportPrivacyIssue(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection(String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  int _calculatePrivacyScore() {
    int score = 0;
    
    // 기본 보호 점수
    score += 20;
    
    // 설정에 따른 점수 조정
    if (!_allowDirectContact) score += 15;
    if (!_showExactLocation) score += 20;
    if (!_allowRatingDisplay) score += 10;
    if (!_showOnlineStatus) score += 10;
    if (!_allowProfileViewing) score += 15;
    if (!_showTransactionHistory) score += 10;
    
    return score.clamp(0, 100);
  }

  Color _getPrivacyScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.yellow[700]!;
    return Colors.red;
  }

  String _getPrivacyLevel(int score) {
    if (score >= 80) return '높음';
    if (score >= 60) return '보통';
    if (score >= 40) return '낮음';
    return '위험';
  }

  void _showContactTimeSettings() {
    // TODO: Implement contact time settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('연락 가능 시간 설정 기능을 구현 예정입니다')),
    );
  }

  void _showAutoReplySettings() {
    // TODO: Implement auto reply settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('자동 응답 메시지 설정 기능을 구현 예정입니다')),
    );
  }

  void _showLocationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('위치 공개 설정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              title: const Text('동네 이름만 공개'),
              subtitle: const Text('예: 강남구 역삼동'),
              value: false,
              groupValue: _showExactLocation,
              onChanged: (value) {
                setState(() => _showExactLocation = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<bool>(
              title: const Text('상세 주소 공개'),
              subtitle: const Text('예: 서울시 강남구 역삼동 123-45'),
              value: true,
              groupValue: _showExactLocation,
              onChanged: (value) {
                setState(() => _showExactLocation = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _requestDataDownload() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 다운로드'),
        content: const Text(
          '회원님의 모든 개인정보를 JSON 파일로 다운로드합니다. '
          '처리까지 최대 7일이 소요될 수 있습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터 다운로드 요청이 접수되었습니다')),
              );
            },
            child: const Text('요청'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 비활성화'),
        content: const Text(
          '계정을 비활성화하면:\n'
          '• 다른 사용자에게 프로필이 보이지 않습니다\n'
          '• 새로운 메시지를 받을 수 없습니다\n'
          '• 언제든지 다시 활성화할 수 있습니다',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('계정이 비활성화되었습니다')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('비활성화'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '계정을 삭제하면:\n'
          '• 모든 개인정보가 영구 삭제됩니다\n'
          '• 거래 이력이 모두 사라집니다\n'
          '• 복구가 불가능합니다\n\n'
          '정말로 계정을 삭제하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('최종 확인'),
        content: const Text(
          '계정 삭제는 되돌릴 수 없습니다.\n'
          '정말로 진행하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('계정 삭제 요청이 접수되었습니다')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('최종 삭제'),
          ),
        ],
      ),
    );
  }

  void _unblockUser(String userId) async {
    try {
      final safetyService = ref.read(safetyServiceProvider);
      final success = await safetyService.unblockUser(widget.user.id, userId);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('차단이 해제되었습니다')),
        );
        // TODO: Refresh user data
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('차단 해제 실패: $e')),
      );
    }
  }

  void _showAllBlockedUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlockedUsersScreen(user: widget.user),
      ),
    );
  }

  void _showPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _showSecurityGuide() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecurityGuideScreen(),
      ),
    );
  }

  void _reportPrivacyIssue() {
    // TODO: Implement privacy issue reporting
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('개인정보 신고 기능을 구현 예정입니다')),
    );
  }
}

class PrivacyHelpDialog extends StatelessWidget {
  const PrivacyHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('개인정보 보호 도움말'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '프라이버시 점수란?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '개인정보 보호 설정에 따라 계산되는 점수입니다. '
              '점수가 높을수록 개인정보가 더 안전하게 보호됩니다.',
            ),
            SizedBox(height: 16),
            Text(
              '권장 설정',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• 정확한 위치 공개: 끄기\n'
              '• 직접 연락 허용: 끄기\n'
              '• 온라인 상태 표시: 끄기\n'
              '• 거래 이력 공개: 끄기',
            ),
            SizedBox(height: 16),
            Text(
              '안전한 거래 팁',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• 개인정보는 최소한으로만 공개하세요\n'
              '• 만남은 공개된 장소에서 하세요\n'
              '• 의심스러운 요청은 즉시 신고하세요',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

// Placeholder screens
class BlockedUsersScreen extends StatelessWidget {
  final UserModel user;

  const BlockedUsersScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('차단된 사용자'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('차단된 사용자 목록 화면 (구현 예정)'),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보처리방침'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('개인정보처리방침 화면 (구현 예정)'),
      ),
    );
  }
}

class SecurityGuideScreen extends StatelessWidget {
  const SecurityGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보안 가이드'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('보안 가이드 화면 (구현 예정)'),
      ),
    );
  }
}