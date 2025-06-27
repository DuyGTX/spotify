import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/presentation/auth/pages/signin.dart';
import 'package:spotify/service_locator.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signinText(context),
      appBar: BasicAppbar(
        title: Image.asset(
          AppImages.logo,
          height: 40,
          width: 150,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(height: 50),
            _fullNameField(context),
            const SizedBox(height: 20),
            _emailField(context),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 80),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = _fullName.text.trim();
                  final email = _email.text.trim();
                  final password = _password.text.trim();

                  // Kiểm tra dữ liệu nhập
                  if (name.isEmpty) {
                    _showWarning('Tên người dùng không được bỏ trống');
                    return;
                  }

                  if (email.isEmpty) {
                    _showWarning('Email không được bỏ trống');
                    return;
                  }

                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(email)) {
                    _showWarning('Email không hợp lệ');
                    return;
                  }

                  if (password.isEmpty) {
                    _showWarning('Mật khẩu không được bỏ trống');
                    return;
                  }

                  if (password.length < 6) {
                    _showWarning('Mật khẩu phải có ít nhất 6 ký tự');
                    return;
                  }

                  var result = await sl<SignupUseCase>().call(
                    params: CreateUserReq(
                      fullName: name,
                      email: email,
                      password: password,
                    ),
                  );

                  result.fold(
                    (l) {
                      if (l.toString().contains('already') || l.toString().contains('in-use')) {
                        _showWarning('Email đã tồn tại');
                      } else if (l.toString().contains('weak-password')) {
                        _showWarning('Mật khẩu quá yếu, hãy thử lại với mật khẩu mạnh hơn');
                      } else {
                        _showWarning(l.toString());
                      }
                    },
                    (r) {
                      _showSuccess('Đăng ký thành công! Vui lòng đăng nhập.');
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SigninPage()),
                          (route) => false,
                        );
                      });
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'TẠO TÀI KHOẢN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Đăng ký',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
  return TextField(
    controller: _fullName,
    decoration: const InputDecoration(
      hintText: 'Tên người dùng',
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)), // 👈 giảm xuống 5
  ),
    ).applyDefaults(
      Theme.of(context).inputDecorationTheme,
    ),
  );
}


  Widget _emailField(BuildContext context) {
  return TextField(
    controller: _email,
    decoration: const InputDecoration(
      hintText: 'Email',
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)), // 👈 giảm xuống 5
  ),
      
    ).applyDefaults(
      Theme.of(context).inputDecorationTheme,
    ),
  );
}


  Widget _passwordField(BuildContext context) {
  return TextField(
    controller: _password,
    obscureText: _obscure,
    decoration: InputDecoration(
      hintText: 'Mật khẩu',
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)), // 👈 giảm xuống 5
  ),
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    ).applyDefaults(
      Theme.of(context).inputDecorationTheme,
    ),
  );
}


  Widget _signinText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Bạn đã có tài khoản?',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SigninPage()),
            );
          },
          child: const Text(
            'Đăng nhập',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF288CE9), 
            ),
          ),
        ),
      ],
    ),
  );
}



  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFF5F5F5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFF5F5F5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
