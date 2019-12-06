
import 'dart:async';


import 'package:finances_manager/api/account_api.dart';
import 'package:finances_manager/constant.dart';
import 'package:finances_manager/models/account.dart';
import 'package:finances_manager/router.dart';
import 'package:finances_manager/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatefulWidget {

  AccountCard({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _AccountCardState();
  }
}

class _AccountCardState extends State<AccountCard>  {
  List<AccountModel> myAccount= List(); 
  AccountApi theApi = AccountApi();
  final _nameController = new TextEditingController();
  final _balanceController = new TextEditingController();
  String _selectBelongTo;
  bool loading = true;

  void requestAPI() async {
    Future(() => (theApi.getExistingAccount())).then((value) {
      myAccount=value;
      setState(() {
        loading = false;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    requestAPI();
  }
  @override
  Widget build(BuildContext context) {
    var accountWidget;
    if(myAccount.length==0){
      accountWidget=<Widget>[Text("空空如也~",style:Theme.of(context).textTheme.display1)];
    }
    else{
      accountWidget=myAccount.map((AccountModel account){
        return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(account.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  Text(account.createTime,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text("余额："+account.balance.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete), 
                    onPressed: () async {
                      await theApi.deleteAccount(account.id);
                      requestAPI();
                    },
                  )
                ],
              ),
            ),
            onTap: () {
              Router.push(context, Router.checkbookDetail, account.id);
            },
        );
      }).toList();
    }
    return Scaffold(
      body: Container(
        height: 180,
        child:Stack(
          children: <Widget>[
            Row(
              children:accountWidget,
            ),
            Offstage(
              child: LoadingWidget.getLoading(backgroundColor: Colors.transparent),
              offstage: !loading,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '新建账户',
        child: Icon(Icons.add),
        onPressed:  () {
          _nameController.clear();
          _balanceController.clear();
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return SimpleDialog(
                    title: Text('添加一个账户'),
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.all(10) ,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '名称'
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: TextField(
                                controller: _balanceController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '余额'
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text("所属人:"),
                                Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width - 150,
                                    decoration: BoxDecoration(
                                        border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
                                    ),
                                    child: DropdownButtonFormField(
                                      items: Constant.Persons.map((String p){
                                        return DropdownMenuItem(
                                          child: new Text(p),
                                          value: p,
                                        );
                                      }).toList(),
                                      hint: new Text('请选择所属人'),
                                      onChanged: (value){
                                        setState(() {
                                          _selectBelongTo = value;
                                        });
                                      },
                                      value: _selectBelongTo,
                                    )
                                )
                              ],
                            )
                          ],
                        ) 
                      ),
                      Padding(
                        padding:EdgeInsets.all(10) ,
                        child:RaisedButton(
                          child: Text("确定"), 
                          onPressed: () async {
                            await theApi.saveAccount(_nameController.value.text,double.parse(_balanceController.value.text),_selectBelongTo);
                            requestAPI();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                );
              });
            },
          ).then((val) {
            print(val);
          });
        },
      ),
    );
  
  }
}


