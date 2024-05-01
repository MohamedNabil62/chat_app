import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../chat_login/chat_login_screen.dart';
bool islast=false;
class BoradingModel{
  late final String? title;
  late final String? image;
  late final String? body;
  BoradingModel({
   @required this.title,
   @required this.body,
  @required  this.image
});
}
List<BoradingModel>borading=[
  BoradingModel(
      title:"Welcome to ChatApp" ,
      body:"Connect with friends and share moments instantly!" ,
      image: "assets/images/1.jpg"
  ),
  BoradingModel(
      title:"Private Conversations" ,
      body:"Initiate personal chats with your favorite contacts." ,
      image: "assets/images/2.jpg"
  ),
  BoradingModel(
      title:"Create Group Chats" ,
      body:"Bring friends together in a shared space for seamless communication." ,
      image: "assets/images/3.jpg"
  ),
];
 submit(context){
  CacheHelper.saveData(kay: "onborading", value:true).then((value) {
     if(value)
       {
         navigtorAndFinish(context, ChatLoginScreen());
       }
  });
}
var boradercontroller=PageController();
class onBorading extends StatefulWidget {
  const onBorading({Key? key}) : super(key: key);

  @override
  State<onBorading> createState() => _onBoradingState();
}

class _onBoradingState extends State<onBorading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){
            submit(context);
          },
              child:Text("SKIP",
              style: TextStyle(
                color: myColor
              ),
              )
          )
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: boradercontroller,
                onPageChanged: (index) {
                  if(index==borading.length-1)
                    {
                      setState(() {
                        islast=true;
                      });
                    }
                  else{
                    setState(() {
                      islast=false;
                    });
                  }
                },
                itemBuilder:(context, index) => buildBoradingItem(borading[index] ),
                   itemCount: borading.length,

            ),
          ),
          SizedBox(height: 40,),
          Row(
            children: [
              SmoothPageIndicator(controller: boradercontroller,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 4,
                    spacing: 5,
                    activeDotColor:myColor
                  ),
                  count: borading.length
              ),
              Spacer(),
              FloatingActionButton(
                  onPressed: (){
                    if(islast)
                      {
                        submit(context);
                      }
                    else{
                        boradercontroller.nextPage(
                            duration: const Duration(
                                milliseconds: 750
                            ),
                            curve: Curves.fastLinearToSlowEaseIn //شكل النقله
                        );
                     }
                  },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
               backgroundColor:myColor,
              )
            ],
          )
          ]
        ),

      ),
    );
  }
}
 Widget buildBoradingItem(BoradingModel bording) =>  Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Expanded(
         child: Image(
           image: AssetImage('${bording.image}'),
         ),
       ),
       SizedBox(height: 30,),
       Text("${bording.title}",
         style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold
         ),
       ),
       SizedBox(height: 15,),
       Text("${bording.body}",
         style: TextStyle(
             fontSize: 14,
             fontWeight: FontWeight.bold
         ),
       ),
       SizedBox(height: 30,),
     ]
 );