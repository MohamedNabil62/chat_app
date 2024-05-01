import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/styles/IconBroken.dart';
import '../../layout/chat_app/cubit/cubit.dart';
import '../../layout/chat_app/cubit/state.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
var namecontroller=TextEditingController();
var biocontroller=TextEditingController();
var phonecontroller=TextEditingController();
var formkey=GlobalKey<FormState>();

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
      builder:(context, state) {
        var usermodel=ChatCubit.get(context).mode;
        var profileImage=ChatCubit.get(context).profileImage;
        var coverImage=ChatCubit.get(context).coverImage;
        namecontroller.text=usermodel!.name!;
        biocontroller.text=usermodel.bio!;
        phonecontroller.text=usermodel.phone!;
        return  Scaffold(
          appBar: defaultAppBar(
              context: context,
              text: "Edit Profile",
              action: [
                defaultTextButten(
                    function: (){
                      ChatCubit.get(context).updateUser(name: namecontroller.text, bio: biocontroller.text, phone: phonecontroller.text);
                    },
                    text:'update'
                ),
                SizedBox(
                  width: 15,)
              ]
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              if(state is ChatGetUserLoadingState)
                LinearProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 190,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
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
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0,right: 6),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: myColor,
                              child: IconButton(onPressed: (){
                                ChatCubit.get(context).getCoverImage();
                              },
                                icon:Icon(
                                  IconBroken.Camera,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius:60,
                            backgroundImage:profileImage==null? NetworkImage("${usermodel?.image}") as ImageProvider<Object>?:FileImage(profileImage),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: myColor,
                          child: IconButton(onPressed: (){
                            ChatCubit.get(context).getProfileImage();
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
              if(ChatCubit.get(context).profileImage!=null||ChatCubit.get(context).coverImage!=null)
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      if(ChatCubit.get(context).profileImage!=null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultbutton(
                                  function: (){
                                    ChatCubit.get(context).uploadingProfileImage(name: namecontroller.text, bio: biocontroller.text, phone: phonecontroller.text,);
                                  },
                                  text: 'upload profile',
                                  colo: myColor
                              ),
                              if(state is ChatUpdateLoadingState)
                                SizedBox(
                                  height: 5,
                                ),
                              if(state is ChatUpdateLoadingState)
                                LinearProgressIndicator()
                            ],
                          ),
                        ),
                      SizedBox(
                        width: 5,
                      ),
                      if(ChatCubit.get(context).coverImage!=null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultbutton(
                                  function: (){
                                    ChatCubit.get(context).uploadingCoverImage(name: namecontroller.text, bio: biocontroller.text, phone: phonecontroller.text);
                                  },
                                  text: 'upload cover',

                                  colo: myColor
                              ),
                              if(state is ChatUpdateLoadingState)
                                SizedBox(
                                  height: 5,
                                ),
                              if(state is ChatUpdateLoadingState)
                                LinearProgressIndicator()
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              if(ChatCubit.get(context).profileImage!=null||ChatCubit.get(context).coverImage!=null)
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
                      TextFormField(
                        controller: biocontroller,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("bio must not be empty");
                          }
                          return null;
                        },
                        decoration: InputDecoration(prefixIcon: const Icon(IconBroken.Info_Circle),
                            labelText: "Bio",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phonecontroller,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("phone must not be empty");
                          }
                          return null;
                        },
                        decoration: InputDecoration(prefixIcon: const Icon(IconBroken.Call),
                            labelText: "Phone",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))

                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],),
          ),
        );
      },
      listener:(context, state) {},
    );
  }
}
