import 'package:flutter/material.dart';
import 'package:mynotes2/constants/routes.dart';
import 'package:mynotes2/services/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification'),),
      body:Column(
        children: [
          const Text("We've sent you an email, please check that"),
          const Text("If you haven't got that email, please verify your email"),
          TextButton(onPressed: () async{
             AuthService.firebase().sendEmailVerification();
          },child:const Text('Send me an email'),
          ),
          TextButton(onPressed: () async {
           await AuthService.firebase().logOut();
          if(mounted){
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);  
          }else{
            return;
          }
          }, child: const Text('Restart'),
          ),
        ],
      )
    );
  }
}