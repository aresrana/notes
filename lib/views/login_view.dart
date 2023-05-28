
import 'package:flutter/material.dart';
import 'package:mynotes2/services/auth_exceptions.dart';
import 'package:mynotes2/services/auth_service.dart';
import 'package:mynotes2/utilities/dialogs/show_error_dialog.dart';
import '../constants/routes.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
    TextEditingController? _email;
    TextEditingController? _password;
  
  @override
  void initState() {
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email?.dispose();
    _password?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Login'),),
      body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Enter your email'),
              enableSuggestions:false,
              autocorrect:false,
              keyboardType: TextInputType.emailAddress,
              controller:_email,
            ),
            TextField(
              controller:_password,
              decoration: const InputDecoration(hintText: 'Enter your password'),
              enableSuggestions:false,
              autocorrect: false,
              obscureText:true,
            ),
               TextButton(onPressed: () async{
                  final email=_email?.text??'';
                  final password=_password?.text??'';
                  try{
                  await AuthService.firebase().login(email: email, password: password);
                    final user=AuthService.firebase().currentUser;
                    if(user?.isEmailVerified??false){
                      if(mounted){
                        Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                      }
                    }else{
                      if(mounted){
                        Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                      }
                    }
                  } on UserNotFoundAuthException{
                      await showErrorDialog(context, 'user not found');
                  }on WrongPassWordAuthException{
                    await showErrorDialog(context, 'wrong password');
                  }on GenericAuthException{
                       await showErrorDialog(context, 'Cannot log in');
                  }
                  
              },child:const Text('Login')),
              TextButton(onPressed:() {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }, child: const Text('Not registered yet? Register here'))
          ],
        )
    );
  }
}
