import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/modules/chat_group_details/chat_group_Screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/chat_app/cubit/cubit.dart';
import '../../layout/chat_app/cubit/state.dart';
import '../../models/chat_user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/IconBroken.dart';
import '../chat_creat_group/creat_group.dart';
import '../chat_details/chat_details_screen.dart';
import '../group_chats/group_chat_room.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class ChatGroupScreen extends StatelessWidget {
  const ChatGroupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
     // ChatGroupCubit.get(context).allGroups=[];
      //ChatGroupCubit.get(context).getAvailableGroups();
      return BlocConsumer<ChatGroupCubit,ChatGroupStates>(
        builder: (context, state) {
          return Scaffold(
            body: ConditionalBuilder(
              condition: ChatGroupCubit.get(context).allGroups.length>=0,
              builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildChatItem(context,ChatGroupCubit.get(context).allGroups[index]),
                  separatorBuilder: (context, index) =>SizedBox(height: 1,),
                  itemCount: ChatGroupCubit.get(context).allGroups.length
              ),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatCreateGroupScreen(),
                  ),
                );
              },
              child: Icon(IconBroken.User1),
            ),
          );
        }, listener:(context, state) {},
      );
    },);
  }
}

Widget buildChatItem(context, ChatGroupModel model) {
  final gImage = model.groupImage ?? "";
  print('image url----------------${model.groupImage}');
  return InkWell(
  onTap: () {
    final adminUid = model.adminUid ?? "";
    final groupImage = model.groupImage ?? "https://img.freepik.com/free-vector/group-therapy-illustration_74855-5516.jpg?w=740&t=st=1702244962~exp=1702245562~hmac=2d39d89c32b9011252c2fe5b98878c9d092cdc2cddf7e661ec902bc89374a9b3";
    if (model.id != null && model.name != null) {
      nevgitto(
        context,
        ChatGroupDetailsScreen(
          model.id as String,
          model.name as String,
          adminUid as String,
          groupImage as String,
        ),
      );
    } else {
      print("error");
    }
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoScreen(
                  imageUrl: "${model.groupImage ?? "https://img.freepik.com/free-vector/group-therapy-illustration_74855-5516.jpg?w=740&t=st=1702244962~exp=1702245562~hmac=2d39d89c32b9011252c2fe5b98878c9d092cdc2cddf7e661ec902bc89374a9b3" as String}",
                  tag: 'photoTag', // Unique tag for the Hero transition
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage("${model.groupImage ?? "https://img.freepik.com/free-vector/group-therapy-illustration_74855-5516.jpg?w=740&t=st=1702244962~exp=1702245562~hmac=2d39d89c32b9011252c2fe5b98878c9d092cdc2cddf7e661ec902bc89374a9b3"}"),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${model.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (model.lastMessage != null)
                Text(
                  "${model.lastMessage!.receiveruId}: ${model.lastMessage!.text}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  ),
);
}


