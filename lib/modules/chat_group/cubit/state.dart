abstract class ChatGroupStates{}

class  ChatCreateGroupInitialState extends ChatGroupStates{}

class ChatCreateGroupLoadingState extends ChatGroupStates{}

class  ChatCreateGroupSuccessState extends ChatGroupStates{}

class  ChatCreateGroupErrorState extends ChatGroupStates{

  final String error;
  ChatCreateGroupErrorState(this.error);
}

class  ChatMembersGroupSuccessState extends ChatGroupStates{}

class  ChatMembersCreateGroupErrorState extends ChatGroupStates{
  final String error;
  ChatMembersCreateGroupErrorState(this.error);
}

class  ChatGroupMessegeSuccessState extends ChatGroupStates{}

class  ChatGroupMessegeErrorState extends ChatGroupStates{
  final String error;
  ChatGroupMessegeErrorState(this.error);
}

class ChatAllGetGroupsSuccessState  extends ChatGroupStates{}

class ChatAllGetGroupsErrorState  extends ChatGroupStates{
  final String error;
  ChatAllGetGroupsErrorState(this.error);
}

class ChatAllGetGroupsLoadingState extends  ChatGroupStates{}

//send m

class ChatGroupSendMessageSuccessState extends ChatGroupStates{}

class ChatGroupSendMessageErrorState  extends ChatGroupStates{
  final String error;
  ChatGroupSendMessageErrorState(this.error);
}

//send image

class ChatPutMessageImageErrorState extends ChatGroupStates{
  final String error;
  ChatPutMessageImageErrorState(this.error);
}

class ChatGetDownloadURLMessageImageErrorState extends ChatGroupStates{
  final String error;
  ChatGetDownloadURLMessageImageErrorState(this.error);
}

//upload image

class ChatGroupMessageImageSuccessState  extends ChatGroupStates{}

class ChatGroupMessageImageErrorState  extends ChatGroupStates{}

class ChatGroupRemoveMessageImageState extends ChatGroupStates{}

//get m

class ChatGroupGetMessageSuccessState extends ChatGroupStates{}

class ChatGroupGetMessageLoadingState  extends ChatGroupStates{

}

//search
class ChatSearchSuccessState  extends ChatGroupStates{}

class ChatSearchErrorState  extends ChatGroupStates{
  final String error;
  ChatSearchErrorState(this.error);
}

class ChatSearchLoadingState extends ChatGroupStates{}

//addmamber

class ChatAddMemberSuccessState  extends ChatGroupStates{}

class ChatAddMemberErrorState  extends ChatGroupStates{
  final String error;
  ChatAddMemberErrorState(this.error);
}

class ChatAddMemberGroupErrorState  extends ChatGroupStates{
  final String error;
  ChatAddMemberGroupErrorState(this.error);
}

class ChatAddMemberLoadingState extends ChatGroupStates{}

//get member

class ChatGetMemberSuccessState  extends ChatGroupStates{}

class ChatGetMemberLoadingState  extends ChatGroupStates{}

class ChatGetMemberGroupErrorState  extends ChatGroupStates{
  final String error;
  ChatGetMemberGroupErrorState(this.error);
}

//update group

class ChatGetCoverGroupImageSuccessState extends ChatGroupStates{}

class ChatGetCoverGroupImageErrorState extends ChatGroupStates{}

class ChatGroupUpdateLoadingState extends ChatGroupStates{}

class ChatGroupUploadCoverImageSuccessState extends ChatGroupStates{}

class ChatGroupUploadCoverImageErrorState extends ChatGroupStates{}

class ChatGroupUpdateErrorState extends ChatGroupStates{}

//leave group

class ChatLeaveMemberSuccessState  extends ChatGroupStates{}

class ChatDeleteMemberSuccessState  extends ChatGroupStates{}

class ChatLeaveMemberErrorState  extends ChatGroupStates{
  final String error;
  ChatLeaveMemberErrorState(this.error);
}

class ChatLeaveMemberGroupErrorState  extends ChatGroupStates{
  final String error;
  ChatLeaveMemberGroupErrorState(this.error);
}

class ChatLeaveMemberLoadingState extends ChatGroupStates{}
//not

class YourLoadingStateG extends ChatGroupStates{}

class YourSuccessStateG extends ChatGroupStates{}

class YourErrorStateG extends ChatGroupStates{
  final String error;
  YourErrorStateG(this.error);
}