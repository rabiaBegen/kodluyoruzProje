// lib/main.dart

import 'package:dentzay/auth/auth_block.dart';
import 'package:dentzay/repositories/auth_repositories.dart';
import 'package:dentzay/screens/AuthScreen.dart';
import 'package:dentzay/screens/MenuScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  final authRepository = AuthRepository();

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  MyApp({required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider( 
      create: (context) => AuthBloc(authRepository: authRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
        routes: {
        '/login': (context) => AuthScreen(), 
        '/menu': (context) => MenuScreen(), 
        },
      ),
    );
  }
}
