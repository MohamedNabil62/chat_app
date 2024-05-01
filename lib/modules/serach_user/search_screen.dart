import 'package:chat_app/layout/chat_app/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:chat_app/shared/styles/IconBroken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/chat_app/chat_layout.dart';
import '../../models/chat_user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../chat_details/chat_details_screen.dart';
import '../chats/chat_Screen.dart';
TextEditingController _search=TextEditingController();
var formSearchkey=GlobalKey<FormState>();
class ChatSearchScreen extends StatelessWidget {
  ChatSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
      var model = ChatGroupCubit.get(context).modelAddUser;
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
            //  ChatCubit.get(context).getAllUser();
              //ChatCubit.get(context).allUser.add(ChatGroupCubit.get(context).modelAddUser as ChatUserModel);
             // ChatCubit.get(context).allUser=[];
               navigtorAndFinish(context, ChatLayout());
            //  Navigator.pop(context);
            },
            icon: Icon(IconBroken.Arrow___Left_2),
          ),
          title: Text("Select contact"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formSearchkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height:  20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                    controller: _search,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("user name must not be empty");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "User Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                defaultbutton(function: (){
                  if(formSearchkey.currentState!.validate())
                  {
                    ChatGroupCubit.get(context).onSearch(_search.text);

                    _search.clear();
                  }
                },
                  text: " Search",
                  colo:myColor,
                  width: 150,
                ),
                ChatGroupCubit.get(context).modelAddUser != null
                    ? ListTile(
                  onTap:(){
                  nevgitto(context, ChatDetailsScreen(ChatGroupCubit.get(context).modelAddUser,ChatCubit.get(context).lastMessage.length));
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(model?.cover as String),
                  ),
                  title: Text(model?.name as String),
                  subtitle: Text(model?.email as String),
                )
                    : SizedBox(),
                SizedBox(height: 30,),

              ],
            ),
          ),
        ),
      );
    }, listener: (context, state) {
    },);
  }
}
