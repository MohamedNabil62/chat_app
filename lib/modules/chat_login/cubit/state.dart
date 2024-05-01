abstract class ChatLoginStates{}

class ChatLoginInitialState extends ChatLoginStates{}

class  ChatLoginLoadingState extends ChatLoginStates{}

class  ChatLoginSuccessState extends ChatLoginStates{
  final String? uId;
  ChatLoginSuccessState(this.uId);
}

class ChatLoginErrorState extends ChatLoginStates{
  final String error;
  ChatLoginErrorState(this.error);
}

class ChatChangePasswordVisibilityState extends ChatLoginStates{}