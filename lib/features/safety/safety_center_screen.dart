import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/models/verification_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/auth_service.dart';
import '../../services/safety_service.dart';
import '../../shared/widgets/trust_widgets.dart';
import '../../theme/colors.dart';

class SafetyCenterScreen extends ConsumerStatefulWidget {
  const SafetyCenterScreen({super.key});

  @override
  ConsumerState<SafetyCenterScreen> createState() => _SafetyCenterScreenState();
}

class _SafetyCenterScreenState extends ConsumerState<SafetyCenterScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final safetyTips = ref.watch(safetyTipsProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: const Text('안전센터'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: () => _showEmergencyDialog(context),
            tooltip: '긴급상황',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencySection(context),
            const SizedBox(height: 24),
            if (authState is AuthStateAuthenticated) ...[
              _buildUserSafetyStatus(authState.user),
              const SizedBox(height: 24),
            ],
            _buildSafetyGuides(context, safetyTips),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildSafetyResources(context),
            const SizedBox(height: 24),
            _buildReportCenter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emergency,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              const Text(
                '긴급상황 신고',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '위험한 상황에 처했거나 도움이 필요할 때 즉시 신고하세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _callEmergency('112'),
                  icon: const Icon(Icons.local_police),
                  label: const Text('112 신고'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEmergencyDialog(context),
                  icon: const Icon(Icons.report_problem),
                  label: const Text('앱 내 신고'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserSafetyStatus(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '내 안전 현황',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TrustScoreIndicator(user: user, size: 60),
                      const SizedBox(height: 8),
                      SafetyIndicator(user: user),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerificationStatusRow(user: user),
                      const SizedBox(height: 12),
                      TrustBadgeRow(user: user, showLabels: true),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/verification'),
                icon: const Icon(Icons.verified_user),
                label: const Text('인증 완료하기'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyGuides(BuildContext context, List<SafetyTipModel> tips) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '안전 가이드',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.take(3).map((tip) => SafetyTipCard(tip: tip)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SafetyGuideDetailScreen(tips: tips),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('모든 가이드 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '빠른 기능',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.location_on,
                    title: '안전장소',
                    subtitle: '근처 안전한 만남 장소',
                    onTap: () => _showSafePlaces(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.shield,
                    title: '사기예방',
                    subtitle: '사기 수법 및 예방법',
                    onTap: () => _showScamPrevention(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.report_problem,
                    title: '신고하기',
                    subtitle: '의심스러운 활동 신고',
                    onTap: () => _showReportDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.help,
                    title: '도움말',
                    subtitle: 'FAQ 및 지원',
                    onTap: () => _showHelp(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyResources(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.library_books,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '안전 자료',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('안전 교육 동영상'),
              subtitle: const Text('거래 안전 수칙 동영상 시청'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openSafetyVideos(),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('안전 거래 체크리스트'),
              subtitle: const Text('거래 전 확인해야 할 사항들'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSafetyChecklist(context),
            ),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('사기 피해 사례'),
              subtitle: const Text('실제 사기 사례 및 대응법'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showScamCases(context),
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text('이용약관 및 정책'),
              subtitle: const Text('서비스 이용 규정 및 정책'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermsAndPolicies(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCenter(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.report,
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '신고센터',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '의심스러운 활동이나 부적절한 행동을 발견하면 언제든 신고해주세요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showReportDialog(context),
                    icon: const Icon(Icons.report_problem),
                    label: const Text('사용자 신고'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showMyReports(context),
                    icon: const Icon(Icons.history),
                    label: const Text('내 신고 내역'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _callEmergency(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$number 연결에 실패했습니다')),
        );
      }
    }
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const EmergencyReportDialog(),
    );
  }

  void _showSafePlaces(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SafePlacesScreen(),
      ),
    );
  }

  void _showScamPrevention(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScamPreventionScreen(),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ReportDialog(reportedUserId: 'general'),
    );
  }

  void _showHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpScreen(),
      ),
    );
  }

  void _openSafetyVideos() async {
    const url = 'https://www.youtube.com/playlist?list=example-safety-videos';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSafetyChecklist(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SafetyChecklistScreen(),
      ),
    );
  }

  void _showScamCases(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScamCasesScreen(),
      ),
    );
  }

  void _showTermsAndPolicies(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsAndPoliciesScreen(),
      ),
    );
  }

  void _showMyReports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyReportsScreen(),
      ),
    );
  }
}

class SafetyTipCard extends StatelessWidget {
  final SafetyTipModel tip;

  const SafetyTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(
            _getIconData(tip.iconName ?? 'info'),
            color: Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'location_on':
        return Icons.location_on;
      case 'verified_user':
        return Icons.verified_user;
      case 'chat':
        return Icons.chat;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.info;
    }
  }
}

