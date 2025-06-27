import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/sources/auth/auth_supabase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';

import 'package:spotify/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninUserReq req) async {
    return await sl<AuthSupabaseService>().signin(req);
  }

  @override
  Future<Either> signup(CreateUserReq req) async {
    return await sl<AuthSupabaseService>().signup(req);
  }
}