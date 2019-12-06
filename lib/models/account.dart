  
class AccountModel {
  int id;
  String name;
  String createTime;
  String closeTime;
  double balance;
  String belongTo;

  AccountModel({this.id, this.name, this.createTime, this.closeTime,this.balance,this.belongTo});
  ///构造函数
  AccountModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.createTime = map['createTime'];
    this.closeTime = map['closeTime'];
    this.balance = map['balance'];
    this.belongTo=map['belongTo'];
  }
}