class EmergencyReportDialog extends ConsumerStatefulWidget {
  const EmergencyReportDialog({super.key});

  @override
  ConsumerState<EmergencyReportDialog> createState() => _EmergencyReportDialogState();
}

class _EmergencyReportDialogState extends ConsumerState<EmergencyReportDialog> {
  final _descriptionController = TextEditingController();
  String? _selectedEmergencyType;
  String? _locationInfo;
  bool _isSubmitting = false;

  final List<Map<String, String>> _emergencyTypes = [
    {'id': 'threat', 'title': '신체적 위협', 'description': '폭행, 협박 등 신체적 위험'},
    {'id': 'scam', 'title': '사기 시도', 'description': '금전 요구, 허위 정보 등'},
    {'id': 'inappropriate', 'title': '부적절한 행동', 'description': '성희롱, 욕설 등'},
    {'id': 'stalking', 'title': '스토킹', 'description': '지속적인 괴롭힘, 추적'},
    {'id': 'other', 'title': '기타', 'description': '기타 긴급상황'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.emergency, color: Colors.red),
          SizedBox(width: 8),
          Text('긴급상황 신고'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '생명이 위험한 응급상황은 112에 신고하세요',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '긴급상황 유형',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._emergencyTypes.map((type) => RadioListTile<String>(
                title: Text(type['title']!),
                subtitle: Text(
                  type['description']!,
                  style: const TextStyle(fontSize: 12),
                ),
                value: type['id']!,
                groupValue: _selectedEmergencyType,
                onChanged: (value) {
                  setState(() => _selectedEmergencyType = value);
                },
                contentPadding: EdgeInsets.zero,
              )),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '상황 설명',
                  hintText: '상황을 자세히 설명해주세요',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '현재 위치 (선택)',
                  hintText: '현재 있는 장소를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _locationInfo = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _canSubmit() ? _submitEmergencyReport : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('긴급 신고'),
        ),
      ],
    );
  }

  bool _canSubmit() {
    return !_isSubmitting && 
           _selectedEmergencyType != null && 
           _descriptionController.text.trim().isNotEmpty;
  }

  Future<void> _submitEmergencyReport() async {
    setState(() => _isSubmitting = true);

    try {
      // TODO: Submit emergency report to backend
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('긴급신고가 접수되었습니다. 빠른 시일 내 조치하겠습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('신고 접수 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

// Placeholder screens for detailed safety features
class SafetyGuideDetailScreen extends StatelessWidget {
  final List<SafetyTipModel> tips;

  const SafetyGuideDetailScreen({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('안전 가이드'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return SafetyTipCard(tip: tips[index]);
        },
      ),
    );
  }
}

class SafePlacesScreen extends StatelessWidget {
  const SafePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('안전한 만남 장소'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('안전한 만남 장소 추천 화면 (구현 예정)'),
      ),
    );
  }
}

class ScamPreventionScreen extends StatelessWidget {
  const ScamPreventionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사기 예방'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('사기 예방 가이드 화면 (구현 예정)'),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('도움말 및 FAQ 화면 (구현 예정)'),
      ),
    );
  }
}

class SafetyChecklistScreen extends StatelessWidget {
  const SafetyChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('안전 거래 체크리스트'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('안전 거래 체크리스트 화면 (구현 예정)'),
      ),
    );
  }
}

class ScamCasesScreen extends StatelessWidget {
  const ScamCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사기 피해 사례'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('사기 피해 사례 화면 (구현 예정)'),
      ),
    );
  }
}

class TermsAndPoliciesScreen extends StatelessWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용약관 및 정책'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('이용약관 및 정책 화면 (구현 예정)'),
      ),
    );
  }
}

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 신고 내역'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('내 신고 내역 화면 (구현 예정)'),
      ),
    );
  }
}