import 'package:bloc/bloc.dart';
import 'package:chat_app/modules/chat_login/cubit/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ChatLoginCubit extends Cubit<ChatLoginStates>
{
  ChatLoginCubit():super(ChatLoginInitialState());
  @override

static ChatLoginCubit get(context) => BlocProvider.of(context);
  void userLogin({
    required String email,
    required String password,
  }
      ){
    emit(ChatLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      print(value.credential?.token);
      emit(ChatLoginSuccessState(value.user?.uid));
    }).catchError((onError){
      emit(ChatLoginErrorState(onError.toString()));
    });

  }

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility(){
    isPassword =! isPassword;
    suffix=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ChatChangePasswordVisibilityState());
  }
}