import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reada/providers/user_provider.dart';

import '../constants/colors.dart';
import '../routes/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 4.1 顶部用户信息卡
              _buildUserProfileCard(context, userProvider),
              const SizedBox(height: 8),

              // 4.2 阅读统计与成就
              _buildStatsSection(),
              const SizedBox(height: 8),

              // 4.3 功能列表分组
              _buildFunctionList(context, userProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(
    BuildContext context,
    UserProvider userProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFD1D0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 左侧头像
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
              ),
              // VIP徽章
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.star, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // 右侧用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '用户名',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@example.com',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text(
                    '编辑资料',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // 签到图标
          IconButton(
            onPressed: () => _showCheckInDialog(context),
            icon: const Icon(Icons.card_giftcard, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFEFD1D0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.collections_bookmark, '128', '收藏书籍'),
          _buildStatItem(Icons.timer, '256', '阅读时长'),
          _buildStatItem(Icons.workspace_premium, '12', '成就徽章'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: ColorConstants.primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildFunctionList(BuildContext context, UserProvider userProvider) {
    return Column(
      children: [
        // 我的书单与书摘
        _buildListSection(
          title: '我的书单与书摘',
          items: [
            _buildListTile(Icons.menu_book, '我的书单', () {}),
            _buildListTile(Icons.note, '我的书摘', () {}),
            _buildListTile(Icons.history, '阅读历史', () {}),
          ],
        ),

        const SizedBox(height: 8),

        // 账户与会员
        _buildListSection(
          title: '账户与会员',
          items: [
            _buildListTile(Icons.payment, '购买历史', () {}),
            _buildListTile(Icons.card_membership, '会员中心', () {}),
            _buildListTile(Icons.card_giftcard, '礼品卡与兑换码', () {}),
          ],
        ),

        const SizedBox(height: 8),

        // 应用与偏好设置
        _buildListSection(
          title: '应用与偏好设置',
          items: [
            _buildListTile(Icons.settings, '通用设置', () {}),
            _buildListTile(Icons.notifications, '通知设置', () {}),
            _buildListTile(Icons.security, '隐私与安全', () {}),
          ],
        ),

        const SizedBox(height: 8),

        // 帮助与反馈
        _buildListSection(
          title: '帮助与反馈',
          items: [
            _buildListTile(Icons.help, '常见问题', () {}),
            _buildListTile(Icons.feedback, '意见反馈', () {}),
            _buildListTile(Icons.info, '关于我们', () {}),
            _buildListTile(Icons.update, '检查更新', () {}),
          ],
        ),

        const SizedBox(height: 8),

        // 退出登录按钮
        if (userProvider.isLoggedIn)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                userProvider.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '退出登录',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildListSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEFD1D0),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 0,
      onTap: onTap,
    );
  }

  void _showCheckInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('每日签到'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.card_giftcard, size: 48, color: Colors.amber),
                const SizedBox(height: 16),
                const Text('签到成功！获得10积分'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('确定'),
                ),
              ],
            ),
          ),
    );
  }
}
