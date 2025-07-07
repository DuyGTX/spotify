import 'package:flutter/material.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/data/sources/auth/user_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      avatarUrl = user?.userMetadata?['avatar_url'];
    });
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final url = await UserService.instance.uploadAvatar(context);
    if (url != null) {
      setState(() {
        avatarUrl = url;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật ảnh đại diện!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Chưa đăng nhập';
    final fullName = user?.userMetadata?['full_name'] ?? 'Không rõ tên';

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      appBar: BasicAppbar(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        title: Text(
          'Chỉnh Sửa Hồ Sơ',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        action: TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã lưu thông tin')),
            );
          },
          child: const Text(
            'Lưu',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar Section
            Container(
              width: double.infinity,
              color: isDark ? AppColors.darkGrey : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink[200],
                        ),
                        child: ClipOval(
                          child: avatarUrl != null
                              ? Image.network(avatarUrl!, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.pink[200],
                                  child: const Icon(
                                    Icons.pets,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _pickAvatar(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: isDark ? Colors.black : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Account Information Section
            Container(
              width: double.infinity,
              color: isDark ? AppColors.darkGrey : Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TÀI KHOẢN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  _buildInfoRow('Tên:', fullName, isDark),
                  const SizedBox(height: 20),

                  // Email Field
                  _buildInfoRow('Email:', email, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
