import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository _repository;

  SignInWithEmailUseCase(this._repository);

  Future<UserEntity?> execute(String email, String password) {
    return _repository.signInWithEmailAndPassword(email, password);
  }
}
