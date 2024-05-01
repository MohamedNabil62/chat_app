import 'dart:io';
import 'package:chat_app/layout/chat_app/cubit/cubit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app/modules/chat_group/cubit/state.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../models/chat_user_model.dart';
import '../../../models/group_model.dart';
import '../../../models/message_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';
class ChatGroupCubit extends Cubit<ChatGroupStates>{
  ChatGroupCubit(): super(ChatCreateGroupInitialState());
  List <String>group=[];
  static ChatGroupCubit get(context) => BlocProvider.of(context);
  void createGroup(
  {
    required String name,
    required List<Map<String, dynamic>> membersList,
    required ChatUserModel? mode,
    }
      ) {
    membersList.add(mode?.toMap() as Map<String, dynamic>);
    String groupId = Uuid().v1();
    emit(ChatCreateGroupLoadingState());

    ChatGroupModel model=ChatGroupModel(
      id: groupId,
      name: name,
      members: membersList,
      adminUid: uId,
      groupImage: 'https://img.freepik.com/free-vector/group-therapy-illustration_74855-5516.jpg?w=740&t=st=1702244962~exp=1702245562~hmac=2d39d89c32b9011252c2fe5b98878c9d092cdc2cddf7e661ec902bc89374a9b3'
    );
     FirebaseFirestore.instance.collection('groups').doc(groupId).set(
      model.toMap()
    ).then((value) {
      emit(ChatCreateGroupSuccessState());
       for (int i = 0; i <= membersList.length; i++) {
        // String uid = membersList[i]['uid'];
         FirebaseFirestore.instance
             .collection('users')
             .doc(uId)
             .collection('groups')
             .doc(groupId)
             .set(model.tomap()).then((value) {
               emit(ChatMembersGroupSuccessState());
         }).catchError((error){
           emit(ChatMembersCreateGroupErrorState(error));
         });
       }
      FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .add({
        "text": "${FirebaseAuth.instance.currentUser!.displayName} Created This Group.",
        "type": "notify",
      }).then((value) {
        emit(ChatGroupMessegeSuccessState());
      }).catchError((error){
        emit(ChatGroupMessegeErrorState(error));
      });
     }).catchError((error){
       print(error.toString());
       emit(ChatCreateGroupErrorState(error));
     });
  }


