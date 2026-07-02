import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository _repository;

  SignUpWithEmailUseCase(this._repository);

  Future<UserEntity?> execute(String email, String password, String name) {
    return _repository.signUpWithEmailAndPassword(email, password, name);
  }
}
