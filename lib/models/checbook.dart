  
class CheckBookModel {
  int id;
  String name;
  String createTime;
  String closeTime;

  CheckBookModel({this.name, this.createTime, this.closeTime});
  ///构造函数
  CheckBookModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.createTime = map['createTime'];
    this.closeTime = map['closeTime'];
  }
}