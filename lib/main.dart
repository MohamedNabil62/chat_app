// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:chat_app/layout/chat_app/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:chat_app/modules/on-borading/on-boarding.dart';
import 'package:chat_app/shared/bloc_observre.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:chat_app/shared/network/remote/dio_helper.dart';
import 'package:chat_app/shared/styles/theme-data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'layout/chat_app/cubit/state.dart';
import 'layout/chat_app/chat_layout.dart';
import 'modules/chat_login/chat_login_screen.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print("on Background message");
  print( message.data.toString());
  showToast(text: "on Background message", state: ToastState.SUCCESS);
}
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
/*
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCjCqDCDoMLT52XGn5SDwlKA0KP7AHQmcM",
        authDomain: "chatapp-abcd5.firebaseapp.com",
        projectId: "chatapp-abcd5",
        storageBucket: "chatapp-abcd5.appspot.com",
        messagingSenderId: "992599618301",
        appId: "1:992599618301:web:a1d38a0e6336a8511bc494"
    ),
  );
 */
  token=await FirebaseMessaging.instance.getToken(); //ده token ثابت لما بتعمل لوجن على اي جهاز وبتستخدمه في الاشعارات وبيبعت لكل  المستخدمين
  print("this is token");
  print(token);
  print("this is token");

  //whene app opened and i need send notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("on message");
    print(message.data.toString());
    //showToast(text: "on message", state: ToastState.SUCCESS);
  });

//لما يكون الابلكيشن مش مقفول بس في الباك جراوند ويبعت نوتفكيشن بيعرفني انا دوست عليها ولا لا
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("on message open app");
    print( event.data.toString());
    showToast(text: "on message open app", state: ToastState.SUCCESS);
  });

  //whene app opened and i need send notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  Diohelper.init();
  await CacheHelper.init();
  bool? isDark=CacheHelper.getData(kay: 'mode');
  bool? OnBorading=CacheHelper.getData(kay: 'onborading');
  uId=CacheHelper.getData(kay: "uId");
  Widget? widget;

  if(OnBorading != null) {
    if (uId != null) {
      widget = ChatLayout();
    } else {
      widget = ChatLoginScreen();
    }
}else {
    widget = onBorading();
  }
  runApp(MyApp(widget));
}
class MyApp extends StatelessWidget
{
   Widget Start_Widget;
 MyApp(this.Start_Widget,{super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:[
          BlocProvider(
            create: (context) => ChatCubit()..getUserData(),
          ),
          BlocProvider(
            create: (context) => ChatGroupCubit()..getAvailableGroups(),
          ),
        ] ,
        child:BlocConsumer<ChatCubit,ChatStates>(
          listener: (context, state) {

          },
          builder: (context, state) {
            return  MaterialApp(debugShowCheckedModeBanner: false,
                theme: lightmode,
                darkTheme: darkmode,
                themeMode: ThemeMode.light,
                home: Directionality(textDirection: TextDirection.ltr,
                    child:Start_Widget
                )
            );
          },
        )
    );


  }
}