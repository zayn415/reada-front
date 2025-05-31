import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reada/module/book.dart';

// 书架页面
class ShelfPage extends StatefulWidget {
  const ShelfPage({super.key});

  @override
  State<ShelfPage> createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  final TextEditingController _searchController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BookCard(coverUrl: null, title: 'title', progress: 0.2),
                  BookCard(coverUrl: null, title: 'title', progress: 0.2),
                  BookCard(coverUrl: null, title: 'title', progress: 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
