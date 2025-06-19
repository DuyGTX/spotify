import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either<String, String>> signup(CreateUserReq createUserReq);
  Future<Either<String, String>> signin(SigninUserReq signinUserReq);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async {
    // Kiểm tra nếu email hoặc mật khẩu trống
    if (signinUserReq.email.isEmpty) {
      return Left('Email không được bỏ trống');
    }
    if (signinUserReq.password.isEmpty) {
      return Left('Mật khẩu không được bỏ trống');
    }

    try {
      // Đăng nhập với Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );
      return Right('Đăng nhập thành công');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Không tìm thấy email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Mật khẩu không chính xác.';
      }
      return Left(message);
    }
  }

  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );
      return Right('Đăng ký thành công');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu. Vui lòng thử lại với mật khẩu mạnh hơn.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email đã được sử dụng.';
      } else {
        message = 'Đăng ký thất bại: ${e.message}';
      }
      return Left(message);
    }
  }
}
