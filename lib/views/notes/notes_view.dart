import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes2/enums/menu_action.dart';
import 'package:mynotes2/services/auth_service.dart';
import 'package:mynotes2/services/cloud/cloud_note.dart';
import 'package:mynotes2/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes2/services/curd/notes_seervices.dart';
import 'package:mynotes2/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes2/utilities/dialogs/show_logout_dialog.dart';
import 'package:mynotes2/views/notes/notes_list.dart';

import '../../constants/routes.dart';


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

   late final FirebaseCloudStorage _notesService;

  String get userId=>AuthService.firebase().currentUser!.id;

  @override
  void initState() {
  _notesService=FirebaseCloudStorage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Notes'),
      actions: [
       IconButton(onPressed:(){
         Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
       }, icon: const Icon(Icons.add),
       ),
        PopupMenuButton<MenuAction>(onSelected: (value) async {
         switch(value){
           case MenuAction.logout:
            final shouldLogOut=await showLogoutDialog(context);
            if(shouldLogOut){
              if(mounted){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
              }else{
                return;
              }
            }
             break;
         }
        },
         itemBuilder: (context) {
         return const[
            PopupMenuItem<MenuAction>(
            value:MenuAction.logout,
            child:Text('Log out')
           )
         ];
         },
        )
      ],
      ),
      body:StreamBuilder(
        stream:_notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.active:
             if(snapshot.hasData){
              final allNotes=snapshot.data as Iterable<CloudNote>;
               return NotesListView(
                notes:allNotes,
                 onTap: (note) {
                     Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                      );

                   },
                    onDeleteNote: (note) async{
                     await _notesService.deleteNote(documentId: note.documentId);
                    },
               );
             }else{
              return const CircularProgressIndicator();
             }

             default:
             return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}
