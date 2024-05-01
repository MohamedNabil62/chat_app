
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Diohelper
{
  static Dio? dio;

  static init()
  {
    dio=Dio(
      BaseOptions(
        //"https://newsapi.org/",
        baseUrl:"https://fcm.googleapis.com", //shop app
        receiveDataWhenStatusError:true ,
        headers: {
          'Content-Type':'application/json'
        }
      )
    );
  }
  static Future<Response?> postData(
  {
   required String url,

    required Map<String,dynamic> data,
}
) async{
    dio?.options.headers=
    {
      'Content-Type':'application/json',
      'Authorization':'key=AAAA5xuMMv0:APA91bHFqECrAO5fgX-Pw5FvuT3gwaLtyfsUCbVKfwB5TNtS9XKgucuo8hwGaDCtU_Q318dKG8g9lQGZi3AbF_STMzH4JVDvPKDJABbIvCLydRzfBPZYHxT52tEYQXxA8NGtvvGgZf4J'
    };
    return  dio?.post(url,data: data,);
  }

  static Future<Response?> putData(
      {
        required String url,
        required Map<String,dynamic> data,
        Map<String,dynamic>? query,
        String leng='en',
        String? token,
      }
      ) async{
    dio?.options.headers=
    {
      'Content-Type':'application/json',
      'lang':leng,
      'Authorization':token
    };
    return  dio?.put(
      url,queryParameters: query,data: data,);
  }

}