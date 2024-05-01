import 'message_model.dart';

class ChatUserModel {
  String? name;
  String? email;
  String? uId;
  String? phone;
  bool? isEmailVerified;
  String? image;
  String? bio;
  String? cover;
  bool? status;
 // MessageModel? lastMessage; // Add this line to include lastMessage

  ChatUserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.isEmailVerified,
    this.image,
    this.bio,
    this.cover,
    this.status
  //  this.lastMessage, // Add this line
  });

  ChatUserModel.forjson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    uId = json['uId'];
    phone = json['phone'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    bio = json['bio'];
    cover = json['cover'];
    status=json['online'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      "uId": uId,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'bio': bio,
      'cover': cover,
      'online':status
    };
  }
}
