import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final supabaseService = ref.read(supabaseServiceProvider);
        final chats = await supabaseService.getChats(user.id);
        
        if (mounted) {
          setState(() {
            _chats = chats;
            _isLoading = false;
          });
        }
      } else {
        // Fallback to dummy data if not authenticated
        setState(() {
          _chats = _dummyChats;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading chats: $e');
      if (mounted) {
        setState(() {
          _chats = _dummyChats; // Fallback to dummy data
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chats.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '아직 채팅이 없습니다',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  child: ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      final participantName = chat['participant']?['name'] ?? 'Unknown';
                      final itemTitle = chat['item']?['title'] ?? 'Unknown Item';
                      final lastMessage = chat['last_message'] ?? 'No messages yet';
                      
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(participantName[0].toUpperCase()),
                        ),
                        title: Text(participantName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemTitle,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: chat['last_message_at'] != null
                            ? Text(
                                _formatTime(DateTime.parse(chat['last_message_at'])),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                chatId: chat['id'],
                                chatName: participantName,
                                itemName: itemTitle,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금';
    }
  }
}

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String chatName;
  final String itemName;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.chatName,
    required this.itemName,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  RealtimeChannel? _realtimeChannel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupRealtimeSubscription();
  }

  Future<void> _loadMessages() async {
    try {
      // In a real app, load messages from Supabase
      // For now, use dummy data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _messages = [
          {
            'text': '안녕하세요! ${widget.itemName} 대여 문의드려요.',
            'isMe': false,
            'time': DateTime.now().subtract(const Duration(hours: 2)),
            'sender_name': widget.chatName,
          },
          {
            'text': '네 안녕하세요! 언제 사용하실 예정인가요?',
            'isMe': true,
            'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
            'sender_name': 'Me',
          },
          {
            'text': '이번 주말에 사용하려고 합니다.',
            'isMe': false,
            'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 57)),
            'sender_name': widget.chatName,
          },
        ];
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      debugPrint('Error loading messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupRealtimeSubscription() {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      _realtimeChannel = supabaseService.subscribeToChat(
        widget.chatId,
        (message) {
          if (mounted) {
            setState(() {
              _messages.add({
                'text': message['message'],
                'isMe': false, // Will be determined based on sender_id
                'time': DateTime.now(),
                'sender_name': message['sender_name'] ?? 'Unknown',
              });
            });
            _scrollToBottom();
          }
        },
      );
    } catch (e) {
      debugPrint('Error setting up realtime subscription: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatName),
            Text(
              widget.itemName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessage(message);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message['isMe']) ...[
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: message['isMe']
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: message['isMe']
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMessageTime(message['time']),
                    style: TextStyle(
                      fontSize: 12,
                      color: message['isMe']
                          ? Colors.white70
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message['isMe']) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      _messageController.clear();
      
      // Add message to local list immediately for better UX
      final tempMessage = {
        'text': messageText,
        'isMe': true,
        'time': DateTime.now(),
        'sender_name': 'Me',
        'sending': true,
      };
      
      setState(() {
        _messages.add(tempMessage);
      });
      
      _scrollToBottom();
      
      try {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          final supabaseService = ref.read(supabaseServiceProvider);
          await supabaseService.sendMessage(
            chatId: widget.chatId,
            senderId: user.id,
            message: messageText,
          );
          
          // Update the message to show it was sent successfully
          setState(() {
            final index = _messages.indexOf(tempMessage);
            if (index != -1) {
              _messages[index] = {
                ...tempMessage,
                'sending': false,
              };
            }
          });
        }
      } catch (e) {
        debugPrint('Error sending message: $e');
        // Show error state or retry option
        setState(() {
          final index = _messages.indexOf(tempMessage);
          if (index != -1) {
            _messages[index] = {
              ...tempMessage,
              'sending': false,
              'error': true,
            };
          }
        });
      }
    }
  }
  
  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      return '오후 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${messageDate.month}/${messageDate.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}

final List<Map<String, dynamic>> _dummyChats = [
  {
    'name': '김철수',
    'lastMessage': '네 안녕하세요! 언제 사용하실 예정인가요?',
    'time': '오후 2:32',
    'unreadCount': 2,
    'avatar': null,
    'itemName': '캐논 DSLR 카메라',
  },
  {
    'name': '이영희',
    'lastMessage': '감사합니다. 잘 사용하겠습니다!',
    'time': '오전 11:20',
    'unreadCount': 0,
    'avatar': null,
    'itemName': '캠핑 텐트',
  },
  {
    'name': '박민수',
    'lastMessage': '내일 오후에 수령 가능한가요?',
    'time': '어제',
    'unreadCount': 1,
    'avatar': null,
    'itemName': '전동 드릴',
  },
];