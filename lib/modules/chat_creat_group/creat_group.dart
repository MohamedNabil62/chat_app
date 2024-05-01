import 'package:chat_app/layout/chat_app/cubit/cubit.dart';
import 'package:chat_app/layout/chat_app/cubit/state.dart';
import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/IconBroken.dart';
import '../../shared/styles/colors.dart';
import '../group_chats/group_chat_screen.dart';
var namecontroller=TextEditingController();
var formkey=GlobalKey<FormState>();
class ChatCreateGroupScreen extends StatelessWidget {
  const ChatCreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
       return Scaffold(
         appBar: AppBar(
           leading: IconButton(
             onPressed: (){
               Navigator.pop(context);
             },
             icon: Icon(
                 IconBroken.Arrow___Left_2
             ),
           ),
           title: const Text("Create Group"),
           titleSpacing: 0,
         ),
         body:Center(
           child: Form(
             key: formkey,
             child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       CircleAvatar(
                         radius: 50,
                         backgroundImage: NetworkImage("https://img.freepik.com/free-vector/group-therapy-illustration_74855-5516.jpg?w=740&t=st=1702244962~exp=1702245562~hmac=2d39d89c32b9011252c2fe5b98878c9d092cdc2cddf7e661ec902bc89374a9b3"),
                       ),
                     ],
                   ),
                   SizedBox(height: 30,),
                   Padding(
                     padding: EdgeInsets.only(left: 10,right: 10),
                     child: TextFormField(
                       controller: namecontroller,
                       keyboardType: TextInputType.name,
                       validator: (value) {
                         if (value!.isEmpty) {
                           return ("Group name must not be empty");
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                         labelText: "Group Name",
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(6)),
                       ),
                     ),
                   ),
                   SizedBox(height: 30,),
                   defaultbutton(function: (){
                     if(formkey.currentState!.validate())
                     {
                       // ChatGroupCubit.get(context).group.add(namecontroller.text);
                      ChatGroupCubit.get(context).createGroup(
                          name:namecontroller.text,
                          membersList: [],
                        mode: ChatCubit.get(context).mode
                      );

                       namecontroller.clear();
                     }
                   },
                     text: "create".toUpperCase(),
                     colo:myColor,
                     width: 150,
                   ),
                 ]),
           ),
         ),
       );
     },
       listener: (context, state) {
        //if(state is ChatCreateGroupSuccessState)
          //ChatGroupCubit.get(context).getAvailableGroups();
     },
     );

  }
}
