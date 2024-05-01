import 'package:bloc/bloc.dart';
import 'package:chat_app/modules/chat_register/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/chat_user_model.dart';
class ChatRegisterCubit extends Cubit<ChatRegisterStates>
{
  ChatRegisterCubit():super(ChatRegisterInitialState());

static ChatRegisterCubit get(context) => BlocProvider.of(context);
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }
      ){
    emit(ChatRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
     // print(value.credential?.token);
      print(value.user?.uid);
      print(value.credential?.token);
      userCreate(
          name: name,
          email: email,
          uId: value.user!.uid,
          phone: phone
      );
    }).catchError((onError){
      print(onError.toString());
      emit(ChatRegisterErrorState(onError.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String uId,
    required String phone,
  }){
    ChatUserModel Model=ChatUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      image: 'https://img.freepik.com/free-photo/view-3d-kids-with-lanterns-night_23-2150710036.jpg?t=st=1700906826~exp=1700910426~hmac=4f5399932000bbe840c5d560241597764bff87d1baa861e3f32f3a4092c134c2&w=740',
      bio: 'write your bio...',
      cover:'https://img.freepik.com/free-photo/view-3d-kids-with-lanterns-night_23-2150710036.jpg?t=st=1700906826~exp=1700910426~hmac=4f5399932000bbe840c5d560241597764bff87d1baa861e3f32f3a4092c134c2&w=740',
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(Model.toMap()).then((value){
          emit(ChatRegisterSuccessCreateUserState(
             uId
          ));
    }).catchError((onError){
      print(onError.toString());
      emit(ChatRegisterErrorCreateUserState(onError));
    });
  }

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility(){
    isPassword =! isPassword;
    suffix=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ChatRegisterchangePasswordVisibilityState());
  }


}