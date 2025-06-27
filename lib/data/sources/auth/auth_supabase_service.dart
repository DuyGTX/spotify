import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';

abstract class AuthSupabaseService {
  Future<Either<String, String>> signup(CreateUserReq req);
  Future<Either<String, String>> signin(SigninUserReq req);
}

class AuthSupabaseServiceImpl extends AuthSupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<Either<String, String>> signup(CreateUserReq req) async {
    try {
      final response = await client.auth.signUp(
        email: req.email,
        password: req.password,
        data: {'full_name': req.fullName},
      );

      if (response.user != null) {
        return Right('Đăng ký thành công');
      } else {
        return Left('Đăng ký thất bại');
      }
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (_) {
      return Left('Có lỗi xảy ra');
    }
  }

  @override
  Future<Either<String, String>> signin(SigninUserReq req) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: req.email,
        password: req.password,
      );

      if (response.session != null) {
        return Right('Đăng nhập thành công');
      } else {
        return Left('Đăng nhập thất bại');
      }
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (_) {
      return Left('Lỗi không xác định');
    }
  }
}
