import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  UserModel? _mapFirebaseUser(fb.User? user, {String? displayName}) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: displayName ?? user.displayName ?? 'Futsal Player',
      photoUrl: user.photoURL ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
      phoneNumber: user.phoneNumber ?? '',
    );
  }

  @override
  Stream<UserModel?> get authStateChanges => _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return _mapFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        }
        final model = _mapFirebaseUser(user);
        if (model != null) {
          await _firestore.collection('users').doc(user.uid).set(model.toMap());
        }
        return model;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        final model = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: name,
          photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
          phoneNumber: '',
        );
        await _firestore.collection('users').doc(user.uid).set(model.toMap());
        return model;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final fb.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final fb.User? user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        }

        final model = _mapFirebaseUser(user, displayName: googleUser.displayName);
        if (model != null) {
          await _firestore.collection('users').doc(user.uid).set(model.toMap());
        }
        return model;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
