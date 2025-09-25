import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // تسجيل الدخول
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // إنشاء حساب جديد
  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // المستخدم الحالي
  User? get currentUser => _auth.currentUser;
}
