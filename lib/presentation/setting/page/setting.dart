import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/auth/pages/signup_or_siginin.dart';
import 'package:spotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/setting/page/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class MenuItem {
  final String title;
  final VoidCallback onTap;
  

    
  
  MenuItem({required this.title, required this.onTap});
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Get current theme mode from the app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isDarkMode = Theme.of(context).brightness == Brightness.dark;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.grey[100],
      appBar: BasicAppbar(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        
        title: Text(
          'Cài Đặt',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // App Info Section
                _buildAppInfoCard(),
                
                const SizedBox(height: 16),
                
                // Admin Profile Section
                _buildAdminProfileCard(isDark),
                
                const SizedBox(height: 24),
                
                // Account Section
                _buildSectionTitle('TÀI KHOẢN'),
                const SizedBox(height: 12),
                _buildMenuGroup([
                  MenuItem(title: 'Thay đổi email', onTap: () {}),
                  MenuItem(title: 'Đổi mật khẩu', onTap: () {}),
                  MenuItem(title: 'Xóa tài khoản', onTap: () {}),
                  MenuItem(title: 'Thông báo', onTap: () {}),
                ], isDark),
                
                const SizedBox(height: 24),
                
                // Application Section
                _buildSectionTitle('ỨNG DỤNG'),
                const SizedBox(height: 12),
                _buildDarkModeToggle(context),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
          
          // Logout Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Handle logout
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // App Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/app_icon.png', // Replace with your app icon
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // App Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nghe nhạc không giới hạn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bắt đầu dùng thử MIỄN PHÍ',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '7 ngày',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Unlock Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Mở Khóa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProfileCard(bool isDark) { 
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Chưa đăng nhập';
    final fullName = user?.userMetadata?['full_name'] ?? 'Không rõ tên';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const UserProfilePage(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[300],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/cat_avatar.png', // Replace with your avatar
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 25,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Profile Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[400] : Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[400] : Colors.black54,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMenuGroup(List<MenuItem> items, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? const Radius.circular(12) : Radius.zero,
                bottom: isLast ? const Radius.circular(12) : Radius.zero,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: isLast ? null : Border(
                    bottom: BorderSide(
                      color: (isDark ? Colors.grey[700] : Colors.grey)!.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

 Widget _buildDarkModeToggle(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[900] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: isDark ? Colors.white : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isDark ? 'Chế độ tối' : 'Chế độ sáng',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (value) {
                context.read<ThemeCubit>().updateTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _toggleTheme(bool isDark) {
    // This is where you would implement theme switching logic
    // You might use Provider, Bloc, or other state management
    // For example:
    // Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    
    // For now, just show a snackbar as demonstration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDark ? 'Đã chuyển sang chế độ tối' : 'Đã chuyển sang chế độ sáng',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
    void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                // Đăng xuất user khỏi Supabase backend
                await Supabase.instance.client.auth.signOut();

                // Điều hướng về trang đăng nhập/đăng ký và xóa toàn bộ stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupOrSighinPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),

          ],
        );
      },
    );
  }
}


// Usage example:
// In your main app or routing:
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => const SettingsPage()),
// );