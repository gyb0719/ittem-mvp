import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/verification_model.dart';
import '../../shared/services/auth_service.dart';
import '../../services/safety_service.dart';
import '../../shared/widgets/trust_widgets.dart';
import '../../theme/colors.dart';

class SafeChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final UserModel otherUser;
  final String? itemTitle;

  const SafeChatScreen({
    super.key,
    required this.chatId,
    required this.otherUser,
    this.itemTitle,
  });

  @override
  ConsumerState<SafeChatScreen> createState() => _SafeChatScreenState();
}

class _SafeChatScreenState extends ConsumerState<SafeChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _showSafetyWarning = false;
  bool _hasShownExternalContactWarning = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Mock messages for demonstration
    _messages.addAll([
      ChatMessage(
        id: '1',
        senderId: widget.otherUser.id,
        message: '안녕하세요! ${widget.itemTitle ?? '아이템'} 대여 문의드려요.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isFiltered: false,
      ),
      ChatMessage(
        id: '2',
        senderId: 'current-user',
        message: '네 안녕하세요! 언제 사용하실 예정인가요?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isFiltered: false,
      ),
    ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildSafeChatAppBar(),
      body: Column(
        children: [
          _buildSafetyHeader(),
          if (_showSafetyWarning) _buildSafetyWarning(),
          if (widget.itemTitle != null) _buildItemCard(),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildSafetyTips(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSafeChatAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.otherUser.profileImageUrl != null
                    ? NetworkImage(widget.otherUser.profileImageUrl!)
                    : null,
                child: widget.otherUser.profileImageUrl == null
                    ? Text(
                        widget.otherUser.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: SafetyIndicator(
                  user: widget.otherUser,
                  onTap: () => _showSafetyInfo(context),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.otherUser.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TrustBadgeRow(
                      user: widget.otherUser,
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  widget.otherUser.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: AppColors.textPrimary),
          onPressed: () => _showUserProfile(context),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'safety_center',
              child: Row(
                children: [
                  Icon(Icons.security, size: 20),
                  SizedBox(width: 8),
                  Text('안전센터'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.report, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('신고하기'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('차단하기'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSafetyHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green.shade50,
      child: Row(
        children: [
          Icon(Icons.shield, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '안전한 채팅을 위해 개인정보 공유를 자제해주세요',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _showSafetyGuidelines(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              '가이드',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyWarning() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '의심스러운 내용이 감지되었습니다',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '안전을 위해 앱 내에서만 소통해주세요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _showSafetyWarning = false),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.separator,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.itemTitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  '채팅 중',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '상세보기',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessage(message);
      },
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final isMe = message.senderId == 'current-user'; // TODO: Use actual current user ID
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.otherUser.profileImageUrl != null
                  ? NetworkImage(widget.otherUser.profileImageUrl!)
                  : null,
              child: widget.otherUser.profileImageUrl == null
                  ? Text(
                      widget.otherUser.name.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: message.isFiltered
                    ? Border.all(color: Colors.orange, width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isFiltered) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning,
                            size: 14,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '필터된 내용',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Text(
                    message.displayMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe ? Colors.white70 : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: 16, color: AppColors.textTertiary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '💡 안전 거래 팁: 공개된 장소에서 만나고, 직거래를 권장합니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.separator),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '안전한 메시지를 입력하세요...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.textTertiary),
                    ),
                    maxLines: null,
                    onChanged: _checkMessageSafety,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
          if (_showSafetyWarning) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange.shade600, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '개인 연락처나 외부 앱 사용을 권장하지 않습니다',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _checkMessageSafety(String text) {
    final safetyService = ref.read(safetyServiceProvider);
    final isSuspicious = safetyService.isSuspiciousMessage(text);
    
    if (isSuspicious != _showSafetyWarning) {
      setState(() {
        _showSafetyWarning = isSuspicious;
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final safetyService = ref.read(safetyServiceProvider);
      final isSuspicious = safetyService.isSuspiciousMessage(text);
      final filteredText = safetyService.filterSuspiciousContent(text);
      
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'current-user', // TODO: Use actual current user ID
        message: text,
        displayMessage: filteredText,
        timestamp: DateTime.now(),
        isFiltered: text != filteredText,
      );

      setState(() {
        _messages.add(message);
        _showSafetyWarning = false;
      });

      _messageController.clear();

      // Show external contact warning if suspicious content detected
      if (isSuspicious && !_hasShownExternalContactWarning) {
        _showExternalContactWarning(context);
        _hasShownExternalContactWarning = true;
      }

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '방금';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'safety_center':
        _showSafetyGuidelines(context);
        break;
      case 'report':
        _showReportDialog(context);
        break;
      case 'block':
        _showBlockDialog(context);
        break;
    }
  }

  void _showSafetyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SafetyInfoDialog(user: widget.otherUser),
    );
  }

  void _showUserProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UserProfileDialog(user: widget.otherUser),
    );
  }

  void _showSafetyGuidelines(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SafetyGuidelinesDialog(),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        reportedUserId: widget.otherUser.id,
        chatId: widget.chatId,
      ),
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlockUserDialog(
        user: widget.otherUser,
        onConfirm: () => _blockUser(),
      ),
    );
  }

  void _showExternalContactWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ExternalContactWarningDialog(),
    );
  }

  Future<void> _blockUser() async {
    try {
      final safetyService = ref.read(safetyServiceProvider);
      final authState = ref.read(authStateProvider);
      
      if (authState is AuthStateAuthenticated) {
        final success = await safetyService.blockUser(
          authState.user.id,
          widget.otherUser.id,
        );

        if (success) {
          if (mounted) {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Close chat screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.otherUser.name}님을 차단했습니다.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차단 실패: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Data models
class ChatMessage {
  final String id;
  final String senderId;
  final String message;
  final String displayMessage;
  final DateTime timestamp;
  final bool isFiltered;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    String? displayMessage,
    required this.timestamp,
    required this.isFiltered,
  }) : displayMessage = displayMessage ?? message;
}

// Dialog widgets
class SafetyInfoDialog extends StatelessWidget {
  final UserModel user;

  const SafetyInfoDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('사용자 안전 정보'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? Text(
                        user.name.substring(0, 1),
                        style: const TextStyle(fontSize: 20),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(user.location),
                    const SizedBox(height: 8),
                    TrustScoreIndicator(user: user, size: 60),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '신뢰도 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          VerificationStatusRow(user: user),
          const SizedBox(height: 16),
          TrustBadgeRow(user: user, showLabels: true),
          const SizedBox(height: 16),
          SafetyIndicator(user: user),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class UserProfileDialog extends StatelessWidget {
  final UserModel user;

  const UserProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('사용자 프로필'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user.profileImageUrl != null
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null
                ? Text(
                    user.name.substring(0, 1),
                    style: const TextStyle(fontSize: 24),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(user.location),
          if (user.bio != null) ...[
            const SizedBox(height: 12),
            Text(
              user.bio!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('거래', '${user.transactionCount}'),
              _buildStatItem('평점', '${user.rating}'),
              _buildStatItem('리뷰', '${user.reviewsReceived}'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class SafetyGuidelinesDialog extends ConsumerWidget {
  const SafetyGuidelinesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safetyTips = ref.watch(safetyTipsProvider(null));

    return AlertDialog(
      title: const Text('안전 가이드라인'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...safetyTips.map((tip) => ListTile(
              leading: Icon(
                _getIconData(tip.iconName ?? 'info'),
                color: AppColors.primary,
              ),
              title: Text(
                tip.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(tip.description),
            )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
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

class BlockUserDialog extends StatelessWidget {
  final UserModel user;
  final VoidCallback onConfirm;

  const BlockUserDialog({
    super.key,
    required this.user,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('사용자 차단'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${user.name}님을 차단하시겠습니까?'),
          const SizedBox(height: 16),
          const Text(
            '차단 시:\n'
            '• 더 이상 메시지를 주고받을 수 없습니다\n'
            '• 상대방의 게시글이 보이지 않습니다\n'
            '• 검색 결과에서 제외됩니다',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('차단'),
        ),
      ],
    );
  }
}

class ExternalContactWarningDialog extends StatelessWidget {
  const ExternalContactWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 8),
          Text('안전 알림'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '외부 연락처 교환이 감지되었습니다',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '안전한 거래를 위해:\n'
            '• 앱 내에서만 소통하세요\n'
            '• 개인 정보 공유를 자제하세요\n'
            '• 의심스러운 요청은 신고하세요\n'
            '• 만남은 공개된 장소에서 하세요',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('이해했습니다'),
        ),
      ],
    );
  }
}