import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_AddAccountPage();
}

class _AddAccountPage extends State<AddAccountPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("添加一个账户"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '名称'
              ),
            )
          ],)
        )
    );
  }
}