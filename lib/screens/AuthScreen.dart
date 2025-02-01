import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_block.dart';
import '../auth/auth_event.dart';
import '../auth/auth_state.dart';
import 'MenuScreen.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final TextEditingController signUpKullaniciAdiController=TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signInKullaniciAdiController=TextEditingController();
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signInEmailController.dispose();
    signInPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
           borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50), // Sol alt köşe oval
              bottomRight: Radius.circular(50), // Sağ alt köşe oval
            ),
          child: AppBar(
            backgroundColor: Color(0xff61BE7B),
            title: Align(
              alignment: Alignment.center,
              child: Text('SES VER',
              style: TextStyle(
                color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold
              ),),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xff61BE7B),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black54,
                      tabs: [
                        Tab(text: 'Kayıt Ol'),
                        Tab(text: 'Giriş'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SignUpTab(
                            kullaniciAdiController:signInKullaniciAdiController ,
                            emailController: signUpEmailController,
                            passwordController: signUpPasswordController,
                          ),
                          SignInTab(
                            kullaniciAdiController:signInKullaniciAdiController ,
                            emailController: signInEmailController,
                            passwordController: signInPasswordController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpTab extends StatelessWidget {
  final TextEditingController kullaniciAdiController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignUpTab({required this.kullaniciAdiController,required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Yeni Hesap Oluştur",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Aşağıdaki formu doldurarak başlayalım.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 20),
          TextField(
            controller: kullaniciAdiController,
            decoration: InputDecoration(
              labelText: 'Kullanıcı Adı',
              prefixIcon: Icon(Icons.person,color: Color(0xff61BE7B),),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), // Odaklanınca kenar rengi
            ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email,color: Color(0xff61BE7B),),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), // Odaklanınca kenar rengi
            ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Şifre',
              prefixIcon: Icon(Icons.lock,color: Color(0xff61BE7B),),
              suffixIcon: Icon(Icons.visibility_off),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), 
            ),
            ),
            obscureText: true,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignUpRequested(
                  kullaniciAdi: kullaniciAdiController.text,
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Color(0xff61BE7B),width: 2),
              ),
              backgroundColor:  Colors.white,
            ),
            child: Text(
              'Kayıt Ol',
              style: TextStyle(fontSize: 16, color: Color(0xff61BE7B)),
            ),
          ),
          SizedBox(height: 15),
          Text('Veya bu şekilde kayıt yapınız!',
              style: TextStyle(fontSize: 14)),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(GoogleSignInRequested());
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: const Color(0xff61BE7B), width: 2)),
              backgroundColor: Colors.white,
            ),
            child: Text('Continue with Google',
                style: TextStyle(
                    color: const Color(0xff61BE7B),
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class SignInTab extends StatelessWidget {
  final TextEditingController kullaniciAdiController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignInTab({required this.kullaniciAdiController,required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hoşgeldiniz",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Hesabınıza giriş yapabilmek için aşağıdaki bilgileri doldurun.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email,color: Color(0xff61BE7B),),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), // Odaklanınca kenar rengi
              borderRadius: BorderRadius.circular(12),
            ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Şifre',
              prefixIcon: Icon(Icons.lock,color: Color(0xff61BE7B),),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              suffixIcon: Icon(Icons.visibility_off),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), // Odaklanınca kenar rengi
              borderRadius: BorderRadius.circular(12),
            ),
            ),
            obscureText: true,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignInRequested(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side:BorderSide(color: Color(0xff61BE7B),width: 2)
              ),
              backgroundColor:  Colors.white,
            ),
            child: Text(
              'Giriş',
              style: TextStyle(fontSize: 16, color: Color(0xff61BE7B)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController email_Controller =
                        TextEditingController();

                    return AlertDialog(
                      title: Text('Şifre Sıfırlama'),
                      content: TextField(
                        controller: email_Controller,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email,color:  Color(0xff61BE7B),),
                          border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'İptal',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              final email = email_Controller.text;
                              context
                                  .read<AuthBloc>()
                                  .add(ResetPasswordRequested(email: email, password: ''));
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const  Color(0xff61BE7B),
                            ),
                            child: Text('Gönder',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ],
                    );
                  });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color:  Color(0xff61BE7B),width: 2)
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Şifremi Unuttum',
              style: TextStyle(fontSize: 16, color:  Color(0xff61BE7B)),
            ),
          ),
          SizedBox(height: 15),
          Text('Veya bu şekilde giriş yapınız!',
              style: TextStyle(fontSize: 14)),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(GoogleSignInRequested());
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: const  Color(0xff61BE7B), width: 2)),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Continue with Google',
              style: TextStyle(
                  fontSize: 16, color:  Color(0xff61BE7B)),
            ),
          ),
        ],
      ),
    ));
  }
}
