import 'package:chat_app/layout/chat_app/chat_layout.dart';
import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:chat_app/modules/group_edit_pro/group_edit_pro.dart';
import 'package:chat_app/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/IconBroken.dart';
import '../chat_details/chat_details_screen.dart';
import '../chat_group/chat_group_screen.dart';
import '../chatgroup_add_member/group_add_member.dart';
class ChatGroupInfScreen extends StatelessWidget {
  final String groupId, groupName,AdmainUid,groupImage;
   ChatGroupInfScreen(this.groupName,this.groupId,this.AdmainUid,this.groupImage,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
     // ChatGroupCubit.get(context).allMembers=[];
      ChatGroupCubit.get(context).getGroupDetails(groupId);
      return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                  icon: Icon(
                      IconBroken.Arrow___Left_2
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0,bottom: 20),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage('${groupImage}'),
                          ),
                        ),
                        Text("${groupName}",
                          style:TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 30,),
                        if(AdmainUid==uId)
                        OutlinedButton(
                            onPressed: (){
                              nevgitto(context, GroupEditScreen(
                                  groupName,
                                  groupId,
                                  groupImage,
                                  AdmainUid
                              ));
                            },
                            child:Icon(
                              IconBroken.Edit,
                              size: 16,
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("${ChatGroupCubit.get(context).lengh} Members",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30,),
                  if(AdmainUid==uId)
                  InkWell(
                    onTap: (){
                      nevgitto(context,  ChatGroupAddMemberScreen(
                        groupId,
                        groupName,

                      ));
                    },
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 12,),
                        IconButton(onPressed: (){
                        }, icon: Icon(IconBroken.Add_User,
                          color: myColor,
                          weight:30,
                        )
                        ),
                        SizedBox(width: 15,),
                        Text("Add Mambers",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ConditionalBuilder(
                            condition:ChatGroupCubit.get(context).allMembers.isNotEmpty &&
                                ChatGroupCubit.get(context).allMembers[0].members!.length > 0,
                            builder: (context) => ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final members = ChatGroupCubit.get(context).allMembers[0].members;
                                  if (members != null && index < members.length) {
                                    return buildChatItem(context, members[index], index);
                                  } else {
                                    return SizedBox(); // or any other widget to handle the case where the index is out of bounds
                                  }
                                },
                                separatorBuilder: (context, index) => SizedBox(height: 5,),
                                itemCount:ChatGroupCubit.get(context).lengh!
                            ),
                            fallback: (context) => Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ChatGroupCubit.get(context).onLeaveGroup(groupChatId: groupId, membersList: ChatGroupCubit.get(context).allMembers[0].members);
                            },
                            child: Row(
                              children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.1),
                                child: Icon(IconBroken.Logout),
                              ),
                                SizedBox(width: 15,),
                                Text("Exit group",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.red
                                ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  /*
                  Expanded(
                    child: ConditionalBuilder(
                      condition:true,
                      builder: (context) => ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildChatItem(context,ChatGroupCubit.get(context).allMembers[0].members![index],index),
                          separatorBuilder: (context, index) => SizedBox(height: 5,),
                          itemCount: ChatGroupCubit.get(context).allMembers[0].members!.length
                      ),
                      fallback: (context) => Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  */

                ],),
            )
        );
      }, listener: (context, state) {
         if(state is ChatDeleteMemberSuccessState)
           {
             ChatGroupCubit.get(context).getAvailableGroups();
             navigtorAndFinish(context,ChatLayout());
           }
      },);
    },);
  }
}
Widget buildChatItem(context, dynamic model,int index) => InkWell(
  onTap: () {
    nevgitto(context, ChatDetailsScreen(ChatUserModel.forjson(model) ,index));
  },
  child:index==0? ListTile(
    leading: CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(model['image'] as String),
    ),
    title: Text(model['name'] as String),
    subtitle: Text(model['email'] as String),
    trailing: Text("Admain",
    style: TextStyle(
      color: Colors.green
    ),
    ),
  ):ListTile(
    leading: CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(model['image'] as String),
    ),
    title: Text(model['name'] as String),
    subtitle: Text(model['email'] as String),
  ),
);
