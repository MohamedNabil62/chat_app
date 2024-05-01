import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat_app/layout/chat_app/cubit/state.dart';
import 'package:chat_app/modules/chat_group/chat_group_screen.dart';
import 'package:chat_app/modules/chat_profile/chat_profile_screen.dart';
import 'package:chat_app/shared/network/remote/dio_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import '../../../models/chat_user_model.dart';
import '../../../models/message_model.dart';
import '../../../models/model_lastmasseg.dart';
import '../../../modules/chats/chat_Screen.dart';
import '../../../modules/group_chats/group_chat_screen.dart';
import '../../../modules/group_chats/group_info.dart';
import '../../../modules/tastgroup/pages/home_page.dart';
import '../../../shared/components/constants.dart';
import 'package:http/http.dart' as http;

import '../../../shared/network/end_points.dart';
class ChatCubit extends Cubit<ChatStates>
{
  ChatCubit():super(ChatInitialState());

  static ChatCubit get(context) =>BlocProvider.of(context);

  int curent_index=0;
  List<Widget> bottomScreens=[
    ChatScreen(),
    ChatGroupScreen(),//GroupChatHomeScreen(),
    ChatProfileScreen()
  ];
  List<String>titel=[
    'Chats User',
    'Chats Group',
    'Profile'
  ];
  void changeBottom(int index) {
    curent_index = index;
    emit(ChatChangeBottemNaveState());
  }
  ChatUserModel? mode;
  void getUserData()
  {
    emit(ChatGetUserLoadingState());
    FirebaseFirestore.instance.
    collection('users').
    doc(uId).
    get().then((value){
      mode=ChatUserModel.forjson(value.data() as Map<String, dynamic>);

      emit(ChatGetUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ChatGetUserErrorState(error));
    });
  }


