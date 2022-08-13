import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../providers/page_provider.dart';
import '../../theme.dart';
import '../widgets/reusable/done_button.dart';
import '../widgets/reusable/loading_button.dart';
import '../widgets/reusable/text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  late SharedPreferences loginData;

  bool _notVisible = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleLogin() async {
      setState(() {
        _loading = true;
      });

      if(await authProvider.login(email: emailController.text, password: passwordController.text)) {
        loginData = await SharedPreferences.getInstance();
        loginData.setString('tokenAdmin', authProvider.user!.token!);

        context.read<PageProvider>().currentIndex = 0;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authProvider.errorMessage
                // 'Gagal masuk! Email atau kata sandi salah',
              ),
              backgroundColor: alertColor,
              duration: const Duration(milliseconds: 700),
            )
        );
      }

      setState(() {
        _loading = false;
      });
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masuk',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4,),
          Text(
            'Masuk untuk kelola toko',
            style: secondaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 12,),
          Center(
            child: Image.asset('assets/login_icon.png', width: MediaQuery.of(context).size.width/2,),
          ),
          const SizedBox(height: 12,),
        ],
      );
    }

    Widget emailField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alamat email',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            controller: emailController,
            hintText: 'Masukkan alamat email Anda',
            prefixIcon: Icon(Icons.email, size: 20, color: secondaryColor,),
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi email Anda';
              } else if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget passwordField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata sandi',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            actionKeyboard: TextInputAction.done,
            maxLines: 1,
            controller: passwordController,
            hintText: 'Masukkan kata sandi',
            obscureText: _notVisible,
            prefixIcon: Icon(Icons.lock, size: 20, color: secondaryColor,),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _notVisible = !_notVisible;
                });
              },
              child: Icon(
                  _notVisible ? Icons.visibility_off : Icons.visibility,
                  size: 20
              )
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return 'Mohon isi kata sandi akun Anda';
              }
            },
          ),
        ],
      );
    }

    Widget forgotPass() {
      return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {  },
          child: Text(
            'Lupa kata sandi?',
            style: alertTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    Widget form() {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            emailField(),
            const SizedBox(height: 20,),
            passwordField(),
            forgotPass(),
            const SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: _loading
                  ? const LoadingButton(text: 'Memuat',)
                  : DoneButton(
                text: 'Masuk',
                onClick: () {
                  if(_formKey.currentState!.validate()) {
                    handleLogin();
                  }
                },
              ),
            ),
          ],
        )
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            header(),
            form(),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
