
import 'package:chat_app/layout/chat_app/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:chat_app/modules/chat_group_inf/chat_group_inf.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/shared/components/constants.dart';
import '../../models/group_model.dart';
import '../../models/message_model.dart';
import '../../shared/styles/IconBroken.dart';
import '../../shared/styles/colors.dart';
import '../group_chats/group_info.dart';
var messagecontroaer=TextEditingController();
final ScrollController _controller = ScrollController();
class ChatGroupDetailsScreen  extends StatelessWidget {
  final String groupChatId, groupName,adminUid,groupImage;
   ChatGroupDetailsScreen(
       this.groupChatId,
       this.groupName,
         this.adminUid,
       this.groupImage
       );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ChatGroupCubit.get(context).getMessage(groupChatId: groupChatId, receiveruId:uId);
      return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: (){
              //  ChatGroupCubit.get(context).allGroups=[];
                ChatGroupCubit.get(context).allMembers=[];
                ChatGroupCubit.get(context).getGroupDetails(groupChatId);
                ChatGroupCubit.get(context).getAvailableGroups();
                Navigator.pop(context);
              },
              child: Icon(
                  IconBroken.Arrow___Left_2
              ),
            ),
            titleSpacing: 0,
            title:  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius:20,
                  backgroundImage: NetworkImage("${groupImage}"),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text("${groupName}",
                    style: TextStyle(
                      //  height: 1.4
                        fontSize: 15
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    ChatGroupCubit.get(context).getGroupDetails(groupChatId);
                    nevgitto(context, ChatGroupInfScreen(groupName, groupChatId, adminUid,groupImage));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
          body: ConditionalBuilder(
            condition:ChatGroupCubit.get(context).message.length>=0,
            builder: (context) => Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    controller: _controller,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var message = ChatGroupCubit.get(context).message[index];
                      print(message.text);
                      //ChatGroupCubit.get(context).mode?.uId == message.senderuId
                      if (uId == message.senderuId)
                        return bluidMyMessage(message,context);
                      return bluidMessage(message,context);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemCount: ChatGroupCubit.get(context).message.length,
                  ),
                ),
                if(ChatGroupCubit.get(context).messageImageGroup!=null)
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 150,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image: FileImage(ChatGroupCubit.get(context).messageImageGroup!),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, right: 6),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: myColor,
                            child: IconButton(onPressed: () {
                              ChatGroupCubit.get(context).removeMessageImage();
                            },
                              icon: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,

                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color:Colors.grey[300]!
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: messagecontroaer,
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText: "type your message here...",
                              ),
                            ),
                          ),
                        ),

                        IconButton(onPressed: (){
                          ChatGroupCubit.get(context).getmassegeImage();
                        },
                            icon: Icon(
                                IconBroken.Image
                            )
                        ),
                        Container(
                          height: 50,
                          color: myColor,
                          child: MaterialButton(onPressed: (){
                            _controller.animateTo(
                              0,
                              duration: Duration(seconds:1),
                              curve: Curves.easeIn,
                            );
                         //   if(ChatCubit.get(context).messageImage ==null)
                              ChatGroupCubit.get(context).sendMessage(
                                nameSender: ChatCubit.get(context).mode?.name ,
                                groupChatId: groupChatId,
                                  datetime:DateTime.now().toString(),
                                  text:messagecontroaer.text,
                                context: context,
                                groupname: groupName
                              );
                            messagecontroaer.clear();
                            ChatGroupCubit.get(context).uploadMessageImage(
                              //  receiveruId: Model?.uId,
                              groupChatId: groupChatId,
                                datetime:DateTime.now().toString(),
                                text:messagecontroaer.text
                            );
                            ChatGroupCubit.get(context).removeMessageImage();


                          },
                            minWidth: 1,
                            child: Icon(
                              IconBroken.Send,
                              size: 16,
                              color: Colors.white,
                            ),

                          ),
                        )


                      ],
                    ),
                  ),
                )
              ],
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      }, listener: (context, state) {

      },);
    },);
  }
}
Widget bluidMessage(MessageModel message,context){
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(message.text !='')
            Padding(
              padding: const EdgeInsets.only(
                  right: 50
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0, // Adjust elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                            bottomEnd: Radius.circular(10),
                            topEnd: Radius.circular(10),
                            topStart: Radius.circular(10),
                          ),
                        ),
                        color: Colors.grey[400], // Adjust color as needed
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${message.receiveruId}",
                                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Colors.deepOrange
                                ),
                              ),
                              Text("${message.text} ",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if(message.image !=' ')
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                        image:NetworkImage("${message.image}")

                    ),
                  ),
                  if(message.text !='')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${message.text} "),
                    )
                ],
              ),
            ),
        ],),
    ),
  );}

Widget bluidMyMessage(MessageModel message,context) {
  print(message.image);
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if(message.text !='')
              Padding(
                padding: const EdgeInsets.only(
                  left: 50
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 0, // Adjust elevation as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.only(
                              bottomStart: Radius.circular(10),
                              topEnd: Radius.circular(10),
                              topStart: Radius.circular(10),
                            ),
                          ),
                          color: myColor.withOpacity(.2), // Adjust color as needed
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${message.receiveruId}",
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Colors.blue
                                  ),
                                ),
                                Text("${message.text} ",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            //image in
            if(message.image !=' ')
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                          height: 150,
                          width: 200,
                          fit: BoxFit.cover,
                          image:NetworkImage("${message.image}")

                      ),
                    ),
                    if(message.text !='')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${message.text} "),
                      )
                  ],
                ),
              )
            //  if(message.image !=' ')
          ],)
    ),
  );
}