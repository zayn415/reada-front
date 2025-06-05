import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _selectedIndex = 0;
  final List<Message> _systemMessages = [];
  final List<Message> _commentMessages = [];
  final List<Message> _privateMessages = [];

  @override
  void initState() {
    super.initState();
    // 模拟数据
    _systemMessages.addAll([
      Message(
        type: 'system',
        title: '系统维护通知',
        content: '服务器将于今晚23:00-24:00进行维护升级',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
    ]);
    _commentMessages.addAll([
      Message(
        type: 'comment',
        title: '用户A评论了你的书评',
        content: '《三体》这本书我也很喜欢，特别是第二部黑暗森林理论',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
      ),
    ]);
    _privateMessages.addAll([
      Message(
        type: 'private',
        title: '用户B发来私信',
        content: '你好，请问你分享的《活着》读书笔记可以借我参考吗？',
        time: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ]);
  }

  List<Message> get _currentMessages {
    switch (_selectedIndex) {
      case 0:
        return _systemMessages;
      case 1:
        return _commentMessages;
      case 2:
        return _privateMessages;
      default:
        return [];
    }
  }

  // 全部已读
  void _markAllAsRead() {
    setState(() {
      for (var msg in _currentMessages) {
        msg.isRead = true;
      }
    });
  }

  // 删除消息
  void _deleteMessage(Message message) {
    setState(() {
      switch (_selectedIndex) {
        case 0:
          _systemMessages.remove(message);
          break;
        case 1:
          _commentMessages.remove(message);
          break;
        case 2:
          _privateMessages.remove(message);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _markAllAsRead(),
            icon: Icon(Icons.cleaning_services_sharp),
          ),
          IconButton(
            onPressed: () {
              // 进入消息设置
              Navigator.pushNamed(context, '/message_settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // 3.2 消息分类
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: 0, label: _buildSegmentLabel('私信', 0)),
                ButtonSegment(value: 1, label: _buildSegmentLabel('评论/回复', 1)),
                ButtonSegment(value: 2, label: _buildSegmentLabel('系统通知', 2)),
              ],
              selected: {_selectedIndex},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedIndex = newSelection.first;
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          // 3.3 消息列表或3.4 空状态
          Expanded(
            child:
                _currentMessages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      itemCount: _currentMessages.length,
                      itemBuilder: (context, index) {
                        final message = _currentMessages[index];
                        return Dismissible(
                          key: Key('${message.type}_$index'),
                          background: Container(
                            color: Colors.grey[200],
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                          onDismissed: (direction) => _deleteMessage(message),
                          child: ListTile(
                            leading: _buildMessageIcon(message.type),
                            title: Text(
                              message.title,
                              style: TextStyle(
                                fontWeight:
                                    message.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              message.content,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatTime(message.time),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                  ),
                                ),
                                if (!message.isRead)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                message.isRead = true;
                              });
                              // 跳转到详情页
                              _navigateToDetail(message);
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentLabel(String text, int unreadCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (unreadCount > 0)
          Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              unreadCount.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'system':
        icon = Icons.notifications;
        color = Colors.blue;
        break;
      case 'comment':
        icon = Icons.comment;
        color = Colors.green;
        break;
      case 'private':
        icon = Icons.mail;
        color = Colors.purple;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildEmptyState() {
    IconData icon;
    String text;
    switch (_selectedIndex) {
      case 0:
        icon = Icons.mail_outline;
        text = '暂无私信';
        break;
      case 1:
        icon = Icons.comment_bank_outlined;
        text = '暂无评论和回复';
        break;
      case 2:
        icon = Icons.notifications_none;
        text = '暂无系统通知';
        break;
      default:
        icon = Icons.info_outline;
        text = '暂无消息';
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            '快去社区互动或导入更多书籍吧',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 30) {
      return '${time.month}月${time.day}日';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  void _navigateToDetail(Message message) {
    // 根据消息类型跳转到不同页面
    switch (message.type) {
      case 'system':
        Navigator.pushNamed(context, '/system_message_detail');
        break;
      case 'comment':
        Navigator.pushNamed(context, '/comment_detail');
        break;
      case 'private':
        Navigator.pushNamed(context, '/private_message_detail');
        break;
    }
  }
}

class Message {
  final String type; // system, comment, private
  final String title;
  final String content;
  final DateTime time;
  bool isRead;

  Message({
    required this.type,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
  });
}
