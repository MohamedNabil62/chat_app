//import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/layout/chat_app/chat_layout.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../layout/chat_app/cubit/cubit.dart';
import '../../../layout/chat_app/cubit/state.dart';
import '../../chat_group/cubit/cubit.dart';
import '../../chat_profile/chat_profile_screen.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

   CreateGroup({ required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocConsumer<ChatGroupCubit,ChatGroupStates>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Group Name"),
        ),
        body: isLoading
            ? Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            SizedBox(
              height: size.height / 10,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _groupName,
                  decoration: InputDecoration(
                    hintText: "Enter Group Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            ElevatedButton(
              onPressed: (){
                ChatGroupCubit.get(context).createGroup(
                  name: _groupName.text, membersList: widget.membersList,
                  mode: ChatCubit.get(context).mode
                );
              },
              child: Text("Create Group"),
            ),
          ],
        ),
      );
    },
      listener:(context, state) {

    },);
  }
}


//