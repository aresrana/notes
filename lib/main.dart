import 'package:flutter/material.dart';
import 'package:mynotes2/services/auth_service.dart';
import 'package:mynotes2/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes2/views/login_view.dart';
import 'package:mynotes2/views/notes/create_update_note_view.dart';
import 'package:mynotes2/views/notes/notes_view.dart';
import 'package:mynotes2/views/register_view.dart';
import 'package:mynotes2/views/verify_email_view.dart';
import 'constants/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
     await AuthService.firebase().initialize();
  runApp( MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home:const HomePage(),
     routes:{
       loginRoute:(context) => const LoginView(),
       registerRoute:(context)=>const RegisterView(),
       notesRoute:(context)=>const NotesView(),
       verifyEmailRoute:(context)=>const VerifyEmailView(),
       createOrUpdateNoteRoute:(context)=>const CreateUpdateNoteView(),
     }
    ));
  
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.done:
              final user=AuthService.firebase().currentUser;
               if(user!=null){
                if(user.isEmailVerified){
                  return const NotesView();
                }else{
                  return const VerifyEmailView();
                }
               }else{
                return const LoginView();
               }
                default:
                return const CircularProgressIndicator();
            }
          
          },
      
      );
  }
}

