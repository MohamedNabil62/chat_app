import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/styles/IconBroken.dart';
import '../../layout/chat_app/cubit/cubit.dart';
import '../../layout/chat_app/cubit/state.dart';
import '../../models/chat_user_model.dart';
import '../../models/message_model.dart';
import '../../shared/styles/colors.dart';
var messagecontroaer=TextEditingController();
//final _controller = ScrollController();
class ChatDetailsScreen extends StatefulWidget {
  ChatUserModel? Model;
  int? x;
  ChatDetailsScreen(
  this.Model,
      this.x,
  );

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> with WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();
@override
void initState() {
  WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }
  @override
  void setStat(String status) async {

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
      'status':status
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if(state==AppLifecycleState.resumed){
               setStat('online');
    }else
      {

      }
  }
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ChatCubit.get(context).getMessage(receiveruId: widget.Model?.uId);
     // ChatCubit.get(context).getOnlineStatus(Model?.uId);
      return BlocConsumer<ChatCubit,ChatStates>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                  IconBroken.Arrow___Left_2
              ),
            ),
            titleSpacing: 0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius:20,
                  backgroundImage: NetworkImage("${widget.Model?.image}"),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text("${widget.Model?.name}",
                    style: TextStyle(
                      //  height: 1.4
                        fontSize: 15
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ConditionalBuilder(
            condition:ChatCubit.get(context).message.length>=0,
            builder: (context) => Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    reverse: true,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      var message = ChatCubit.get(context).message[index];
                      print(message.text);
                      if (ChatCubit.get(context).mode?.uId == message.senderuId)
                        return bluidMyMessage(message);
                      return bluidMessage(message);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemCount: ChatCubit.get(context).message.length,
                  ),
                ),
                if(ChatCubit.get(context).messageImage!=null)
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
                                image: FileImage(ChatCubit.get(context).messageImage!),
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
                              ChatCubit.get(context).removeMessageImage();
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
                              onFieldSubmitted: (value) {
                                _controller.animateTo(
                                  0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                               // messagecontroaer.clear();
                                if(ChatCubit.get(context).messageImage ==null) {
                                  ChatCubit.get(context).sendMessage(
                                      receiveruId: widget.Model?.uId,
                                      datetime: DateTime.now().toString(),
                                      text: messagecontroaer.text
                                  );
                                  messagecontroaer.clear();
                                }
                                ChatCubit.get(context).uploadMessageImage(
                                    receiveruId: widget.Model?.uId,
                                    datetime:DateTime.now().toString(),
                                    text:messagecontroaer.text
                                );
                                ChatCubit.get(context).removeMessageImage();
                              },
                              controller: messagecontroaer,
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText: "type your message here...",
                              ),
                            ),
                          ),
                        ),
                        IconButton(onPressed: (){
                          ChatCubit.get(context).getmassegeImage();
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
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                            // messagecontroaer.clear();
                            if(ChatCubit.get(context).messageImage ==null) {
                              ChatCubit.get(context).sendMessage(
                                  receiveruId: widget.Model?.uId,
                                  datetime: DateTime.now().toString(),
                                  text: messagecontroaer.text,
                                index: widget.x,
                                name:widget.Model?.name,
                              );
                              messagecontroaer.clear();
                            }
                            ChatCubit.get(context).uploadMessageImage(
                                receiveruId: widget.Model?.uId,
                                datetime:DateTime.now().toString(),
                                text:messagecontroaer.text,
                            );
                            ChatCubit.get(context).removeMessageImage();
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
      },
        listener:(context, state) {},);
    },
    );
  }
}

Widget bluidMessage(MessageModel message,){
  return Align(
  alignment: AlignmentDirectional.centerStart,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 80.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                if(message.image !=' ')
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      height: 150,
                      width: 200,
                      fit: BoxFit.cover,
                      image: NetworkImage("${message.image}"),
                    ),
                  ),
                if(message.text!.length > 0&&message.text!.isNotEmpty )
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0,left: 8,bottom: 8),
                    child: Text("${message.text} ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
    ],),
  ),
);}

Widget bluidMyMessage(MessageModel message) {
  print(message.image);
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: Container(
                decoration: BoxDecoration(
                   color: Color(0xFF4CAF50),
                  borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10),
                    topEnd: Radius.circular(10),
                    topStart: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    if(message.image !=' ')
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          height: 150,
                          width: 200,
                          fit: BoxFit.cover,
                          image: NetworkImage("${message.image}"),
                        ),
                      ),
                    if(message.text!.length > 0&&message.text!.isNotEmpty )
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 8,bottom: 8),
                        child: Text("${message.text} ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      )
                  ],
                ),
              ),
            ),
              /*
              Container(
                    decoration: BoxDecoration(
                     // color: myColor.withOpacity(.2),
                      borderRadius: BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(10),
                        topEnd: Radius.circular(10),
                        topStart: Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10
                    ),
                    child:   Card(
                      color: myColor.withOpacity(.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          if(message.image !=' ')
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image(
                                  height: 150,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  image:NetworkImage("${message.image}")

                              ),
                            ),
                          if(message.text!.length > 0&&message.text!.isNotEmpty )
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${message.text} "),
                            )
                        ],
                      ),
                    )
                ),

               */
            //image in
            //  if(message.image !=' ')

          ],)
    ),
  );
}