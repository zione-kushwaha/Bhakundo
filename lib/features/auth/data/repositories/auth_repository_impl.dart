import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<UserEntity?> getCurrentUser() => _remoteDataSource.getCurrentUser();

  @override
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password) =>
      _remoteDataSource.signInWithEmailAndPassword(email, password);

  @override
  Future<UserEntity?> signUpWithEmailAndPassword(String email, String password, String name) =>
      _remoteDataSource.signUpWithEmailAndPassword(email, password, name);

  @override
  Future<UserEntity?> signInWithGoogle() => _remoteDataSource.signInWithGoogle();

  @override
  Future<void> signOut() => _remoteDataSource.signOut();
}
