abstract class ChatStates{}

class ChatInitialState extends ChatStates{}

class  ChatGetUserLoadingState extends ChatStates{}

class  ChatGetUserSuccessState extends ChatStates{}

class ChatGetUserErrorState extends ChatStates{
  final String error;
  ChatGetUserErrorState(this.error);
}
class ChatChangeBottemNaveState extends ChatStates{}

class ChatNewPostState extends ChatStates{}

class  ChatGetProfileImageSuccessState extends ChatStates{}

class ChatGetProfileImageErrorState extends ChatStates{}

class  ChatGetCoverImageSuccessState extends ChatStates{}

class ChatGetCoverImageErrorState extends ChatStates{}

class  ChatUploadProfileImageSuccessState extends ChatStates{}

class ChatUploadProfileImageErrorState extends ChatStates{}

class  ChatUploadCoverImageSuccessState extends ChatStates{}

class ChatUploadCoverImageErrorState extends ChatStates{}

class ChatUpdateErrorState extends ChatStates{}

class ChatUpdateLoadingState extends ChatStates{}


//chat

class  ChatAllGetUserLoadingState extends ChatStates{}

class  ChatAllGetUserSuccessState extends ChatStates{}

class ChatAllGetUserWithChatSuccessState extends ChatStates{}

class ChatAllGetUserErrorState extends ChatStates{
  final String error;
  ChatAllGetUserErrorState(this.error);
}

class ChatAllGetUserWithChatErrorState extends ChatStates{
  final String error;
  ChatAllGetUserWithChatErrorState(this.error);
}

//massege

class  ChatSendMessageSuccessState extends ChatStates{}

class ChatSendMessageErrorState extends ChatStates{
  final String error;
  ChatSendMessageErrorState(this.error);
}

class  ChatGetMessageSuccessState extends ChatStates{}

class ChatGetMessageLoadingState extends ChatStates{}

class ChatMessageImageSuccessState extends ChatStates{}

class ChatMessageImageErrorState extends ChatStates{}

class ChatRemoveMessageImageState extends ChatStates{}

//online

class ChatGetOnlineStatusState extends ChatStates {
  final bool? online;

  ChatGetOnlineStatusState(this.online);
}

class ChatGetAllChatUserIdsSuccessState extends ChatStates{}
class ChatGetAllChatUserIdsErrorState extends ChatStates{
  final String?error;
  ChatGetAllChatUserIdsErrorState(this.error);
}

//last message
class ChatLoadingState extends ChatStates{}

class ChatSuccessState extends ChatStates{}

class ChatErrorState extends ChatStates{}

//not
class YourLoadingState extends ChatStates{}

class YourSuccessState extends ChatStates{}

class YourErrorState extends ChatStates{
  final String error;
  YourErrorState(this.error);
}
