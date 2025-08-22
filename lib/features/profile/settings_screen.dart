import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme_service.dart';
import '../../shared/widgets/teal_components.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            
            // 계정 설정
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '계정',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.person_outline,
                    '프로필 편집',
                    '이름, 프로필 사진 등',
                    () => _showProfileEditDialog(context),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.security,
                    '본인 인증',
                    '신분증 인증 완료',
                    () => _showVerificationDialog(context),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '인증완료',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.lock_outline,
                    '비밀번호 변경',
                    '보안을 위해 정기적으로 변경하세요',
                    () => _showPasswordChangeDialog(context),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 알림 설정
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '알림',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildSwitchItem(
                    context,
                    Icons.notifications_outlined,
                    '푸시 알림',
                    '새 메시지, 대여 요청 등',
                    true,
                    (value) {},
                  ),
                  _buildSwitchItem(
                    context,
                    Icons.chat_bubble_outline,
                    '채팅 알림',
                    '새로운 채팅 메시지',
                    true,
                    (value) {},
                  ),
                  _buildSwitchItem(
                    context,
                    Icons.campaign_outlined,
                    '마케팅 알림',
                    '이벤트, 혜택 정보',
                    false,
                    (value) {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 화면 설정
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '화면',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildThemeSettingItem(context, ref, currentThemeMode),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 위치 설정
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '위치',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.location_on_outlined,
                    '동네 범위 설정',
                    '잠실동 · 반경 2km',
                    () => _showLocationRangeDialog(context),
                  ),
                  _buildSwitchItem(
                    context,
                    Icons.my_location_outlined,
                    '위치 서비스',
                    '현재 위치 기반 서비스',
                    true,
                    (value) {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 앱 설정
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '앱',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.language_outlined,
                    '언어',
                    '한국어',
                    () => _showLanguageDialog(context),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.dark_mode_outlined,
                    '다크 모드',
                    '시스템 설정 따름',
                    () => _showThemeDialog(context, ref, ref.read(themeNotifierProvider)),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.storage_outlined,
                    '캐시 정리',
                    '임시 파일 및 캐시 삭제',
                    () => _showCacheClearDialog(context),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 지원
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '지원',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.help_outline,
                    '도움말',
                    '자주 묻는 질문',
                    () => _showHelpDialog(context),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.feedback_outlined,
                    '피드백 보내기',
                    '의견이나 문제점 신고',
                    () => _showFeedbackDialog(context),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.info_outline,
                    '앱 정보',
                    '버전 1.0.0',
                    () => _showAppInfoDialog(context),
                  ),
                  _buildSettingItem(
                    context,
                    Icons.description_outlined,
                    '이용약관',
                    '서비스 약관 및 개인정보 처리방침',
                    () => _showTermsDialog(context),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF6B7280),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: trailing ?? const Icon(
        Icons.chevron_right,
        color: Color(0xFF9CA3AF),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF6B7280),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF34D399),
      ),
    );
  }

  Widget _buildThemeSettingItem(BuildContext context, WidgetRef ref, AppThemeMode currentMode) {
    String getThemeName(AppThemeMode mode) {
      switch (mode) {
        case AppThemeMode.light:
          return '라이트 모드';
        case AppThemeMode.dark:
          return '다크 모드';
        case AppThemeMode.system:
          return '시스템 설정';
      }
    }

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          currentMode == AppThemeMode.dark 
              ? Icons.dark_mode_outlined
              : currentMode == AppThemeMode.light
                  ? Icons.light_mode_outlined
                  : Icons.brightness_auto_outlined,
          color: const Color(0xFF6B7280),
          size: 20,
        ),
      ),
      title: const Text(
        '화면 테마',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        getThemeName(currentMode),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF9CA3AF),
      ),
      onTap: () => _showThemeDialog(context, ref, currentMode),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '화면 테마 선택',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...AppThemeMode.values.map((mode) {
              String title;
              String subtitle;
              IconData icon;

              switch (mode) {
                case AppThemeMode.light:
                  title = '라이트 모드';
                  subtitle = '밝은 화면으로 표시됩니다';
                  icon = Icons.light_mode_outlined;
                  break;
                case AppThemeMode.dark:
                  title = '다크 모드';
                  subtitle = '어두운 화면으로 표시됩니다';
                  icon = Icons.dark_mode_outlined;
                  break;
                case AppThemeMode.system:
                  title = '시스템 설정';
                  subtitle = '기기 설정을 따라갑니다';
                  icon = Icons.brightness_auto_outlined;
                  break;
              }

              return RadioListTile<AppThemeMode>(
                title: Text(title),
                subtitle: Text(subtitle),
                value: mode,
                groupValue: currentMode,
                onChanged: (AppThemeMode? value) {
                  if (value != null) {
                    ref.read(themeNotifierProvider.notifier).setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
                secondary: Icon(icon),
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showProfileEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 편집'),
        content: const Text('프로필 편집 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('본인 인증'),
        content: const Text('이미 본인 인증이 완료되었습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 변경'),
        content: const Text('비밀번호 변경 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showLocationRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('동네 범위 설정'),
        content: const Text('현재 설정: 잠실동 · 반경 2km\n\n다른 범위로 변경하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('동네 범위 설정 기능을 구현 예정입니다')),
              );
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 설정'),
        content: const Text('현재: 한국어\n\n다른 언어를 선택하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('언어 설정 기능을 구현 예정입니다')),
              );
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );
  }


  void _showCacheClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캐시 정리'),
        content: const Text('임시 파일과 캐시를 정리하시겠습니까?\n\n약 15MB의 저장 공간이 확보됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('캐시가 정리되었습니다')),
              );
            },
            child: const Text('정리'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const Text('자주 묻는 질문:\n\n• 물건은 어떻게 대여하나요?\n• 대여료는 어떻게 결정되나요?\n• 분실이나 파손 시 어떻게 하나요?\n• 신고는 어떻게 하나요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('피드백 보내기'),
        content: const Text('개선사항이나 문제점을 알려주세요.\n\n고객센터: help@ittem.com\n전화: 1588-1234'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 정보'),
        content: const Text('Ittem - 지역 기반 물건 대여\n\n버전: 1.0.0\n빌드: 20241221\n\n© 2024 Ittem Team'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이용약관'),
        content: const Text('서비스 이용약관 및 개인정보 처리방침을 확인하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('약관 페이지로 이동합니다')),
              );
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}