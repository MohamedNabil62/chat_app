
class MessageModel{
  String? image;
  String? senderuId;
  String? receiveruId;
  String? datetime;
  String? text;
  MessageModel(
      {
        this.senderuId,
        this.receiveruId,
        this.datetime,
        this.text,
        this.image
      });
  MessageModel.forjson(Map<String,dynamic>json)
  {
    senderuId=json['senderuId'];
    receiveruId=json['receiveruId'];
    datetime=json['datetime'];
   text=json['text'];
   image=json['image'];
  }
  Map<String,dynamic>toMap(){
    return {
      'senderuId':senderuId,
      'receiveruId':receiveruId,
      'datetime':datetime,
      "text":text,
      'image':image
    };
  }
}