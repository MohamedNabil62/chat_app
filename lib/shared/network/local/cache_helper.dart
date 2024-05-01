import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
static SharedPreferences? sharedPreferences;
static init()async
{
  sharedPreferences=await SharedPreferences.getInstance();
}
static Future putData({
  @required String? kay,
  @required bool? value
}) async
{
  return await sharedPreferences?.setBool(kay!, value!);
}
static dynamic getData({
  @required String? kay,
})
{
  return  sharedPreferences?.get(kay!);
}

static Future saveData({
  @required String? kay,
  @required  dynamic value})async{
  if(value is String){
    return await sharedPreferences?.setString(kay!, value!);
  }
  if(value is int){
    return await sharedPreferences?.setInt(kay!, value!);
  }
  if(value is bool){
    return await sharedPreferences?.setBool(kay!, value!);
  }
  if(value is double){
    return await sharedPreferences?.setDouble(kay!, value!);
  }

}
static Future<bool?> reomveData({
  @required String? kay,
})async
{
 return await sharedPreferences?.remove(kay!);
}

}