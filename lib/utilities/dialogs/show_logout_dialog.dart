import 'package:flutter/material.dart';
import 'package:mynotes2/utilities/dialogs/generic_dialog.dart';

Future<bool>showLogoutDialog(BuildContext context){
  return showGenericDialog(
    context: context, 
    title: 'Sign out', 
    content: 'Are you sure you want to log out?', 
    optionsBuilder: ()=>{
      'cancel':false,
      'ok':true,
    }
    ).then((value) => value??false);
}