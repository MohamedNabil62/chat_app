import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:chat_app/shared/styles/IconBroken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
TextEditingController _search=TextEditingController();
var formkey=GlobalKey<FormState>();
class ChatGroupAddMemberScreen extends StatelessWidget {
  final String groupChatId, name;
  ChatGroupAddMemberScreen(this.groupChatId,this.name,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
      var model = ChatGroupCubit.get(context).modelAddUser;
     return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              ChatGroupCubit.get(context).allMembers=[];
             ChatGroupCubit.get(context).getGroupDetails(groupChatId);
              Navigator.pop(context);
            },
            icon: Icon(IconBroken.Arrow___Left_2),
          ),
          title: Text("Add Members"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
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
                  if(formkey.currentState!.validate())
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
                    ChatGroupCubit.get(context).onAddMembers(
                        groupChatId,  name,
                      ChatGroupCubit.get(context).allMembers[0].members
                    );
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(model?.cover as String),
                  ),
                  title: Text(model?.name as String),
                  subtitle: Text(model?.email as String),
                  trailing: Icon(IconBroken.Add_User,
                    size: 30,
                    color: myColor,
                  ),
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
