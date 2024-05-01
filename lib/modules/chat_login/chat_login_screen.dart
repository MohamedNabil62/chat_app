import 'package:chat_app/layout/chat_app/cubit/cubit.dart';
import 'package:chat_app/modules/chat_group/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/styles/colors.dart';
import '../../layout/chat_app/chat_layout.dart';
import '../../shared/components/constants.dart';
import '../chat_register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';
var emailcontroller=TextEditingController();
var passwordcontroller=TextEditingController();
var formkey=GlobalKey<FormState>();

class ChatLoginScreen extends StatelessWidget {
  const ChatLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ChatLoginCubit(),
      child: BlocConsumer<ChatLoginCubit,ChatLoginStates>(
        listener: (context, state) {
          if(state is ChatLoginErrorState)
          {
            showToast(
              text: state.error,
              state: ToastState.ERROR,
            );
          }
          if(state is ChatLoginSuccessState)
          {
            CacheHelper.saveData(
                kay: "uId",
                value:state.uId ).then((value) {
              uId=CacheHelper.getData(kay: "uId");
              print(uId);
              ChatCubit.get(context).getUserData();
              ChatGroupCubit.get(context).getAvailableGroups();
                navigtorAndFinish(context, ChatLayout());
            } );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("LOGIN",
                          style:Theme.of(context).textTheme.headline5,
                        ),
                        Text("login now To communicate with your friends",
                          style:Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Colors.grey
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (v) {
                            print(v);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("email must not be empty");
                            }
                            return null;
                          },
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.email),
                              labelText: "Email address",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0))

                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          onFieldSubmitted: (v){
                            if(formkey.currentState!.validate()){
                              ChatLoginCubit.get(context).userLogin(
                                  email: emailcontroller.text,
                                  password: passwordcontroller.text
                              );
                            }
                          },
                          obscureText: ChatLoginCubit.get(context).isPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("password must not be empty");
                            }
                            return null;
                          },
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(onPressed: () {

                                ChatLoginCubit.get(context).changePasswordVisibility();
                              },

                                  icon:Icon(ChatLoginCubit.get(context).suffix)
                              ),
                              labelText: "password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0))
                          ),
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition:state is! ChatLoginLoadingState,
                          builder: (context) => defaultbutton(function: (){
                            if(formkey.currentState!.validate()){
                              ChatLoginCubit.get(context).userLogin(
                                  email: emailcontroller.text,
                                  password: passwordcontroller.text
                              );
                            }
                          },
                              text: "Login".toUpperCase(),
                              colo:myColor
                          ),
                          fallback:(context) => Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text("Don't have an account?", style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                          defaultTextButten(
                            function: (){
                          navigtorAndFinish(context, ChatRegisterScreen());

                            },
                            text:"register",
                          )

                        ],)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