  File? profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage() async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null)
    {
      profileImage=File(pickedFile.path);
      emit(ChatGetProfileImageSuccessState());
    }else
    {
      print("No image selected");
      emit(ChatGetProfileImageErrorState());
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null)
    {
      coverImage=File(pickedFile.path);
      emit(ChatGetCoverImageSuccessState());
    }else
    {
      print("No image selected");
      emit(ChatGetCoverImageErrorState());
    }
  }
  void uploadingProfileImage({
    @required String? name,
    @required String? bio,
    @required String? phone,
  }){
    emit(ChatUpdateLoadingState());
    firebase_storage
        .FirebaseStorage.instance
        .ref()//enter
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")//name image
        .putFile(profileImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, bio: bio, phone: phone,profile: value);
        // emit(ChatUploadProfileImageSuccessState());
      }).catchError((error){
        emit(ChatUploadProfileImageErrorState());
      });
    }).catchError((error){
      emit(ChatUploadProfileImageErrorState());
    });
  }

  void uploadingCoverImage({
    @required String? name,
    @required String? bio,
    @required String? phone,
  } ){
    emit(ChatUpdateLoadingState());
    firebase_storage
        .FirebaseStorage.instance
        .ref()//enter
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")//name image
        .putFile(coverImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, bio: bio, phone: phone,cover: value);
        emit(ChatUploadCoverImageSuccessState());
      }).catchError((error){
        emit(ChatUploadCoverImageErrorState());
      });
    }).catchError((error){
      emit(ChatUploadCoverImageErrorState());
    });
  }

  void updateUser({
    @required String? name,
    @required String? bio,
    @required String? phone,
    String?profile,
    String?cover,
  }){
    ChatUserModel Model=ChatUserModel(
      name: name,
      phone: phone,
      isEmailVerified: false,
      image:profile??mode?.image,
      bio: bio,
      cover:cover??mode?.cover,
      email: mode?.email,
      uId: mode?.uId,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(mode?.uId)
        .update(Model.toMap()).then((value){
      getUserData();
    }).catchError((error){
      emit(ChatUpdateErrorState());
    });
  }
  List<ChatUserModel> allUser = [];
  Set<String> addedUserIds = Set<String>();

  void getAllUser() {
    allUser.clear();

    FirebaseFirestore.instance.collection("users").get().then((value) {
      final List<Future<void>> fetchMessagesFutures = [];

      for (var userDoc in value.docs) {
        String userId = userDoc.data()['uId'];
        if (userId != mode?.uId && !addedUserIds.contains(userId)) {
          // Check if there are messages exchanged between the current user and this user
          final fetchMessagesFuture = checkIfChatted(userId).then((chatted) {
            if (chatted) {
              allUser.add(ChatUserModel.forjson(userDoc.data()));
              addedUserIds.add(userId); // Mark the user as added
            }
          });
          fetchMessagesFutures.add(fetchMessagesFuture);
        }
      }

      // Wait for all the fetchMessagesFutures to complete before emitting success state
      Future.wait(fetchMessagesFutures).then((_) {
        emit(ChatAllGetUserSuccessState());
      }).catchError((error) {
        emit(ChatAllGetUserErrorState(error));
      });
    }).catchError((error) {
      emit(ChatAllGetUserErrorState(error));
    });
  }


  Future<bool> checkIfChatted(String userId) async {
    var messages = await FirebaseFirestore.instance
        .collection('users')
        .doc(mode?.uId)
        .collection("chats")
        .doc(userId)
        .collection("messages")
        .get();

    return messages.docs.isNotEmpty;
  }

  File? messageImage;
  Future<void> getmassegeImage() async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null)
    {
      messageImage=File(pickedFile.path);
      emit(ChatMessageImageSuccessState());
    }else
    {
      print("No image selected");
      emit(ChatMessageImageErrorState());
    }
  }

  void uploadMessageImage({
    @required  String? receiveruId,
    @required String? datetime,
    @required  String? text,
  } ){
    firebase_storage
        .FirebaseStorage.instance
        .ref()//enter
        .child("users/${Uri.file(messageImage!.path).pathSegments.last}")//name image
        .putFile(messageImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        sendMessage(receiveruId: receiveruId, datetime: datetime, text: text,messageImage: value);
        emit(ChatSendMessageSuccessState());
      }).catchError((error){
        emit(ChatSendMessageErrorState(error));
      });
    }).catchError((error){
      emit(ChatSendMessageErrorState(error));
    });
  }

  void sendNotification({String? text, String? name}) async{
    String? recipientToken = await FirebaseMessaging.instance.getToken();
    emit(YourLoadingState());
    Diohelper.postData(url: NOTF,data:{
      'to': '/topics/${name}',
      'notification': {
        'title': 'you have a message from $name',
        'body': '$text',
        'sound': 'app_sound.wav',
      },
      'android': {
        'priority': 'high',
        'notification': {
          'notification_priority': 'PRIORITY_MAX',
          'sound': 'app_sound.wav',
          'default_sound': true,
          'default_vibrate_timings': true,
          'default_light_settings': true,
        },
      },
      'data': {
        'type': 'order',
        'id': '87',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    })
        .then((value) {
          emit(YourSuccessState());
    })
        .catchError((error){
      if (error is DioError) {
        // Handle DioError here
        // For example, you can access the response and error details
        final response = error.response;
        final errorMessage = error.message;
        // Handle the error accordingly
        emit(YourErrorState(errorMessage!));
      } else {
        // Handle other types of errors
        emit(YourErrorState(error.toString()));
      }
    });
  }
  void sendMessage({
    @required  String? receiveruId,
    @required String? datetime,
    @required  String? text,
    @required  String? name,
    @required  int? index,
    String?messageImage,
  })
  {
    //sender
    MessageModel messageModel=MessageModel(text: text,
      datetime: datetime,
      receiveruId: receiveruId,
      senderuId: mode?.uId,
      image: messageImage??' ',
    );
    LastMessageModel lastMessageModel=LastMessageModel(
      text: text,
      datetime: datetime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(mode?.uId)
        .collection("chats")
        .doc(receiveruId)
        .collection("messages")
        .add(messageModel.toMap()).then((value){
      FirebaseFirestore.instance
          .collection('users')
          .doc(mode?.uId)
          .collection("chats")
          .doc(receiveruId)
      .set(lastMessageModel.toMap());
     // getLastMessageForChat(receiveruId);
      FirebaseMessaging.instance.subscribeToTopic('${name}');
      //lastMessage[index as int].text=text;
      sendNotification(text:text,name:mode?.name);
      emit(ChatSendMessageSuccessState());
    } ).catchError((error){
      emit(ChatSendMessageErrorState(error));
    });
    //receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiveruId)
        .collection("chats")
        .doc(mode?.uId)
        .collection("messages")
        .add(messageModel.toMap()).then((value){
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiveruId)
          .collection("chats")
          .doc(mode?.uId)
          .set(lastMessageModel.toMap());
      emit(ChatSendMessageSuccessState());
    } ).catchError((error){
      emit(ChatSendMessageErrorState(error));
    });

  }

  List<MessageModel>message=[];
  void getMessage({
    @required  String? receiveruId,
  })
  {
    emit(ChatGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(mode?.uId)
        .collection("chats")
        .doc(receiveruId)
        .collection("messages")
        .orderBy("datetime",descending: true)
        .snapshots() //list of future
        .listen((event) {
      message=[];
      event.docs.forEach((element) {
        message.add(MessageModel.forjson(element.data()));
      });
      emit(ChatGetMessageSuccessState());
    });
  }

  void removeMessageImage(){
    messageImage=null as File?;
    emit(ChatRemoveMessageImageState());
  }
  StreamSubscription<DocumentSnapshot>? onlineStatusSubscription;

  void getOnlineStatus(String? uId) {
    onlineStatusSubscription?.cancel();
    onlineStatusSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .snapshots()
        .listen((event) {
      bool? online = event.get('online');
      print(online );
      emit(ChatGetOnlineStatusState(online));
    });
  }
  List<LastMessageModel> lastMessage=[
  ];
  bool ch=true;
  /*
  void getLastMessageForChat(@required String? chatId)  {
    emit(ChatLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(mode?.uId)
        .collection("chats")
        .doc(chatId)
           .get(). then((value){
             if(lastMessage.length>1)
               lastMessage.clear();
             lastMessage.add(LastMessageModel.forjson(value.data() as Map<String, dynamic>));
          print(lastMessage[1].text);
      emit(ChatSuccessState());
    }).catchError((error){emit(ChatErrorState());});
  }

   */
  void getLastMessageForChat(@required String? chatId) {
    emit(ChatLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(mode?.uId)
        .collection("chats")
        .doc(chatId)
        .snapshots() // Listen for real-time updates
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null) {
        lastMessage.clear();
          lastMessage.add(LastMessageModel.forjson(data as Map<String, dynamic>));
          print(lastMessage[0].text); // Corrected index to 0
          emit(ChatSuccessState());
        } else {
          emit(ChatErrorState()); // Document not found
        }
      }
    }, onError: (error) {
      emit(ChatErrorState());
    });
  }

}