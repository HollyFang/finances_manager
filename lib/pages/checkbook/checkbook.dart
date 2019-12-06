import 'dart:async';

import 'package:finances_manager/api/checkbook_api.dart';
import 'package:finances_manager/models/checbook.dart';
import 'package:finances_manager/router.dart';
import 'package:finances_manager/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class CheckBook extends StatefulWidget {

  CheckBook({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _CheckBookState();
  }
}

class _CheckBookState extends State<CheckBook>  {
  List<CheckBookModel> myAccount= List(); 
  CheckoutApi theApi = CheckoutApi();
  final _accountController = new TextEditingController();
  bool loading = true;

  void requestAPI() async {
    Future(() => (theApi.getExistingCheckbook())).then((value) {
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
      accountWidget=myAccount.map((CheckBookModel checkbook){
        return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(checkbook.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  Text(checkbook.createTime,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete), 
                    onPressed: () async {
                      await theApi.deleteCheckbook(checkbook.id);
                      requestAPI();
                    },
                  )
                ],
              ),
            ),
            onTap: () {
              Router.push(context, Router.checkbookDetail, checkbook.id);
            },
        );
      }).toList();
    }
    return Scaffold(
      body: Container(
        height: 130,
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
        tooltip: '新建账本',
        child: Icon(Icons.add),
        onPressed:  () {
          _accountController.clear();
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
                return SimpleDialog(
                    title: Text('添加一个账本'),
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.all(10) ,
                        child: TextField(
                          controller: _accountController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '名称'
                          ),
                        ), 
                      ),
                      Padding(
                        padding:EdgeInsets.all(10) ,
                        child:RaisedButton(
                          child: Text("确定"), 
                          onPressed: () async {
                            await theApi.saveCheckbook(_accountController.value.text.toString());
                            requestAPI();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                );
            },
          ).then((val) {
            print(val);
          });
        },
      ),
    );
  
  }
}


