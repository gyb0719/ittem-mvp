import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: chat['avatar'] != null
                  ? NetworkImage(chat['avatar'])
                  : null,
              child: chat['avatar'] == null
                  ? Text(chat['name'][0])
                  : null,
            ),
            title: Text(chat['name']),
            subtitle: Text(
              chat['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat['time'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                if (chat['unreadCount'] > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chat['unreadCount'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    chatName: chat['name'],
                    itemName: chat['itemName'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String chatName;
  final String itemName;

  const ChatDetailScreen({
    super.key,
    required this.chatName,
    required this.itemName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        'text': '안녕하세요! ${widget.itemName} 대여 문의드려요.',
        'isMe': false,
        'time': '오후 2:30',
      },
      {
        'text': '네 안녕하세요! 언제 사용하실 예정인가요?',
        'isMe': true,
        'time': '오후 2:32',
      },
      {
        'text': '이번 주말에 사용하려고 합니다.',
        'isMe': false,
        'time': '오후 2:33',
      },
    ];
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
            child: ListView.builder(
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
                    message['time'],
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

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': '방금',
        });
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
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