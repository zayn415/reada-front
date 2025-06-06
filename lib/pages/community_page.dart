import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedTab = 0; // 当前选中的话题标签
  final List<String> _tabs = ['书评', '阅读笔记', '阅读心得', '书籍吐槽', '问答'];
  final List<Map<String, dynamic>> _posts = [
    {
      'avatar': null,
      'username': '书友A',
      'time': '2小时前',
      'title': '《三体》黑暗森林理论解读',
      'content': '读完第二部后对黑暗森林法则有了新的理解...',
      'likes': 24,
      'comments': 8,
      'views': 156,
    },
    {
      'avatar': null,
      'username': '书友B',
      'time': '昨天',
      'title': '分享《活着》读书笔记',
      'content': '这本书让我深刻理解了生命的坚韧...',
      'image': 'https://example.com/book1.jpg',
      'likes': 42,
      'comments': 15,
      'views': 289,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '社区',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _navigateToCreatePost(),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          // 2.2 话题过滤与推荐
          _buildTabBar(),
          // 2.3 精选推荐轮播（可选）
          _buildBannerCarousel(),
          // 2.4 帖子列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index == _posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        '—— 已到底 ——',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return _buildPostCard(_posts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _selectedTab = index),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color:
                              _selectedTab == index
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                    ),
                    if (_selectedTab == index)
                      Container(height: 2, width: 20, color: Colors.black),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Text(
                '活动海报 ${index + 1}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 作者信息
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child:
                      post['avatar'] == null
                          ? const Icon(Icons.person, size: 20)
                          : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['username'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      post['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 帖子内容
            Text(
              post['title'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              post['content'],
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (post['image'] != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 40),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // 互动统计
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildInteractionItem(Icons.thumb_up, post['likes']),
                const SizedBox(width: 16),
                _buildInteractionItem(Icons.comment, post['comments']),
                const SizedBox(width: 16),
                _buildInteractionItem(Icons.remove_red_eye, post['views']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _navigateToCreatePost() {
    // TODO: 实现发帖页面导航
  }
}
