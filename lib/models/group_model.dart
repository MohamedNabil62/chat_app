import 'message_model.dart';

class ChatGroupModel {
  String? name;
  List<Map<String, dynamic>>? members;
  String? id;
  String? adminUid;
  String? groupImage;
  MessageModel? lastMessage; // Add the lastMessage property

  ChatGroupModel({
    this.name,
    this.members,
    this.id,
    this.adminUid,
    this.groupImage,
    this.lastMessage,
  });

  ChatGroupModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    members = (json['members'] as List<dynamic>?)
        ?.map((member) => Map<String, dynamic>.from(member))
        .toList();
    id = json['id'];
    adminUid = json['adminUid'];
    groupImage = json['groupImage'];
    lastMessage = json['lastMessage'] != null
        ? MessageModel.forjson(json['lastMessage'])
        : null; // Deserialize lastMessage
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members,
      'id': id,
      'adminUid': adminUid,
      'groupImage': groupImage,
      'lastMessage': lastMessage?.toMap(), // Serialize lastMessage
    };
  }

  Map<String, dynamic> tomap() {
    return {
      'name': name,
      'id': id,
      'adminUid': adminUid,
      'groupImage': groupImage,
    };
  }
}
