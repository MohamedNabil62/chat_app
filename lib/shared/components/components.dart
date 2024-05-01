// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';//import 'package:untitled/modules/web_view/webview_sc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../network/local/cache_helper.dart';
import '../styles/IconBroken.dart';
import '../styles/colors.dart';
import 'constants.dart';
Widget defaultbutton({
  double width = double.infinity,
  Color colo=Colors.red,
  double height=50,
  required VoidCallback function,
  @required String text="login",

} ) =>
    Container(
width:width,
height: height,
decoration:BoxDecoration(
borderRadius:BorderRadius.circular(10),
color:colo
),
child: MaterialButton(
  onPressed:function,child:
Text(text.toUpperCase(),
style:TextStyle(color:Colors.white,
fontWeight:FontWeight.bold),),
),
);
Widget defaultTextButten({
  required VoidCallback function,
@required String? text,}) =>
    TextButton(onPressed:function,
        child: Text(text!.toUpperCase(),style: TextStyle(
          color: myColor
        ),),

);
void nevgitto(context,Widget) => Navigator.push(context,
    MaterialPageRoute(builder: (context) => Widget
    )
);

void navigtorAndFinish(context,Widget) => Navigator.pushReplacement(context,
  MaterialPageRoute(builder: (context) => Widget,),
    result: (Route<dynamic> route ) => false,

);

void showToast(
{
  required String text,
  required ToastState state
}
    ) =>  Fluttertoast.showToast(
    msg:text,
    toastLength: Toast.LENGTH_SHORT,//android
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,//ios web
    backgroundColor: chooseToastcolor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum  ToastState{
  SUCCESS,ERROR,WARNING
}

Color chooseToastcolor(ToastState state){
  Color? color;
  switch(state){
    case  ToastState.SUCCESS:
      color=Colors.green;
      break;
    case ToastState.ERROR:
      color=Colors.red;
      break;
    case ToastState.WARNING:
      color=Colors.amber;
      break;
  }
  return color;


}

Widget meSlider( ) => Padding(
  padding: const EdgeInsets.all(15.0),
  child:   Container(
    color: Colors.grey,
    height: 1,
  ),
);

PreferredSizeWidget  defaultAppBar({
  required BuildContext context,
  String? text,
  List<Widget>?action,
}) => AppBar(
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: Icon(
      IconBroken.Arrow___Left_2
    ),
  ),
  titleSpacing: 5,
  title:Text(text!),
  actions:action,
);
class PhotoScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const PhotoScreen({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
              IconBroken.Arrow___Left_2
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  } }