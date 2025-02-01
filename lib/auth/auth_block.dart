
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repositories.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await authRepository.signIn(event.email, event.password);
      emit(Authenticated(userCredential.user!));  
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

   void _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential? userCredential = await authRepository.signInWithGoogle();

      if (userCredential != null) {
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          print("Yeni kullanıcı! Firebase'e kaydedildi.");
        }
        
        emit(Authenticated(userCredential.user!));
      } else {
        emit(AuthError("Google ile giriş iptal edildi."));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await authRepository.signUp(event.kullaniciAdi,event.email, event.password);
      emit(Authenticated(userCredential.user!)); 
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated()); 
    } catch (e) {
      emit(AuthError(e.toString())); 
    }
  }

  void _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async{
    emit(AuthLoading());
    try{
      await authRepository.ResetPassword(event.email);
      emit(PasswordResetEmailSent());
    }catch (e){
      emit(PasswordResetError(e.toString()));
    }
  }
  
}