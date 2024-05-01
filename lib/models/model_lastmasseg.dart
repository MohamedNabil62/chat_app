
class LastMessageModel{

  String? datetime;
  String? text;
  LastMessageModel(
      {
        this.datetime,
        this.text,
      });
  LastMessageModel.forjson(Map<String,dynamic>json)
  {
    datetime=json['datetime'];
    text=json['text'];
  }
  Map<String,dynamic>toMap(){
    return {
      'datetime':datetime,
      "text":text,
    };
  }
}