import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../module/book.dart';

// 书架页面
class ShelfPage extends StatefulWidget {
  const ShelfPage({super.key});

  @override
  State<ShelfPage> createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0; // 0：全部，1：在读，2：已读
  bool _isGridView = true; // 书架布局：false：列表，true：网格

  final List<Book> _books = [
    Book(null, 'Flutter实战', 0.35),
    Book(null, 'Dart编程', 0.0),
    Book(null, '设计模式', 0.8),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('书架', style: TextStyle(fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, size: 25),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.add_circle_outline, size: 25),
                  color: Colors.white,
                  offset: Offset(-5, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'import',
                        height: 30,
                        child: Text('导入'),
                        onTap: () {
                          pickEpubFile();
                        },
                      ),
                      PopupMenuItem<String>(
                        value: 'setting',
                        height: 30,
                        child: Text('设置'),
                      ),
                      PopupMenuDivider(height: 10),
                      PopupMenuItem<String>(
                        value: 'logout',
                        height: 30,
                        child: Text('退出登录'),
                        onTap: () {
                          // 退出登录
                          if (kDebugMode) {
                            print('退出登录');
                          }
                        },
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1.3 书籍分类与筛选
            _buildTabBar(),
            // 1.4 书籍展示区
            Expanded(child: _isGridView ? _buildGridView() : _buildListView()),
            // 1.5 空状态与引导
            if (_books.isEmpty) _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            ['全部', '已下载', '最近阅读', '分类'].asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _selectedTab = index),
                      child: Text(
                        title,
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

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return GestureDetector(
          onTap: () => _openBook(book),
          onLongPress: () => _showBookMenu(book),
          child: BookCard(
            coverUrl: book.coverUrl,
            title: book.title,
            progress: book.progress,
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              book.coverUrl ?? '',
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 60,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.book),
                  ),
            ),
          ),
          title: Text(
            book.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '作者 · ${book.progress > 0 ? '已读 ${(book.progress * 100).toInt()}%' : '未读'}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openBook(book),
          onLongPress: () => _showBookMenu(book),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('点击右上角"导入"按钮，添加本地书籍'),
          TextButton(
            onPressed: () => _goToBookStore(),
            child: const Text('去书店逛逛'),
          ),
        ],
      ),
    );
  }

  void _openBook(Book book) {
    // 打开书籍阅读页
  }

  void _showBookMenu(Book book) {
    // 显示长按菜单
  }

  void _goToBookStore() {
    // 跳转在线书城
  }

  // 选择 epub 文件
  Future<void> pickEpubFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub'],
      allowMultiple: true,
    );

    if (result != null) {
      if (kDebugMode) {
        print('选择的文件路径: ${result.files.single.path}');
      }
    } else {
      print('没有选择');
    }
  }
}

class Book {
  final String? coverUrl;
  final String title;
  final double progress;

  Book(this.coverUrl, this.title, this.progress); // 0.0 ~ 1.0
}
