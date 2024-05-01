import 'package:chat_app/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/serach_user/search_screen.dart';
import '../../shared/styles/IconBroken.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class ChatLayout extends StatelessWidget {
  const ChatLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return BlocConsumer<ChatCubit,ChatStates>(
     builder:(context, state) {
       var cubit=ChatCubit.get(context);
     return Scaffold(
       appBar: AppBar(
         title:Text(
             cubit.titel[cubit.curent_index]),
         actions: [
           IconButton(onPressed: (){
           },
               icon:Icon(IconBroken.Notification)
           ),
           IconButton(onPressed: (){
             nevgitto(context, ChatSearchScreen());
           },
               icon:Icon(IconBroken.Search)
           ),
         ],
       ),
       body:cubit.bottomScreens[cubit.curent_index],
       bottomNavigationBar:BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
         elevation: 10,
         currentIndex: cubit.curent_index,
         onTap: (index){
               cubit.changeBottom(index);
         },
         items: const [
           BottomNavigationBarItem(
               icon: Icon(
                   IconBroken.Chat
               ),
             label: "Friends"
           ),
           BottomNavigationBarItem(
               icon: Icon(IconBroken.User1),
             label: "Groups"
           ),
           BottomNavigationBarItem(
               icon: Icon(IconBroken.Profile),
               label: "Profile"
           ),
         ],
         //  backgroundColor: Colors.cyan,
       ),
     );
    },
     listener:(context, state) {
     },
   );
  }
}
