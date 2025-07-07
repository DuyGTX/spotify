// lib/services/user_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final UserService instance = UserService._();

  UserService._();

  Future<String?> uploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      return null;
    }

    final storage = Supabase.instance.client.storage.from('avatars');
    final filePath = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Xoá file cũ nếu muốn (có thể không cần)
    // await storage.remove(['${user.id}/avatar.jpg']);

    // Upload ảnh mới
    await storage.upload(filePath, file);
    final publicUrl = storage.getPublicUrl(filePath);

    // Cập nhật avatar_url trong metadata user
    await Supabase.instance.client.auth.updateUser(UserAttributes(
      data: {
        'avatar_url': publicUrl,
      },
    ));

    return publicUrl;
  }
}
