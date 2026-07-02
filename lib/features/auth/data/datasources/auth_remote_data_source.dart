import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password, String name);
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
