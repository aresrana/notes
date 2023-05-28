import 'package:flutter/material.dart';
import 'package:mynotes2/services/auth_exceptions.dart';
import 'package:mynotes2/services/auth_service.dart';
import 'package:mynotes2/utilities/dialogs/show_error_dialog.dart';
import '../constants/routes.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
    
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
      appBar: AppBar(title:const Text('Register'),),
      body:Column(
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
                 await AuthService.firebase().createUser(email: email, password: password);
                 await AuthService.firebase().sendEmailVerification();
                 if(mounted){
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                 }else{
                  return;
                 }
                 }on WeakPasswordAuthException{
                  await showErrorDialog(context, 'weak password');
                 }on EmailAlreadyInUseAuthException{
                   await showErrorDialog(context, 'email already in use');
                 }on InvalidEmailAuthException{
                  await showErrorDialog(context, 'invalid email');
                 }on GenericAuthException{
                    await showErrorDialog(context,'User cannot be created');
                 }
              },child:const Text('Register')),
              TextButton(onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, child: const Text('Already registered? sign in  here'),
              ),
          ],
        )
    );
  }
}
