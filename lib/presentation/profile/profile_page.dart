import 'package:flutter/material.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/setting/page/setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy user hiện tại từ Supabase Auth
    final user = Supabase.instance.client.auth.currentUser;

    // Thông tin user (nếu đã đăng nhập)
    final email = user?.email ?? 'Chưa đăng nhập';
    final fullName = user?.userMetadata?['full_name'] ?? 'Không rõ tên';

    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Hồ sơ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        action: Padding(
            padding: const EdgeInsets.only(right: 12), // Đẩy icon sang trái
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Cài đặt',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 70, color: AppColors.primary),
                const SizedBox(height: 20),
                Text(
                  fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
