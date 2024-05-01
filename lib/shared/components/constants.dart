

import 'package:flutter/material.dart';
import '../../modules/chat_login/chat_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

Widget text({String? data="App",double? fonts=20,Color? color=Colors.black})
{
  return Text(data!,
    style: TextStyle(
      fontSize: fonts,
      color:color
  ),
    textAlign: TextAlign.center,
  );
}
Widget appbar({String? data="App",double? fonts=20,Color? color=Colors.black,Widget? titiel})
{
  return AppBar(
    title: Text(data!,
      style: TextStyle(
          fontSize: fonts,
          fontWeight: FontWeight.bold,
          color:color
      ),
      textAlign: TextAlign.center,
    ),

  );
}

void singeout(context){
  CacheHelper.reomveData(kay: "token").then((value) =>
      navigtorAndFinish(context,
          ChatLoginScreen()
      )
  );
}

void printfulltext(String text)
{
  final pattern=RegExp(".{1,800}");
  pattern.allMatches(text).forEach((element) => print(element.group(0)));
}

String? token='';

String? uId='';