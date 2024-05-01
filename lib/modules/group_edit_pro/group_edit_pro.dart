import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/chat_app/chat_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/IconBroken.dart';
import '../../shared/styles/colors.dart';
import '../chat_group/chat_group_screen.dart';
var namecontroller=TextEditingController();
var formkey=GlobalKey<FormState>();
bool t=true;
class GroupEditScreen extends StatefulWidget {
  final String name, groupId,groupImage,AdmainUid;
  const GroupEditScreen(this.name,this.groupId,this.groupImage,this.AdmainUid,{Key? key}) : super(key: key);

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
      var coverImage=ChatGroupCubit.get(context).coverImage;
      if(t)
      namecontroller.text=widget.name??'';
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
                 ChatGroupCubit.get(context).getAvailableGroups();
                 Navigator.pop(context);
             // navigtorAndFinish(context, ChatLayout());
            },
            icon: Icon(
                IconBroken.Arrow___Left_2
            ),
          ),
          title: Text("Edit Group"),
          actions: [
            TextButton(onPressed:(){
              ChatGroupCubit.get(context).updateUser(name: namecontroller.text, gropUid: widget.groupId,adminUid:widget.AdmainUid,groupImage: widget.groupImage);
            setState(() {
              t=false;
              namecontroller.text=namecontroller.text;
            });
            },
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text("update".toUpperCase(),style: TextStyle(
                    color: myColor
                ),),
              ),

            )
          ],
        ),
        /*
        defaultAppBar(
            context: context,
            text: "Edit Group",
            action: [
              defaultTextButten(
                  function: (){
                    ChatGroupCubit.get(context).updateUser(name: namecontroller.text, gropUid: groupId,adminUid:AdmainUid,groupImage: groupImage);
                  },
                  text:'update'
              ),
              SizedBox(
                width: 15,)
            ]
        ),
        */
        body: SingleChildScrollView(
          child: Column(children: [
            if(state is ChatAllGetGroupsLoadingState)
              LinearProgressIndicator(),
            Container(
              height: 190,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius:60,
                          backgroundImage:coverImage==null? NetworkImage("${widget.groupImage}") as ImageProvider<Object>?:FileImage(coverImage),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: myColor,
                        child: IconButton(onPressed: (){
                          ChatGroupCubit.get(context).getCoverImage();
                        },
                          icon:Icon(
                            IconBroken.Camera,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if(ChatGroupCubit.get(context).coverImage!=null)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    if(ChatGroupCubit.get(context).coverImage!=null)
                      Expanded(
                        child: Column(
                          children: [
                            defaultbutton(
                                function: (){
                                  ChatGroupCubit.get(context).uploadingCoverGroupImage(name: namecontroller.text,
                                  adminUid: widget.AdmainUid,
                                    gropUid: widget.groupId,
                                  );
                                },
                                text: 'upload group image',

                                colo: myColor
                            ),
                            if(state is ChatGroupUpdateLoadingState)
                              SizedBox(
                                height: 5,
                              ),
                            if(state is ChatGroupUpdateLoadingState)
                              LinearProgressIndicator()
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            if(ChatGroupCubit.get(context).coverImage!=null)
              SizedBox(
                height: 4,
              ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: namecontroller,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("name must not be empty");
                        }
                        return null;
                      },
                      decoration: InputDecoration(prefixIcon: const Icon(IconBroken.User),
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0))

                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],),
        ),
      );
    }, listener: (context, state) {

    },);
  }
}
