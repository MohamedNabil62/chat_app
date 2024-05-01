import 'package:chat_app/models/model_lastmasseg.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/chat_app/cubit/cubit.dart';
import '../../layout/chat_app/cubit/state.dart';
import '../../models/chat_user_model.dart';
import '../../shared/components/components.dart';
import '../chat_details/chat_details_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
      builder: (context, state) {
        if(ChatCubit.get(context).allUser.length==0)
        ChatCubit.get(context).getAllUser();
        if(ChatCubit.get(context).ch)
        for(int i=0;i<ChatCubit.get(context).allUser.length;i++)
        {
          ChatCubit.get(context).getLastMessageForChat(ChatCubit.get(context).allUser[i].uId);
          ChatCubit.get(context).ch=false;
        }
      return ConditionalBuilder(
        condition: ChatCubit.get(context).allUser.length>0,
        builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index){
              final allUsers = ChatCubit.get(context).allUser;
              final lastMessages = ChatCubit.get(context).lastMessage;

              if (index < allUsers.length && index < lastMessages.length) {
                return buildChatItem(context, allUsers[index], index, lastMessages[index]);
              } else {
                // Handle the case where the index is out of range
                // You can return a default item or handle it according to your needs
                return SizedBox(); // Returning an empty SizedBox as an example
              }
            },
            separatorBuilder: (context, index) => SizedBox(height: 1,),
            itemCount: ChatCubit.get(context).allUser.length
        ),
        fallback: (context) => Center(child: CircularProgressIndicator()),
      );
    }, listener:(context, state) {},
    );
  }
}

Widget buildChatItem(context,ChatUserModel model,index,LastMessageModel mo) {
  String lastMessage='start chat';
  print("-------------------------------------------------${index}");
  return InkWell(
  onTap: (){
    nevgitto(context, ChatDetailsScreen(model,index));
  },
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child:   Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoScreen(
                  imageUrl: "${model?.image}",
                  tag: 'photoTag', // Unique tag for the Hero transition
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius:25,
            backgroundImage: NetworkImage("${model?.image}"),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("${model?.name}",
            ),
            Text( mo != null ?  mo.text as String: lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
          ],),
        ),

      ],
    ),
  ),
);}