import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<UserEntity?> execute() {
    return _repository.authStateChanges;
  }
}