  List<ChatGroupModel> allGroups = [];
  void getAvailableGroups() {
    allGroups = [];
    emit(ChatAllGetGroupsLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('groups')
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      final List<Future<void>> fetchMessagesFutures = [];
      allGroups.clear();
      for (var groupDoc in snapshot.docs) {
        Map<String, dynamic>? data = groupDoc.data() as Map<String, dynamic>?;

        // Check if data is not null before creating the ChatGroupModel instance
        if (data != null) {
          ChatGroupModel group = ChatGroupModel.fromJson(data);
          print('data----------------${groupDoc.data()}');
          // Fetch the last message for each group
          final fetchMessagesFuture = FirebaseFirestore.instance
              .collection('groups')
              .doc(group.id)
              .collection('chats')
              .orderBy('datetime', descending: true)
              .limit(1)
              .get()
              .then((messages) {
            if (messages.docs.isNotEmpty) {
              group.lastMessage = MessageModel.forjson(messages.docs[0].data());
            }
          });
          fetchMessagesFutures.add(fetchMessagesFuture);

          allGroups.add(group);
        }
      }

      // Wait for all the fetchMessagesFutures to complete before emitting success state
      await Future.wait(fetchMessagesFutures);

      // Sort allGroups based on the datetime of the last message
      allGroups.sort((a, b) {
        if (a.lastMessage != null && b.lastMessage != null) {
          return b.lastMessage!.datetime!.compareTo(a.lastMessage!.datetime!);
        } else {
          // Handle cases where one or both groups have no messages
          return 0;
        }
      });

      emit(ChatAllGetGroupsSuccessState());
    }, onError: (error) {
      emit(ChatAllGetGroupsErrorState(error));
    });
  }
  void sendNotification({String? text, String? name,String? namegr}) async{
    String? recipientToken = await FirebaseMessaging.instance.getToken();
    emit(YourLoadingStateG());
    Diohelper.postData(url: NOTF,data:{
      'to': '/topics/${name}',
      'notification': {
        'title': 'New message from $name  in your group ${namegr}',
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
      emit(YourSuccessStateG());
    })
        .catchError((error){
      if (error is DioError) {
        // Handle DioError here
        // For example, you can access the response and error details
        final response = error.response;
        final errorMessage = error.message;
        // Handle the error accordingly
        emit(YourErrorStateG(errorMessage!));
      } else {
        // Handle other types of errors
        emit(YourErrorStateG(error.toString()));
      }
    });
  }
  void sendMessage({
    @required String? groupChatId,
    @required String? datetime,
    @required  String? text,
    @required String? nameSender,
    String?messageImage,
    @required  String? groupname,
    context
  })
  {
    //sender
    MessageModel messageModel=MessageModel(text: text,
      receiveruId:nameSender,
      datetime: datetime,
      senderuId: uId,
      image: messageImage??' ',
    );
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupChatId)
        .collection('chats')
        .add(messageModel.toMap()).then((value){
          print("this is sender-----------${nameSender} \n");
          print("this is name----------${ChatCubit.get(context).mode?.name}");
      FirebaseMessaging.instance.subscribeToTopic('${ChatCubit.get(context).mode?.name}');
      //lastMessage[index as int].text=text;
      sendNotification(text:text,name:ChatCubit.get(context).mode?.name,namegr: groupname);
      emit(ChatGroupSendMessageSuccessState());
    } ).catchError((error){
      emit(ChatGroupSendMessageErrorState(error));
    });
  }
  List<MessageModel>message=[];
  void getMessage({
    @required String? groupChatId,
    @required  String? receiveruId,
  })
  {
    emit(ChatGroupGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupChatId)
        .collection('chats')
        .orderBy("datetime",descending: true)
        .snapshots() //list of future
        .listen((event) {
      message=[];
      event.docs.forEach((element) {
        message.add(MessageModel.forjson(element.data()));
      });
      emit(ChatGroupGetMessageSuccessState());
    });
  }
  ImagePicker picker = ImagePicker();
  File? messageImageGroup;
  Future<void> getmassegeImage() async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null)
    {
      messageImageGroup=File(pickedFile.path) ;
      emit(ChatGroupMessageImageSuccessState());
    }else
    {
      print("No image selected");
      emit(ChatGroupMessageImageErrorState());
    }
  }

  void uploadMessageImage({
    @required  String? groupChatId,
    @required String? datetime,
    @required  String? text,
  } ){
    firebase_storage
        .FirebaseStorage.instance
        .ref()//enter
        .child("users/${Uri.file(messageImageGroup!.path).pathSegments.last}")//name image
        .putFile(messageImageGroup!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        sendMessage(groupChatId: groupChatId, datetime: datetime, text: text,messageImage: value);
      }).catchError((error){
        emit(ChatGetDownloadURLMessageImageErrorState(error));
      });
    }).catchError((error){
      emit(ChatPutMessageImageErrorState(error));
    });
  }
  void removeMessageImage(){
    messageImageGroup=null as File?;
    emit(ChatGroupRemoveMessageImageState());
  }
  ChatUserModel? modelAddUser;
  void onSearch(
      @required String? _search
      )  {
    emit(ChatSearchLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: _search)
        .get()
        .then((value) {
   modelAddUser=ChatUserModel.forjson(value.docs[0].data());
        //userMap = value.docs[0].data();
      print(modelAddUser);
      emit(ChatSearchSuccessState());
    }).catchError((error){
      emit(ChatSearchErrorState(error));
    }
    );
  }

  void onAddMembers(
      @required String? groupChatId,
      @required String? nameGroup,
      @required List<Map<String, dynamic>>? membersList,
      )  {
    if (membersList?.any((member) => member['uId'] == modelAddUser?.uId) ?? false) {
      emit(ChatAddMemberErrorState('Member already exists in the group'));
      return;
    }
    membersList?.add(modelAddUser?.toMap() as Map<String, dynamic>);
    emit(ChatAddMemberLoadingState());
     FirebaseFirestore.instance.collection('groups').doc(groupChatId).update({
      "members": membersList,
    }).then((value) {
       FirebaseFirestore.instance
           .collection('users')
           .doc(modelAddUser?.uId)
           .collection('groups')
           .doc(groupChatId)
           .set({"name": nameGroup, "id":groupChatId}).then((value) {
             emit(ChatAddMemberSuccessState());
       }).catchError((error){
         emit(ChatAddMemberErrorState(error));
       });
     }).catchError((error){
       emit(ChatAddMemberGroupErrorState(error));
     });

  }
  void onLeaveGroup({
    @required String? groupChatId,
    @required List<Map<String, dynamic>>? membersList,
  }) {
    emit(ChatLeaveMemberLoadingState());

    for (int i = 0; i < membersList!.length; i++) {
      if (membersList[i]['uId'] == FirebaseAuth.instance.currentUser!.uid) {
        membersList.removeAt(i);
      }
    }

    FirebaseFirestore.instance.collection('groups').doc(groupChatId).update({
      "members": membersList,
    }).then((value) {
      // Update the state here to reflect the change in user's groups
      emit(ChatLeaveMemberSuccessState());
    }).catchError((error) {
      emit(ChatLeaveMemberErrorState(error));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('groups')
        .doc(groupChatId)
        .delete()
        .then((value) {
      // Update the state here to reflect the change in user's groups
      emit(ChatDeleteMemberSuccessState());
    }).catchError((error) {
      emit(ChatLeaveMemberGroupErrorState(error));
    });
  }


  int? lengh=0;
  List<ChatGroupModel>allMembers=[];
  void getGroupDetails(
      @required String? groupId,
      ) {
    allMembers=[];
    emit(ChatGetMemberLoadingState());
     FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get()
         .then((value) {
       allMembers.add(ChatGroupModel.fromJson(value.data() as Map<String, dynamic>));
       lengh=allMembers[0].members?.length;
       print(allMembers[0].members?.length);
        emit(ChatGetMemberSuccessState());
     }).catchError((error){
       emit(ChatGetMemberGroupErrorState(error));
     });
  }

  //update group

  File? coverImage;
  Future<void> getCoverImage() async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null)
    {
      coverImage=File(pickedFile.path);
      emit(ChatGetCoverGroupImageSuccessState());
    }else
    {
      print("No image selected");
      emit(ChatGetCoverGroupImageErrorState());
    }
  }
  void uploadingCoverGroupImage({
    @required String? name,
    @required String? gropUid,
    @required String? adminUid,
  } ){
    emit(ChatGroupUpdateLoadingState());
    firebase_storage
        .FirebaseStorage.instance
        .ref()//enter
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")//name image
        .putFile(coverImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name,cover: value,gropUid: gropUid,adminUid: adminUid);
        emit(ChatGroupUploadCoverImageSuccessState());
      }).catchError((error){
        emit(ChatGroupUploadCoverImageErrorState());
      });
    }).catchError((error){
      emit(ChatGroupUploadCoverImageErrorState());
    });
  }
  void updateUser({
    @required String? name,
    @required String? gropUid,
    @required String? adminUid,
    @required String? groupImage,
    String?cover,
  }){

    ChatGroupModel  Model = ChatGroupModel(
        name: name,
        id: gropUid,
        adminUid:adminUid ,
        groupImage: cover??groupImage,
      );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('groups')
        .doc(gropUid)
        .update(Model.toMap()).then((value){
          getAvailableGroups();
     // getGroupDetails(gropUid);
    }).catchError((error){
      emit(ChatGroupUpdateErrorState());
    });
  }

}