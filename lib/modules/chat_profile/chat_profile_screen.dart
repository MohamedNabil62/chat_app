import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_login/cubit/cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/styles/IconBroken.dart';
import '../../layout/chat_app/cubit/cubit.dart';
import '../../layout/chat_app/cubit/state.dart';
import '../../shared/components/components.dart';
import '../chat_login/chat_login_screen.dart';
import '../edit_profile/edit_profile.dart';

class ChatProfileScreen extends StatelessWidget {
  const ChatProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        builder: (context, state) {
          var usermodel=ChatCubit.get(context).mode;
          var profileImage=ChatCubit.get(context).profileImage;
          var coverImage=ChatCubit.get(context).coverImage;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 190,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight:  Radius.circular(4)
                            ),
                            image: DecorationImage(
                              image:coverImage == null ? NetworkImage("${usermodel?.cover}") as ImageProvider<Object> : FileImage(coverImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      InkWell(
                        onTap:() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoScreen(
                                imageUrl: "${usermodel?.image}",
                                tag: 'photoTag', // Unique tag for the Hero transition
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 64,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius:60,
                            backgroundImage: profileImage==null? NetworkImage("${usermodel?.image}") as ImageProvider<Object>?:FileImage(profileImage),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("${usermodel?.name}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text("${usermodel?.bio}",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                    color: Colors.black
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: (){
                          ChatCubit.get(context).allUser=[];
                          ChatGroupCubit.get(context).allGroups=[];
                          ChatCubit.get(context).profileImage=null;
                          ChatCubit.get(context).coverImage=null;
                          ChatGroupCubit.get(context).coverImage=null;
                          navigtorAndFinish(context, ChatLoginScreen());
                        },
                        child: const Text(
                            "Sign Out"
                        )
                    ),

                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                      onPressed: (){
                        nevgitto(context, EditProfileScreen());
                      },
                      child:Icon(
                        IconBroken.Edit,
                        size: 16,
                      )
                  ),
                ],),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
        listener:(context, state) {

        }
    );
  }
}
