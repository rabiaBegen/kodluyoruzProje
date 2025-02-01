

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // kullanıcı giriş fonk
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // kullanıcı kayıt fonk
  Future<UserCredential> signUp(String kullaniciAdi, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı adını Firebase profiline ekle
      await userCredential.user?.updateDisplayName(kullaniciAdi);

      return userCredential;
    } catch (e) {
      throw Exception('Kayıt başarısız: ${e.toString()}');
    }
  }

  // kullanıcı çıkış fonk
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Google ile giriş fonk
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google ile giriş hatası: $e');
      rethrow;
    }
  }

  // Şifre sıfırlama fonk
  Future<void> ResetPassword(String email) async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }catch (e){
      throw Exception('Şifre sıfırlama bağlantısı gönderilemedi: ${e.toString()}');
    }
  }
}
