abstract class ChatRegisterStates{}

class  ChatRegisterInitialState extends ChatRegisterStates{}

class ChatRegisterLoadingState extends ChatRegisterStates{}

class  ChatRegisterSuccessState extends ChatRegisterStates{}

class  ChatRegisterErrorState extends ChatRegisterStates{

  final String error;
  ChatRegisterErrorState(this.error);
}

class  ChatRegisterSuccessCreateUserState extends ChatRegisterStates{
  final String? uId;
  ChatRegisterSuccessCreateUserState(this.uId);
}

class  ChatRegisterErrorCreateUserState extends ChatRegisterStates{

  final String error;
  ChatRegisterErrorCreateUserState(this.error);
}

class  ChatRegisterchangePasswordVisibilityState extends ChatRegisterStates{}