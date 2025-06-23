// lib/core/usecase/usecase.dart

abstract class Usecase<Type, Params> {
  Future<Type> call({Params? params});
}
